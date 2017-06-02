cd /Users/marco/MDBW17/GCE
# persistentStorage 
kubectl apply -f persistentStorageGCE.yaml
# headless Service 
kubectl apply -f mdb_0-headlessService.yaml
# StatefulSet 
kubectl apply -f MB-statefulSet-2703.yaml
kubectl get statefulset
kubectl describe statefulset

# describe pod with PV 
kubectl describe pod mongo-0

# show pods distribution
kubectl get pods -o wide
# Configure replicaset
kubectl create -f client/mb_mongo-watch-job.yaml

# Monitor progress
kubectl logs -f mongo-watch-nk07h

# Deploy App 
kubectl run demo-app --image=marcob/node-todo --port=8080
kubectl expose deployment demo-app --type=LoadBalancer --name=app

# Check Replica Set
kubectl run mongoshell0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "rs.status()"