echo "Cleaning existing environment"
./clean.sh

echo "Setting up new environment except statefulset"
kubectl apply -f mdb_0-headlessService.yaml
kubectl apply -f persistentVolumeClaim.yaml
kubectl apply -f persistentVolume.yaml

echo "Next: kubectl apply -f MB-statefulSet-1703.yaml"
kubectl apply -f MB-statefulSet-1703.yaml
