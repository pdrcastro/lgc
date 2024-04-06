
# Letsgetchecked Interview


This is the description of the steps for Letsgetchecked Interview for role the DevOps Lead.

# Tools
- kubectx 
- kubens
- tfenv 
## Tools Installation
`kubectx` ```https://github.com/ahmetb/kubectx```

`tfenv` ```https://github.com/tfutils/tfenv```

# Terraform 
- tfenv install 1.3.10

# IAM
- Create ACCCESS and SECRET_KEY for user interview

# Deploy Infrastructure
- Go to folder `terraform/virginia/` and the following commands:
 ```bash 
 terraform init
 terraform plan
 terraform apply
 ```
## YAML 
### EKS Configmap AWS-AUTH
The configuration of authorization to cluster can be found on configmap file `/yaml/aws-auth.yaml`. To deploy please run the following command:
```bash
kubectl apply -f aws-auth.yaml
```
# Add cluster to kubeconfig
```bash
aws eks update-kubeconfig --region us-east-1 --name eks-interview-virginia
```

# Custom Configs EKS
Inside the folder `/yaml/alb/`we can find the files for CRDs used by AWS ALB.
- cert-manager: adds certificates and certificate issuers as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates
- alb-full: CRD, roles and other resources for Ingress Controller ALB.
- alb-ingress-class: IngressClass ALB

# Application
- Create namespace
```kubectl create namespace helm-demo```
- Deploy helm Application
```helm install guestbook-demo ./guestbook/ --namespace helm-demo```
-  Check pods
```kubectl get pod -n helm-demo```

## Authors

- [@pdrcastro](https://github.com/pdrcastro)


