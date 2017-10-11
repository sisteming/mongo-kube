echo "Creating Persistent Volumes..."
kubectl apply -f demo2-persistentVolume.yaml
kubectl get pv

echo "Creating Persistent Volume Claims..."
kubectl apply -f demo2-persistentVolumeClaim.yaml
kubectl get pvc

echo "Creating Headless Service mongo on port 27017..."
kubectl apply -f demo2-headlessService.yaml

echo "Running mongo-watch to monitor and configure the MongoDB Replica Set..."
kubectl create -f client/mb_mongo-watch-job.yaml
kubectl get services

echo "Creating the Stateful Set..."
kubectl apply -f demo2-statefulset.yaml && sleep 5
kubectl get statefulSet 
kubectl describe statefulSet

echo "Monitor mongo-watch progress configuring the MongoDB Replica Set..."
sleep 10
kubectl get pods | grep watch | awk '{print $1}' | xargs kubectl logs 

echo "Checking the status of the replica set with rs.status()"
sleep 10
kubectl run mongoshell0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "rs.status()"
