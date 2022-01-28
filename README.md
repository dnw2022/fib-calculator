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