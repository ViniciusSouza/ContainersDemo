# Pods Horizontal Scaling

In this case we will use the kubernetes *HorizontalPodAutoscaler* type to create more pod to handle the requests that our service is receving.

To kubernetes be able to scale up or down our pods we need to specify the resources used by each container in our deployment. The sum of all that resources will be the pod resource.

It's also a good pratice to specify the resources needed or kubenetes Scheduler will let your deployment use all the resources available.

To know more about K8s resources management access this [link](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/).


## Update the deployment

We are going to use the namespace *hpa-demo*.

``` bash
kubectl create namespace hpa-demo
```

In order to Kubernetes being able to upscalling the number of pods we have to provide the resources requests and limits.

``` yaml
resources:
    requests:
        memory: "64Mi"
        cpu: "250m"
    limits:
        memory: "128Mi"
        cpu: "500m"
```

``` bash
kubectl apply -f hpa-demo.yaml -n hpa-demo
```

Deploy the Horizontal Pod Autoscaler

``` bash
kubectl apply -f pod-auto-scalling.yaml -n hpa-demo
```

Execute the following command to retrieve the IP address from the service.

``` bash
kubectl get services -n hpa-demo -w
```

When you are able to see the external ip address, cancel the execution hitting *<ctrl+c>*.

Then execute the load-test script.
./load-test `<ip address>` `<time to wait between requests>`

``` bash
./load-test 127.0.0.1 0 1
```

In another terminal execute

``` bash
kubectl get pods -n hpa-demo -w
```

After 2 minutes, you will start to see the pods creation

``` bash
NAME                        READY     STATUS    RESTARTS   AGE
hpa-demo-6dc4d6c599-lwnnp   1/1       Running   0          2m
hpa-demo-6dc4d6c599-764z7   0/1       Pending   0         0s
hpa-demo-6dc4d6c599-764z7   0/1       Pending   0         0s
hpa-demo-6dc4d6c599-764z7   0/1       ContainerCreating   0         1s
```