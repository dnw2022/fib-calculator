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