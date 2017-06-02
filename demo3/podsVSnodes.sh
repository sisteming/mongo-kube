kubectl get pods -o wide
NAME                READY     STATUS    RESTARTS   AGE       IP           NODE
mongo-0             1/1       Running   0          2m        10.116.0.3   gke-mdbw17cluster-default-pool-07dd2c0e-cj5m
mongo-1             1/1       Running   0          2m        10.116.1.4   gke-mdbw17cluster-default-pool-07dd2c0e-kcgd
mongo-2             1/1       Running   0          1m        10.116.0.4   gke-mdbw17cluster-default-pool-07dd2c0e-cj5m
mongo-watch-d0xcl   1/1       Running   0          2m        10.116.1.3   gke-mdbw17cluster-default-pool-07dd2c0e-kcgd