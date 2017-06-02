echo "Cleaning previous resources from Demo 1"
kubectl delete deployments mongod1 mongod2 mongod3
kubectl delete services mongod1 mongod2 mongod3

echo "Starting mongod1, mongod2 and mongod3 pods for Demo 1"
kubectl run mongod1 --image=mongo -- mongod --port=27017 --replSet demo1
kubectl run mongod2 --image=mongo -- mongod --port=27017 --replSet demo1
kubectl run mongod3 --image=mongo -- mongod --port=27017 --replSet demo1

echo "Exposing services for mongod1, mongod2 and mongod3 ports"
kubectl expose deployment mongod1 --type=NodePort --port 27017
kubectl expose deployment mongod2 --type=NodePort --port 27017
kubectl expose deployment mongod3 --type=NodePort --port 27017
sleep 5

echo "Listing services currently configured"
kubectl get services

echo "Listing pods and node where they are running"
kubectl get pods -o wide

echo "Gathering node IP and port for the first mongod pod"
NODE=`minikube ip`
PORT=`kubectl get services --no-headers mongod1 | awk '{print $4}' | awk -F":" '{print $2}' | tr -d '/TCP'`

echo "Connecting to the first pod to set up the replica set"
mongo --host $NODE --port $PORT

echo "From the mongo shell, issue the following commands, using the correct IP addresses fro the kubectl get pods -o wide command"
echo "rs.initiate()"
echo "var cfg = rs.conf()"
echo 'cfg.members[0].host="172.17.0.3:27017"'
echo 'rs.reconfig(cfg)'
echo 'rs.add("172.17.0.4:27017")'
echo 'rs.add("172.17.0.7:27017")'

echo "MongoDB Replica Set now configured."