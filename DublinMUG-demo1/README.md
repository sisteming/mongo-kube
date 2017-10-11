# Demo 1 


---------
# Steps required 

## Configuring gcloud to work from our command line
```
gcloud config list project
gcloud auth login
gcloud auth application-default login
gcloud config set container/use_application_default_credentials true
```

## Creating a new cluster 
```
gcloud container clusters create dublinmugcluster1110 --num-nodes=4 --local-ssd-count=1 --node-labels=env=prod,app=mongod
```

### Reviewing the output from cluster creation
```
Creating cluster dublinmugcluster1110...done.
Created [https://container.googleapis.com/v1/projects/mdbw17v1/zones/europe-west1-b/clusters/dublinmugcluster1110].
kubeconfig entry generated for mdbw17cluster2.
NAME            ZONE            MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
dublinmugcluster1110   europe-west1-b  1.6.2           104.199.111.30  n1-standard-1  1.6.2        3          RUNNING
```

## Creating mongod pod
```
kubectl run mongod1 --image=mongo -- mongod --port=27017
```

## Expose mongod on port 27017
```
kubectl expose deployment mongod1 --type=NodePort --port 27017 --name=mongo-0

```


## Deploy demo application on the Kubernetes cluster
- Deploy the app marcob/node-todo-local on port 8080
	```
	kubectl run demo-app --image=marcob/node-todo-local --port=8080
	```
	
- Expose the port 8080 from the demo APP on the external IP 

	```
	kubectl expose deployment demo-app --type=LoadBalancer --name=app
	```

- Get the public IP for the demo APP:
```
kubectl get services
```