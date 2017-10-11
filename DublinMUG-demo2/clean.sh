echo "Cleaning up resources from Demo 2"
echo "Deleting jobs"
kubectl delete jobs mongoshell0 --now
echo "Deleting pods"
kubectl delete pod -l role=mongo  --now
kubectl delete deployment -l run=demo-app
echo "Deleting mongo-watch"
kubectl delete job mongo-watch --now 
echo "Deleting stateful set"
kubectl delete statefulset mongo --now 
echo "Checking pods with label role=mongo still running"
kubectl get pods -l role=mongo
echo "Deleting services, persistent volumes and persistent volume claims with label role=mongo"
kubectl delete service,pvc,pv -l role=mongo --now
kubectl delete service app mongo-0

kubectl delete deployment mongod1