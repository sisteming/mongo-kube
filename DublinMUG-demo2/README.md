# Demo 2

In this demo, we perform the steps to get a MongoDB Replica Set configured and running on Kubernetes, using Google Cloud Engine.


---------

# Screencast of Demo 2:

![Demo1](demo3.gif)


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

## Creating persistentStorage in Google Cloud using SSD
```
kubectl apply -f demo3-persistentStorageGCE.yaml
```

## Creating Headless Service for service _mongo_ on port 27017
```
kubectl apply -f demo3-headlessService.yaml
```


## Creating Stateful Set for the MongoDB Replica Set
```
kubectl apply -f demo3-statefulSet-2703.yaml
kubectl get statefulset
kubectl describe statefulset
```

## Review pod and pod distribution


- Describe pod with PV 
	```
	kubectl describe pod mongo-0
	```

- Show pods distribution on nodes

	```
	kubectl get pods -o wide
	```


## Use mongo-watch to configure MongoDB Replica Set
```
kubectl create -f client/mb_mongo-watch-job.yaml
```


## Deploy demo to-do/Q&A application on the Kubernetes cluster
- Deploy the app marcob/node-todo on port 8080
	```
	kubectl run demo-app --image=marcob/node-todo --port=8080
	```
	
- Expose the port 8080 from the demo APP on the external IP 

	```
	kubectl expose deployment demo-app --type=LoadBalancer --name=app
	```


## Checking the MongoDB Replica Set status

```
kubectl run mongoshell0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "rs.status()"
```

---------

# Further improvements

## Resource requests and limits for containers

To apply resource request and limits to container for the Stateful Set, we can just define these in the container definition section for the Stateful Set YAML file.

For example:

```
spec:
  resources:
    requests:
      cpu: 70m
      memory: 160Mi
    limits:
      cpu: 110m
      memory: 200Mi
```

## Readiness Probe

Readiness probes in Kubernetes can be used to detect the current status of a pod. 

Example of a Readiness Probe for a MongoDB pod can be:

```
readinessProbe:
            exec:
              command:
                - sh
                - -c
                - "/usr/bin/mongo --eval 'printjson(db.serverStatus())'"
            initialDelaySeconds: 5
            timeoutSeconds: 5
```




