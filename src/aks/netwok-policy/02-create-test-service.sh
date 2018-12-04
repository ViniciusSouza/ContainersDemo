#!/bin/bash

kubectl create namespace demo-web

kubectl apply -f 02-test-service.yaml -n demo-web
