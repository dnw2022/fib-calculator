GIT_SHA=$(git rev-parse HEAD)

docker build -t dnw2022/fib-calc-client:latest -t dnw2022/fib-calc-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t dnw2022/fib-calc-server:latest -t dnw2022/fib-calc-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t dnw2022/fib-calc-worker:latest -t dnw2022/fib-calc-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

echo "$DOCKER_PASSWORD" | docker login -u $DOCKER_ID --password-stdin

docker push dnw2022/fib-calc-client:latest
docker push dnw2022/fib-calc-server:latest
docker push dnw2022/fib-calc-worker:latest

#docker push dnw2022/fib-calc-client:$GIT_SHA
#docker push dnw2022/fib-calc-server:$GIT_SHA
#docker push dnw2022/fib-calc-worker:$GIT_SHA

kubectl apply -f k8s

kubectl rollout restart deployment/client-deployment
kubectl rollout restart deployment/server-deployment
kubectl rollout restart deployment/worker-deployment
kubectl rollout restart deployment/my-release-ingress-nginx-controller

kubectl apply -f k8s-cert