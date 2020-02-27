wget 

kubectl apply -f ns-and-sa.yaml

kubectl apply -f rbac.yaml

kubectl apply -f nginx-config.yaml

kubectl apply -f custom-resource-definitions.yaml

kubectl apply -f nginx-ingress-daemon-set.yaml


kubectl apply -f loadbalancer.yaml



# kubectl get svc nginx-ingress --namespace=nginx-ingress
