#!/bin/bash
gcloud config set project mdbe-demo1
echo "CLEANING DEMO1!"
echo "-----------------"
echo "Deleting External IP for demo app" 
kubectl delete service demoapp1
echo "Deleting demo app on port 8080"
kubectl delete deployment demo-app

echo "Deleting mongod pod port"
kubectl delete service mongo-0
echo "mongod standalone pod"
kubectl delete deployment mongod1



gcloud config list project

kubectl get pods
kubectl get services