


wget https://raw.githubusercontent.com/murrayhenwood/k8s-quickstart/master/nginx/ns-and-sa.yaml
wget https://raw.githubusercontent.com/murrayhenwood/k8s-quickstart/master/nginx/rbac.yaml
wget https://raw.githubusercontent.com/murrayhenwood/k8s-quickstart/master/nginx/nginx-config.yaml
wget https://raw.githubusercontent.com/murrayhenwood/k8s-quickstart/master/nginx/custom-resource-definitions.yaml
wget https://raw.githubusercontent.com/murrayhenwood/k8s-quickstart/master/nginx/nginx-ingress-daemon-set.yaml
wget https://raw.githubusercontent.com/murrayhenwood/k8s-quickstart/master/nginx/loadbalancer.yaml




kubectl apply -f ns-and-sa.yaml

kubectl apply -f rbac.yaml

kubectl apply -f nginx-config.yaml

kubectl apply -f custom-resource-definitions.yaml

kubectl apply -f nginx-ingress-daemon-set.yaml

kubectl apply -f loadbalancer.yaml



# kubectl get svc nginx-ingress --namespace=nginx-ingress
