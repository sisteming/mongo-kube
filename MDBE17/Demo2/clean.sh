gcloud config set project mdbe-demo2
kubectl config set-context gke_mdbe-demo2_europe-west1-c_mdbe-demo2
kubectl config set-cluster gke_mdbe-demo2_europe-west1-c_mdbe-demo2
kubectl config use-context gke_mdbe-demo2_europe-west1-c_mdbe-demo2

kubectl delete jobs mongoshell0 --now
kubectl delete pod -l role=mongo  --now
kubectl delete job mongo-watch --now 
kubectl delete statefulset mongo --now 
kubectl get pods -l role=mongo
kubectl delete service,pvc,pv -l role=mongo --now
kubectl delete deployment demo-app2
kubectl delete service demoapp2
