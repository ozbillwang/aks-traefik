# Deploy application with Traefik to Azure Kubernetes Service (AKS)

This repo is forked from https://github.com/microsoft/mindaro. In original repo, it explains how `Bridge to kubernetes` works. But I do like the way to deploy an application with [Traefik](https://traefik.io/) within Azure Kubernetes Service (AKS)

So I update it with my requirement.

1. Remove the dependency for any Windows usage, such as WSL.
2. Tuning the scripts, remove the hardcodes.

### Prerequisite

* [install latest azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [install latest kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [install latest helm](https://helm.sh/docs/helm/helm_install/)
* [Deploy an Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal)
* update aks kube config locally

```
$ az login

# if you have multiple subscriptions
$ az account set -s <subscription name>

# merge the AKS kube config to your default ~/.kube/config
# It is better to backup ~/.kube/config first, before you run below command
$ az aks get-credentials -g $RGNAME -n $AKSNAME
```

### Create application "bikeapp"

```
$ bash ./bridge-quickstart.sh

Bridge to Kubernetes
Bike Sample App - Quickstart script
-----------------------------------

Using kubernetes namespace: bikeapp

helm install traefik ingress controller in bikeapp
Release "bikesharing-traefik-bikeapp" has been upgraded. Happy Helming!
NAME: bikesharing-traefik-bikeapp
LAST DEPLOYED: Sun Mar 21 14:56:32 2021
NAMESPACE: bikeapp
STATUS: deployed
REVISION: 13
TEST SUITE: None
NOTES:
1. Get Traefik's load balancer IP/hostname:

     NOTE: It may take a few minutes for this to become available.

     You can watch the status by running:

         $ kubectl get svc bikesharing-traefik --namespace bikeapp -w

     Once 'EXTERNAL-IP' is no longer '<pending>':

         $ kubectl describe svc bikesharing-traefik --namespace bikeapp | grep Ingress | awk '{print $3}'

2. Configure DNS records corresponding to Kubernetes ingress resources to point to the load balancer IP/hostname found in step 1

Waiting for BikeSharing ingress Public IP to be assigned...

BikeSharing ingress Public IP:  20.xx.xxx.xxx
The Nip.IO FQDN would be  20.xx.xxx.xxx.nip.io
---
Chart directory: samples/BikeSharingApp/charts/
helm install bikesharingapp (average time to install = 4 minutes)
Hang tight while we grab the latest from your chart repositories...
...
Update Complete. ⎈Happy Helming!⎈
Saving 9 charts
Deleting outdated charts
Release "bikesharingapp" has been upgraded. Happy Helming!
NAME: bikesharingapp
LAST DEPLOYED: Sun Mar 21 14:57:01 2021
NAMESPACE: bikeapp
STATUS: deployed
REVISION: 2
TEST SUITE: None

To try out the app, open the url:
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
bikeapp.bikesharingweb.20.xx.xxx.xxx.nip.io

```

It takes about 5~10 minutes, then you should be fine to access the bike sharing website via http://bikeapp.bikesharingweb.20.xx.xxx.xxx.nip.io

###  delete the application

```
kubectl delete ns bikeapp
```

### Understand how DNS with nip.io works

https://nip.io/

Below is the original README.

# Bridge to Kubernetes
 
Bridge to Kubernetes extends the Kubernetes perimeter to your development computer allowing you to write, test, and debug microservice code while connected to your Kubernetes cluster with the rest of your application or services. With this workflow, there is no need for extra assets, such as a Dockerfile or Kubernetes manifests. You can simply run your code natively on your development workstation while connected to the Kubernetes cluster, allowing you to test your code changes in the context of the larger application.

![Alt Text](https://aka.ms/bridge-to-k8s-graphic-non-isolated)

### Key Features:

#### Simplifying Microservice Development 
- Eliminate the need to manually source, configure and compile external dependencies on your development computer.  

#### Easy Debugging 
- Run your usual debug profile with the added cluster configuration. You can debug your code as you normally would while taking advantage of the speed and flexibility of local debugging. 

#### Developing and Testing End-to-End 
- Test end-to-end during development time. Select an existing service in the cluster to route to your development machine where an instance of that service is running locally. Request initiated through the frontend of the application running in Kubernetes will route between services running in the cluster until the service you specified to redirect is called. 

## Documentation
- [Visual Studio](https://aka.ms/bridge-to-k8s-vs-quickstart)
- [Visual Studio Code](https://aka.ms/bridge-to-k8s-vscode-quickstart)
- [How Bridge to Kubernetes Works](https://aka.ms/how-bridge-to-k8s-works)

## Roadmap
https://github.com/microsoft/mindaro/projects

## Purpose of this repository
This source repository primarily hosts *code samples* to support product guides, discussion of bugs/feature requests, as well as provide high-level insight into our product roadmap.

## Contributing
This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
