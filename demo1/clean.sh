echo "Cleaning previous resources from Demo 1"
kubectl delete deployments mongod1 mongod2 mongod3
kubectl delete services mongod1 mongod2 mongod3