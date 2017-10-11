kubectl run mongod1 --image=mongo -- mongod --port=27017

kubectl expose deployment mongod1 --type=NodePort --port 27017 --name=mongo-0

kubectl run demo-app --image=marcob/node-todo-local --port=8080

kubectl expose deployment demo-app --type=LoadBalancer --name=app

kubectl get pods -o wide

kubectl get services