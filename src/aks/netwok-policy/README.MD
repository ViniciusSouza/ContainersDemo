# Network Policy

To use [Kubernetes Network Policies](https://github.com/Azure/azure-container-networking/tree/master/npm) we have to have an AKS with Azure CNI.

Azure CNI can be deployed using:

- The advance mode for networking using the portal
- Using the az aks create with the option *--network-plugin azure*

## NPM Demonset

``` bash
#Create the demonset for network policy
kubectl apply -f https://raw.githubusercontent.com/Azure/acs-engine/master/parts/k8s/addons/kubernetesmasteraddons-azure-npm-daemonset.yaml

#check if the pods were created sucessfully
kubectl get pods -n kube-system --selector=k8s-app=azure-npm -o wide
```

## Deploy the test service

This is a simple we application, the same we use before.

``` bash
kubectl create namespace demo-web
kubectl apply -f 02-test-service.yaml -n demo-web
```

## List the service to retrive the public ip address

``` bash
kubectl get svc -n demo-web -w

NAME       TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
demo-web   LoadBalancer   10.0.38.9    **104.211.7.6**   80:31725/TCP   29m
```

Access the External-IP address in your browser, the "hello from docker image" message.

## Denny all inbound

Now we are going to create a rule to deny all inbound communication to the namespace

``` bash
kubectl apply -f 03-deny-all-inbound.yaml
```

After a few seconds try to access the same External-Ip address again, and you will notice that the service is no longer available.

This particular rule, blocks all services available at the namespace to be exposed.

## Enabling the service Demo-web

``` bash
kubectl apply -f 04-allow-demo-web.yaml
```

After applying this police the demo-web service will be accessible again.

The network policy accepts label selector the same way services does.