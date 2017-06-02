$ kubectl get pod -o wide
NAME      READY     STATUS    RESTARTS   AGE       IP          NODE
mongo-0   1/1       Running   0          2m        10.0.1.14   gke-mdbw17cluster1-default-pool-517ad68e-0d36
mongo-1   1/1       Running   0          1m        10.0.2.11   gke-mdbw17cluster1-default-pool-517ad68e-d635
mongo-2   1/1       Running   0          1m        10.0.0.6    gke-mdbw17cluster1-default-pool-517ad68e-6jl0

 13:00:25  ~/MDBW17/GCE   system 
$ for i in 0 1 2; do kubectl exec mongo-$i -- hostname -f; done
mongo-0.mongo.default.svc.cluster.local
mongo-1.mongo.default.svc.cluster.local
mongo-2.mongo.default.svc.cluster.local