#!/bin/bash

ACRName="visouzaacr"
RG="aks-demo"
LOCATION=eastus

az acr create -g $RG -n $ACRName -l $LOCATION --sku Basic --admin-enabled true
