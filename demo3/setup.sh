gcloud config list project
gcloud auth login
gcloud auth application-default login
gcloud config set container/use_application_default_credentials true
gcloud container clusters get-credentials mdbw17cluster2   --zone europe-west1-b --project mdbw17v1
gcloud config set compute/zone us-central1-b
gcloud container clusters create example-cluster
gcloud auth application-default login
 gcloud container clusters create mdbw17cluster2 --cluster-version=1.6.2 --zone europe-west1-b --additional-zones europe-west1-c,europe-west1-d --num-nodes=1 \
  --local-ssd-count=1 --node-labels=env=prod,app=mongodb
Creating cluster mdbw17cluster2...done.
Created [https://container.googleapis.com/v1/projects/mdbw17v1/zones/europe-west1-b/clusters/mdbw17cluster2].
kubeconfig entry generated for mdbw17cluster2.
NAME            ZONE            MASTER_VERSION  MASTER_IP       MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
mdbw17cluster2  europe-west1-b  1.5.6           104.199.111.30  n1-standard-1  1.5.6         3          RUNNING