#!/bin/bash
gcloud config set project mdbe-demo2
kubectl config set-context gke_mdbe-demo2_europe-west1-c_mdbe-demo2
kubectl config set-cluster gke_mdbe-demo2_europe-west1-c_mdbe-demo2
kubectl config get-contexts
echo "WELCOME TO DEMO2!"
echo "-----------------"
echo "Creating Persistent Volumes..."
kubectl apply -f demo2-persistentStorageGCE.yaml
kubectl get pv

echo "Creating Headless Service mongo on port 27017..."
kubectl apply -f demo2-headlessService.yaml

echo "Running mongo-watch to monitor and configure the MongoDB Replica Set..."
kubectl create -f client/mb_mongo-watch-job.yaml
kubectl get services --context=gke_mdbe-demo2_europe-west1-c_mdbe-demo2

echo "Creating the Stateful Set..."
kubectl apply -f demo2-statefulset.yaml && sleep 20


# Check Replica Set
kubectl run mongoshell0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "rs.status()"


echo "Monitor mongo-watch progress configuring the MongoDB Replica Set..."
sleep 10
kubectl get pods --context=gke_mdbe-demo2_europe-west1-c_mdbe-demo2 | grep watch | awk '{print $1}' | xargs kubectl logs -f 



echo "Checking the status of the replica set with rs.status()"
sleep 20
kubectl run mongoshell0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "rs.status()"



# Deploy App
kubectl run demo-app2 --image=marcob/node-todo-mdbe --port=8080
kubectl apply -f service.yaml

kubectl get statefulSet --context=gke_mdbe-demo2_europe-west1-c_mdbe-demo2
kubectl describe statefulSet --context=gke_mdbe-demo2_europe-west1-c_mdbe-demo2
kubectl config get-contexts
