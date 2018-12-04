# Open Service Broker for Azure (OSBA)

 Open Service Broker for Azure, a new implementation of our service broker that is Open Service Broker-compatible and can be deployed on multiple cloud native platforms.

 With OSBA you can have a helm chart that creates resoruces on AKS and also the Azure Resources it may depend.

 The service is still in preview, meaning that only a small subset of azure resources are available at the moment of this writing. Check [OSBA GitHub repostitory](https://github.com/Azure/open-service-broker-azure) for a updated list.

## Azure Wordpress Helm Chart

Go thru [Wordpress Repo](https://github.com/Azure/helm-charts/tree/master/wordpress/templates) to show the usage of the OSBA in a Helm Chart.

## Deploying in out Cluster

Be sure that you have helm installed, by executing.

``` bash
helm version
```

If you don't have helm installed go to [3-helm](../3-helm/README.md)

``` bash
helm repo add azure Azure/helm-charts
helm install azure/service-broker
helm install azure/wordpress --namespace azure
```
