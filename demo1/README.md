# Demo 1 from MongoDB World 

In this demo, we perform simple steps to get a MongoDB Replica Set configured and running on Kubernetes, using manual steps.

For this particular demo, minikube is used to deploy a single-node, local Kubernetes cluster.

---------

# Screencast of Demo 1:

![Demo1](demo11.gif)


---------
# Steps required 

## Starting minikube using virtualbox
```
minikube start --memory=8096 --disk-size=20g --vm-driver=virtualbox
Starting local Kubernetes cluster...
Starting VM...
SSH-ing files into VM...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.
```


## Running 3 pods, one for each replica set member

```
kubectl run mongod1 --image=mongo -- mongod --port=27017 --replSet demo1
kubectl run mongod2 --image=mongo -- mongod --port=27017 --replSet demo1
kubectl run mongod3 --image=mongo -- mongod --port=27017 --replSet demo1
```

## Exposing port 27017 for each with a Service (NodePort)

```
kubectl expose deployment mongod1 --type=NodePort --port 27017
kubectl expose deployment mongod2 --type=NodePort --port 27017
kubectl expose deployment mongod3 --type=NodePort --port 27017
```


## Listing services currently configured
```
kubectl get services
```


## Listing pods currently running, including the node where they run
- Check the IP for each pod as these will use for during the replica set configuration
```
kubectl get pods -o wide
```


## Configuring the replica set with the correct IP addresses 

- Gather the IP address for the node running `mongod1` and the port where it's running:
	
	```
	NODE=`minikube ip`
	PORT=`kubectl get services --no-headers mongod1 | awk '{print $4}' | awk -F":" '{print $2}' | tr -d '/TCP'`
	```

- Connect to the first pod and initialise the replica set:

	```
	mongo --host $NODE --port $PORT
	rs.initiate()
	```
- Update the initial configuration so that the first node is configured using its IP address:

	```
	var cfg = rs.conf()
	cfg.members[0].host="172.17.0.3:27017"
	rs.reconfig(cfg)
	```
	
- Add the remaining nodes of the replica set using their IP address and port:

	```
	rs.add("172.17.0.4:27017")
	rs.add("172.17.0.7:27017")
	```
	
## Connecting to the replica set

```
mongo --host $NODE --port $PORT
rs.status()
```

## Cleaning up the environment from demo1
```
kubectl delete deployments mongod1 mongod2 mongod3
kubectl delete services mongod1 mongod2 mongod3
```



