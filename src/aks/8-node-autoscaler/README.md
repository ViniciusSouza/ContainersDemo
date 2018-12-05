# Node Autoscaling

Node autoscaler need the resource request infomation to create new Node, Cluster autoscaller scan the agent node in every 10 seconds looking for pending pods or empty nodes. If the node stays empty for 10 minutes (by default) the node will be deleted.

To start the Cluster Autoscaler deployment you need to first set the permission using service principal with Contributor Role, if you have the client id and the client secret for the one used to create the AKS it can be used.

## Setting permission

I have two shell scripts one if you have the service principal information and the other if you don't.
This script will create the secret on AKS in the namespace kube-system

If you have the AKS Service principal

```bash
./1-permission-with-sp.sh
```

If you don't have the AKS Service Principal

``` bash
./1-permission-no-sp.sh
```

## Deploying the autoscaler

By default the agent nodes has the label **nodepool1**, and this yaml uses that premises to deploy the Cluster Autoscaler.

To check your cluster labels execute

``` bash
kubectl get nodes --show-labels
```

output

``` md
NAME                                             STATUS    ROLES     AGE       VERSION   LABELS
aks-nodepool1-16725936-0                         Ready     agent     1d        v1.11.5   agentpool=**nodepool1**,beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=Standard_DS2_v2,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eastus,failure-domain.beta.kubernetes.io/zone=1,kubernetes.azure.com/cluster=MC_aks-demo_aks-demo_eastus,kubernetes.io/hostname=aks-nodepool1-16725936-0,kubernetes.io/role=agent,node-role.kubernetes.io/agent=,storageprofile=managed,storagetier=Premium_LRS
aks-nodepool1-16725936-1                         Ready     agent     1d        v1.11.5   agentpool=nodepool1,beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=Standard_DS2_v2,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eastus,failure-domain.beta.kubernetes.io/zone=0,kubernetes.azure.com/cluster=MC_aks-demo_aks-demo_eastus,kubernetes.io/hostname=aks-nodepool1-16725936-1,kubernetes.io/role=agent,node-role.kubernetes.io/agent=,storageprofile=managed,storagetier=Premium_LRS
aks-nodepool1-16725936-2                         Ready     agent     1d        v1.11.5   agentpool=nodepool1,beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=Standard_DS2_v2,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=eastus,failure-domain.beta.kubernetes.io/zone=0,kubernetes.azure.com/cluster=MC_aks-demo_aks-demo_eastus,kubernetes.io/hostname=aks-nodepool1-16725936-2,kubernetes.io/role=agent,node-role.kubernetes.io/agent=,storageprofile=managed,storagetier=Premium_LRS
virtual-kubelet-virtual-kubelet-linux-eastus     Ready     agent     20h       v1.11.2   alpha.service-controller.kubernetes.io/exclude-balancer=true,beta.kubernetes.io/os=linux,kubernetes.io/hostname=virtual-kubelet-virtual-kubelet-linux-eastus,kubernetes.io/role=agent,type=virtual-kubelet
virtual-kubelet-virtual-kubelet-windows-eastus   Ready     agent     17h       v1.11.2   alpha.service-controller.kubernetes.io/exclude-balancer=true,beta.kubernetes.io/os=windows,kubernetes.io/hostname=virtual-kubelet-virtual-kubelet-windows-eastus,kubernetes.io/role=agent,type=virtual-kubelet
```

You can use multiple Cluster Autoscaler for each cluster label.

The Cluster Autoscaler deploymet by default set the minimun numbers of agent to 1 and the maximmum to 10.

OBS: If you have more agent nodes in your cluster after the deployment of cluster autoscaler with the minimun of 1, it will scale down the number of cluster.

To change that update the yaml with de desire state

``` md
--nodes=`<minimum>`:`<maximum>`:`<agent node label>`
```

``` yaml
--nodes=1:10:nodepool1
```

Deploy the Cluster Autoscaler deployment

``` bash
kubectl apply -f aks-cluster-autoscaler.yaml
```

Test it using the pod-scaling demo, HPA must to be in place for this demo being able to work.

''' md
../7-pod-scaling/load-test.sh `<external ip>` 0
'''

Check the pods, after 2 minutes the number of pods will start to grow.

'''bash
kubectl get pods -n hpa-demo
'''

Check the nodes

''' bash
kubectl get nodes
'''

As we already have three nodes at minimum the agent nodes will take some time to scale, but it will. To speed things, you can run more than one load-test.sh process.


After some time execute the command

``` bash
kubectl get nodes
```

You will notice a new node as part of our agent cluster.

``` bash
NAME                                             STATUS    ROLES     AGE       VERSION
aks-nodepool1-16725936-0                         Ready     agent     1d        v1.11.5
aks-nodepool1-16725936-1                         Ready     agent     1d        v1.11.5
aks-nodepool1-16725936-2                         Ready     agent     1d        v1.11.5
aks-nodepool1-16725936-3                         Ready     agent     1m        v1.11.5
virtual-kubelet-virtual-kubelet-linux-eastus     Ready     agent     1d        v1.11.2
virtual-kubelet-virtual-kubelet-windows-eastus   Ready     agent     1d        v1.11.2
```

Stop de script to see the numbers of nodes going to it's original state, repecting the minimum number of node for the pool.