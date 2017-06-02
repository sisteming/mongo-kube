kubectl apply -f persistentVolume.yaml
kubectl get pv
kubectl apply -f persistentVolumeClaim.yaml
kubectl get pvc
kubectl apply -f mdb_0-headlessService.yaml
kubectl create -f client/mb_mongo-watch-job.yaml
kubectl get services
kubectl apply -f MB-statefulSet-2703.yaml
kubectl get statefulSet
sleep 30
kubectl describe statefulSet
sleep 10
kubectl get pods | grep watch | awk '{print $1}' | xargs kubectl logs

echo "Checking the status of the replica set"
sleep 20
kubectl run mongoshell0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "rs.status()"

echo "Waiting 20 seconds to start insert workload"
sleep 20

kubectl run mongoshell1 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "\
            for (var i=0; i<100; i++) { \
            	a=db.kube.insert({x:i,y:i,z:i}); \
                print(i,a)  \
            }"
            

echo "Querying primary and secondaries"
echo "Primary: mongo-0"
kubectl run mongoshellm0 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-0.mongo --quiet workload --eval "db.kube.count()"
echo "Secondary: mongo-1"
kubectl run mongoshellm1 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-1.mongo --quiet workload --eval "rs.slaveOk();db.kube.count()"
echo "Secondary: mongo-2"
kubectl run mongoshellm2 --image=marcob/mongo-watch -i -t --rm --restart=OnFailure -- mongo --host mongo-2.mongo --quiet workload --eval "rs.slaveOk();db.kube.count()"