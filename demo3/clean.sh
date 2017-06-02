kubectl delete jobs mongoshell0 mongoshell1 mongoshellm0 mongoshellm1 mongoshellm2 --now
kubectl delete pod -l role=mongo  --now
kubectl delete job mongo-watch --now 
kubectl delete statefulset mongo --now 
kubectl get pods -l role=mongo
kubectl delete service,pvc,pv -l role=mongo --now
kubectl delete deployment demo-app
kubectl delete service app
kubectl delete service demo-app
