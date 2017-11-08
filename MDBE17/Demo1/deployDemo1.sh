#!/bin/bash
gcloud config set project mdbe-demo1
kubectl config set-context gke_mdbe-demo1_europe-west1-c_mdbe-demo1
kubectl config set-cluster gke_mdbe-demo1_europe-west1-c_mdbe-demo1
kubectl config get-contexts
echo "WELCOME TO DEMO1!"
echo "-----------------"
echo "Deploying mongod standalone pod"
kubectl run mongod1 --image=mongo -- mongod --port=27017 
echo "Exposing mongod pod port"
kubectl expose deployment mongod1 --type=NodePort --port 27017 --name=mongo-0
echo "Deploying demo app on port 8080"
kubectl run demo-app --image=marcob/node-todo-local --port=8080
echo "Exposing External IP for demo app" 
kubectl apply -f appLocal/service.yaml

gcloud config list project

kubectl get pods --context=gke_mdbe-demo1_europe-west1-c_mdbe-demo1
kubectl get services --context=gke_mdbe-demo1_europe-west1-c_mdbe-demo1
kubectl config get-contexts 