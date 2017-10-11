docker build -f mongo-watch.docker -t mongo-watch .
docker image tag mongo-watch marcob/mongo-watch
docker push marcob/mongo-watch