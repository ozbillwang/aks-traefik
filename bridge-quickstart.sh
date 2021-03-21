#!/bin/bash
set -e

# Prerequisite
# azure cli: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
# kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
# helm: https://helm.sh/docs/helm/helm_install/
# Deploy an Azure Kubernetes Service (AKS)
# update aks kube config: az aks get-credentials -g $RGNAME -n $AKSNAME

INGRESSNAME=bikesharing-traefik
BIKENS="bikeapp"

# update the version if required.
TRAEFIK_CHART_VERSION="9.17.5"

echo ""
echo "Bridge to Kubernetes"
echo "Bike Sample App - Quickstart script"
echo "-----------------------------------"
echo ""

echo "Using kubernetes namespace: $BIKENS"

echo ""
echo "install traefik ingress controller in $BIKENS"
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm upgrade --install "$INGRESSNAME-$BIKENS" traefik/traefik \
   --namespace $BIKENS --create-namespace \
   --set kubernetes.ingressClass=traefik \
   --set fullnameOverride=$INGRESSNAME \
   --set rbac.enabled=true \
   --set kubernetes.ingressEndpoint.useDefaultPublishedService=true \
   --version ${TRAEFIK_CHART_VERSION}

echo ""
echo "Waiting for BikeSharing ingress Public IP to be assigned..."
while [ -z "$PUBLICIP" ]; do
  sleep 5
  PUBLICIP=$(kubectl get svc -n $BIKENS $INGRESSNAME -o jsonpath={.status.loadBalancer.ingress[0].ip})
done

echo ""
echo "BikeSharing ingress Public IP: " $PUBLICIP

NIPIOFQDN="$PUBLICIP.nip.io"
echo "The Nip.IO FQDN would be $NIPIOFQDN"
 
CHARTDIR="samples/BikeSharingApp/charts/"
echo "---"
echo "Chart directory: $CHARTDIR"

echo "install bikesharingapp (average time to install = 4 minutes)"
helm dependency update "$CHARTDIR" 
helm upgrade --install bikesharingapp "$CHARTDIR" \
   --set bikesharingweb.ingress.hosts={$BIKENS.bikesharingweb.$NIPIOFQDN} \
   --set gateway.ingress.hosts={$BIKENS.gateway.$NIPIOFQDN} \
   --set bikesharingweb.ingress.annotations."kubernetes\.io/ingress\.class"=traefik \
   --set gateway.ingress.annotations."kubernetes\.io/ingress\.class"=traefik \
   --namespace $BIKENS \
   --timeout 9m \
   --atomic

echo ""
echo "To try out the app, open the url:"
kubectl -n $BIKENS get ing bikesharingweb -o jsonpath='{.spec.rules[0].host}'
echo ""

