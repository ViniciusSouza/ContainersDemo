#!/bin/bash

#Create AKS with AZURE CNI
k8sClusterName="aks-demo"
RG="aks-demo"
LOCATION=eastus
VnetName="aks-vnet-demo"
SubnetName="aks-subnet"

#Install az aks-cli & kubectl
#sudo az aks install-cli

#Create azure resources
az group create -n $RG -l $LOCATION

az network vnet create -g $RG -n $VnetName --address-prefix 192.168.0.0/16 --subnet-name $SubnetName --subnet-prefix 192.168.1.0/24
SubnetID=`az network vnet subnet show -g $RG -n $SubnetName --vnet-name $VnetName --query id -o json | tr -d '"'`

az aks create -n $k8sClusterName -g $RG -l $LOCATION --vnet-subnet-id $SubnetID --network-plugin azure --kubernetes-version 1.11.5 --node-count 3 --generate-ssh-keys
az aks get-credentials -n $k8sClusterName -g $RG