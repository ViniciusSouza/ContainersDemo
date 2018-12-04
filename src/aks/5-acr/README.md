# Azure Container Registry (ACR)

Private image repository to deploy containers, works with any engine that are complaint with the Docker format.

## Creating Azure Container Register

For this demo we are going to create a ACR using the same resource group of aks, this is not a requiriment.

`1-create-acr.sh` content

```bash
ACRName="visouzaacr"
RG="aks-demo"
LOCATION=eastus

az acr create -g $RG -n $ACRName -l $LOCATION --sku Basic --admin-enabled true
```

run the shel script

``` bash
./1-create-acr.sh
```

## Tagging image to use ACR

To be able to push our images to ACR with have to tag them using the following pattern `<acr-name>`.azurecr.io/`image-name`:`tag`

docker tag `<local image name>` `<new name repecting the pattern>`

``` bash
docker tag visouza/httpd:demo visouzaacr.azurecr.io/httpd:demo
```

## Docker Login

To login we'll use the Azure Cli.

``` bash
az acr login -n visouzaacr
```
if the admin login is enable *--admin-enabled* we can also login with the user and password (avaialble at the portal).

## Docker Push

To push our image to Azure Container Registry, we are going to use the regular *docker push*

``` bash
docker push visouzaacr.azurecr.io/httpd:demo
```

## Deploy the image to the AKS

``` bash
kubectl apply -f visouza-httpd-demo-no-secret.yaml
```

Show the pod error

``` bash
kubectl get pods
```

## Using ACR with Kubernetes

There are two different ways to use ACR with AKS

1) Using Kubernetes Secrets
2) Using AKS Service Principal (requires Azure Contributor Access).

In both cases we need to perform all the steps above to have our image available at the ACR.

## Using Kubernetes Secrets

If you don't have Contributor access to your Azure Subscription, this is the right method for you. Basically we are going to create a new service principal with the Reader role to our Azure Container Register and then we are going to create a secret at the kubernetes using the service principal information.

The screts is created by namespace, what implies that if you want to use the same ACR in another namespace, first you need to create the secret for this namespace too.

Using K8s secret also implies that you use in your yaml files.

``` yaml
imagePullSecrets:
      - name: acr-auth #secret name
```

The script that we are going to use is the following `2-grant-acr-with-secret.sh`

``` bash
#!/bin/bash
set -e

ACR_NAME=visouzaacr
SERVICE_PRINCIPAL_NAME=acr-visouza-service-principal
AKS_SECRET_NAME=acr-auth

# Populate the ACR login server and resource id.
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Create a 'Reader' role assignment with a scope of the ACR resource.
SP_PASSWD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --role Reader --scopes $ACR_REGISTRY_ID --query password --output tsv)

# Get the service principal client id.
CLIENT_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output used when creating Kubernetes secret.
echo "Service principal ID: $CLIENT_ID"
echo "Service principal password: $SP_PASSWD"

echo "Creating Kubernetes Secret"
kubectl create secret docker-registry $AKS_SECRET_NAME --docker-server $ACR_LOGIN_SERVER --docker-username $CLIENT_ID --docker-password $SP_PASSWD --docker-email azure@aks_demo.com
echo "Secret created using the name $AKS_SECRET_NAME"
```

Execute the following script to create your secret at the default namespace.

``` bash
./2-grant-acr-with-secret.sh
```

Upate the deployment using the changed yaml file

``` bash
kubectl apply -f visouza-httpd-demo-with-secret.yaml
```

Show the pod and the service.

```bash
kubectl get pods
kubectl get services -w
```

## Using AKS Service Principal (requires Azure Contributor Access)

This is the preferable way to do to keep it simple, as we don't need to create secret for each namespace we have and neither update the yaml files.

When we create an AKS on Azure you can specify a particular SP (Service Principal) or let Azure CLi to create one for us. The script will work in both ways, so you don't need to worry.

Content of the file `3-grant-acr-with-aks-sp.sh`

``` bash
#!/bin/bash

AKS_RESOURCE_GROUP=aks-demo
AKS_CLUSTER_NAME=aks-demo
ACR_RESOURCE_GROUP=aks-demo
ACR_NAME=visouzaacr


# Get the id of the service principal configured for AKS
CLIENT_ID=$(az aks show --resource-group $AKS_RESOURCE_GROUP --name $AKS_CLUSTER_NAME --query "servicePrincipalProfile.clientId" --output tsv)

# Get the ACR registry resource id
ACR_ID=$(az acr show --name $ACR_NAME --resource-group $ACR_RESOURCE_GROUP --query "id" --output tsv)

# Create role assignment
az role assignment create --assignee $CLIENT_ID --role Reader --scope $ACR_ID
```

Just execute the script

``` bash
./3-grant-acr-with-aks-sp.sh
```

Crete another namespace

``` bash
kubectl create namespace acrdemo
```

deploy the same deployment with no secret that gave a error before.

``` bash
kubectl apply -f visouza-httpd-demo-no-secret.yaml -n acrdemo
```

Show the pod and the service.

```bash
kubectl get pods -n acrdemo
kubectl get services -n acrdemo -w
```