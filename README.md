# AWS elastic beanstalk deployment

https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/20695748#questions

https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11437392#questions/16125718

https://aws.amazon.com/blogs/containers/automated-software-delivery-using-docker-compose-and-amazon-ecs/

# Autocompletion kubectl zsh

https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/

# Restart deployment

kubectl rollout restart deployment <deployment>
kubectl rollout restart -f client-deployment.yml

# Kubernetes secrets

kubectl create secret generic <secret_name> --from-literal <secrets_key_value_pairs> 
kubectl create secret generic postgres-pwd --from-literal PGPASSWORD=postgres_password

# Kubernetes resource limits
The vscode yaml linter for kubernetes complains about not mentioning resource limits, but be careful when specifying limits because you might get errors starting containers without any error messages because of resources being unavailable.

resources:
  limits:
    memory: "128Mi"
    cpu: "500m"

for every deployment does not work!

this might also be an issue with the available resources for docker desktop

Minikube might be better?

https://itnext.io/goodbye-docker-desktop-hello-minikube-3649f2a1c469

The problem with minikube at the moment is that it only works with the docker driver and almost none of the addins are supported when using
this driver.

# Docker desktop and ingress

Install helm if not installed yet:

brew install helm

The follow instructions here: https://kubernetes.github.io/ingress-nginx/deploy/#quick-start

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

kubectl --namespace ingress-nginx get services -o wide -w ingress-nginx-controller (to check if it was started successfully)

# Docker desktop kubernetes dashboard

See: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/15492160#questions

To install see: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui
Do not forget to create a sample user to login to the dashboard

Run: kubectl proxy

Dashboard is then available under:

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Get token using:

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

# Travis deploy

docker run -it -v $(pwd):/app ruby:2.4 sh
gem install travis

https://docs.travis-ci.com/user/github-oauth-scopes/#repositories-on-httpstravis-cicom-private-and-public:

travis login --github-token <github_token> --com

travis encrypt-file service-account.json -r dnw2022/fib-calculator --com

# Google Cloud deploy

See: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/17417508#questions

Initialize the google cloud terminal:

gcloud config set project multi-k8s-339908
gcloud config set compute/zone europe-central2-a
gcloud container clusters get-credentials multi-cluster

Use the kubernetes terminal to create a secret for the postgres-pwd:

kubectl create secret generic postgres-pwd --from-literal PGPASSWORD=postgres_password_xxxx

Also install helm:

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

And ingress using helm:

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-release ingress-nginx/ingress-nginx

# GKE deploy with service account in github actions

create a service-account for the kubernetes cluster and download the json file with the keypair. Then base64 encode it and add it in github as a secret:

cat multi-k8s-339908-e1853ea369e6.json | base64

# GKE alternative for service account in github actions

https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions

# Kubernetes custom domain google cloud

https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/25482916#search
https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm
https://zozoo.io/kubernetes-certmanager-with-dns-authenticator-using-cloudflare/

kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.0 \
  --set installCRDs=true

Cloudflare setup. See: https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/

Beware: https://github.com/jetstack/cert-manager/issues/263

kubectl create secret generic cloudflare-api-key-secret -n cert-manager --from-literal api-key=xxx

kubectl get clusterIssuers
kubectl get cr -n default
kubectl get order
kubectl get challenge
kubectl get certificates -n default

kubectl get deployment -n cert-manager

kubectl scale --replicas=0 deployment my-release-ingress-nginx-controller

kubectl scale --replicas=0 deployment cert-manager -n cert-manager
kubectl scale --replicas=0 deployment cert-manager-cainjector -n cert-manager
kubectl scale --replicas=0 deployment cert-manager-webhook -n cert-manager

kubectl scale --replicas=1 deployment cert-manager -n cert-manager
kubectl scale --replicas=1 deployment cert-manager-cainjector -n cert-manager
kubectl scale --replicas=1 deployment cert-manager-webhook -n cert-manager

kubectl delete order --all && kubectl delete challenge --all && kubectl delete certificates --all
kubectl get order,challenge,certificates

# Skaffold

https://skaffold.dev/docs/install/

brew install skaffold

BUG: had to add ENV CI=true to the client Dockerfile.dev to prevent it from continously crashing. Only happens when running using skaffold! See: https://github.com/GoogleContainerTools/skaffold/issues/3882