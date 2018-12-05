#! /bin/bash
AKS_NAME=aks-demo
AKS_RG=aks-demo
CLIENT_ID=
CLIENT_SECRET=

ID=`az account show --query id -o json`
SUBSCRIPTION_ID=`echo $ID | tr -d '"' `
TENANT=`az account show --query tenantId -o json`
TENANT_ID=`echo $TENANT | tr -d '"' | base64`
CLUSTER_NAME=`echo $AKS_NAME | base64`
RESOURCE_GROUP=`echo $AKS_RG | base64`
CLIENT_ID_B64=`echo $CLIENT_ID | base64`
CLIENT_SECRET_B64=`echo $CLIENT_SECRET | base64`
SUBSCRIPTION_ID=`echo $ID | tr -d '"' | base64 `
NODE_RESOURCE_GROUP=`az aks show --name $cluster_name  --resource-group $resource_group -o tsv --query 'nodeResourceGroup' | base64`

echo "---
apiVersion: v1
kind: Secret
metadata:
    name: cluster-autoscaler-azure
    namespace: kube-system
data:
    ClientID: $CLIENT_ID
    ClientSecret: $CLIENT_SECRET
    ResourceGroup: $RESOURCE_GROUP
    SubscriptionID: $SUBSCRIPTION_ID
    TenantID: $TENANT_ID
    VMType: QUtTCg==
    ClusterName: $CLUSTER_NAME
    NodeResourceGroup: $NODE_RESOURCE_GROUP
---" > secret.yaml

kubectl apply -f secret.yaml -n kube-system
