 https://console.cloud.google.com/apis/api/container.googleapis.com/overview?project=seraphic-vertex-182218

 gcloud container clusters create dublinmugcluster1110 --num-nodes=4 --local-ssd-count=1 --node-labels=env=prod,app=mongodb


 $ gcloud container clusters create dublinmugcluster1110 --num-nodes=4 --local-ssd-count=1 --node-labels=env=prod,app=mongodb
Creating cluster dublinmugcluster1110...done.
Created [https://container.googleapis.com/v1/projects/seraphic-vertex-182218/zones/europe-west1-c/clusters/dublinmugcluster1110].
kubeconfig entry generated for dublinmugcluster1110.
NAME                  ZONE            MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
dublinmugcluster1110  europe-west1-c  1.7.6-gke.1     35.195.180.94  n1-standard-1  1.7.6         4          RUNNING

 kubectl run demo-app --image=marcob/node-todo --port=8080
 kubectl run mongod1 --image=mongo -- mongod --port=27017 --replSet demo1
 kubectl run mongod2 --image=mongo -- mongod --port=27017 --replSet demo1
 kubectl run mongod3 --image=mongo -- mongod --port=27017 --replSet demo1


 docker build -t marcob/node-todo-local . && docker push marcob/node-todo-local