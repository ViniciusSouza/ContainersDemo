#!/bin/bash


#Create the demonset for network policy
kubectl apply -f https://raw.githubusercontent.com/Azure/acs-engine/master/parts/k8s/addons/kubernetesmasteraddons-azure-npm-daemonset.yaml

#check if the pods were created sucessfully
kubectl get pods -n kube-system --selector=k8s-app=azure-npm -o wide
