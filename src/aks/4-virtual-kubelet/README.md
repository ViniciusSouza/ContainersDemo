# Virtual Kubelet

Azure Container Instances (ACI) provide a hosted environment for running containers in Azure. When using ACI, there is no need to manage the underlying compute infrastructure, Azure handles this management for you. When running containers in ACI, you are charged by the second for each running container.

When using the Virtual Kubelet provider for Azure Container Instances, both Linux and Windows containers can be scheduled on a container instance as if it is a standard Kubernetes node. This configuration allows you to take advantage of both the capabilities of Kubernetes and the management value and cost benefit of container instances [from our docs](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/aks/virtual-kubelet.md).

## Prerequisites

- Azure CLI 2.0.33 or later
- Helm have to be installed in your Kubernetes


## Installing

We are going to use *az aks install-connector* which uses helm to get the service done check it at [GitHub](https://github.com/virtual-kubelet/virtual-kubelet/tree/master/providers/azure).

''' bash
az aks install-connector --resource-group aks-demo --name aks-demo --connector-name virtual-kubelet --os-type Both
'''

This command used the aks-demo name, change that to match your environment.

It install the virutal kubelet that allow *both* operational system Windows and Linux.

``` bash
Deploying the ACI connector for 'Linux' using Helm
NAME:   virtual-kubelet-linux-eastus
LAST DEPLOYED: Tue Dec  4 12:30:29 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME                                                  AGE
virtual-kubelet-linux-eastus-virtual-kubelet-for-aks  1s

==> v1/ServiceAccount
virtual-kubelet-linux-eastus-virtual-kubelet-for-aks  1s

==> v1beta1/ClusterRoleBinding
virtual-kubelet-linux-eastus-virtual-kubelet-for-aks  1s

==> v1beta1/Deployment
virtual-kubelet-linux-eastus-virtual-kubelet-for-aks  1s

==> v1/Pod(related)

NAME                                                             READY  STATUS             RESTARTS  AGE
virtual-kubelet-linux-eastus-virtual-kubelet-for-aks-6755cf2ph8  0/1    ContainerCreating  0         1s


NOTES:
The virtual kubelet is getting deployed on your cluster.

To verify that virtual kubelet has started, run:

  kubectl --namespace=default get pods -l "app=virtual-kubelet-linux-eastus-virtual-kubelet-for-aks"

Note:
TLS key pair not provided for VK HTTP listener. A key pair was generated for you. This generated key pair is not suitable for production use.
Deploying the ACI connector for 'Windows' using Helm
NAME:   virtual-kubelet-windows-eastus
LAST DEPLOYED: Tue Dec  4 12:30:39 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME                                                    AGE
virtual-kubelet-windows-eastus-virtual-kubelet-for-aks  1s

==> v1/ServiceAccount
virtual-kubelet-windows-eastus-virtual-kubelet-for-aks  1s

==> v1beta1/ClusterRoleBinding
virtual-kubelet-windows-eastus-virtual-kubelet-for-aks  1s

==> v1beta1/Deployment
virtual-kubelet-windows-eastus-virtual-kubelet-for-aks  1s


NOTES:
The virtual kubelet is getting deployed on your cluster.

To verify that virtual kubelet has started, run:

  kubectl --namespace=default get pods -l "app=virtual-kubelet-windows-eastus-virtual-kubelet-for-aks"
```

To check if the installation successed, execute.

``` bash
kubectl get nodes

NAME                                             STATUS    ROLES     AGE       VERSION
aks-nodepool1-16725936-0                         Ready     agent     16h       v1.11.5
aks-nodepool1-16725936-1                         Ready     agent     16h       v1.11.5
aks-nodepool1-16725936-2                         Ready     agent     16h       v1.11.5
virtual-kubelet-virtual-kubelet-linux-eastus     Ready     agent     2m        v1.11.2
virtual-kubelet-virtual-kubelet-windows-eastus   Ready     agent     2m        v1.11.2
```

## Deploying a sample service usin ACI (Azure Container Instance)

We are going to use the node selector (**nodeSelector:**) at the yaml to specify what type of OS we are going to use.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: aci-helloworld-linux
  labels:
    app: aci-helloworld-linux
spec:
  ports:
  - port: 80
    name: http
    targetPort: 80
  selector:
    app: aci-helloworld-linux
  type: LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: aci-helloworld-linux
spec:
  replicas: 1
  selector:
    matchLabels:
      app: aci-helloworld-linux
  template:
    metadata:
      labels:
        app: aci-helloworld-linux
    spec:
      containers:
      - name: aci-helloworld-linux
        image: microsoft/aci-helloworld
        ports:
        - containerPort: 80
      nodeSelector:
        beta.kubernetes.io/os: linux
        kubernetes.io/role: agent
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Equal
        value: azure
        effect: NoSchedule
```

To star using it lets deploy to containers, linux and windows.

''' bash
kubectl apply -f 1-ACI-helloworld-linux.yaml
kubectl apply -f 2-ACI-helloworld-windows.yaml
'''

Run the command to wait until you got the public ip

''' bash
kubectl get services -w
'''

Open the browser and test it using the public external IP.