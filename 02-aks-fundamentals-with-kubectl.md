# AKS Fundamentals with Kubectl commands (Imperative)

## 0. Basic AKS Kubectl Commands

```
# Configure Cluster Creds (kube config) for Azure AKS Clusters
az aks get-credentials --resource-group aks-rg1 --name aksdemo1


# Kubectl Get Commands
## Nodes
kubectl get nodes           # Get Worker Node Status
kubectl get nodes -o wide   # Get Worker Node Status with wide options

## Pods
kubectl get pods            # Get Pods list with status
kubectl get po              # Alias name for pods is po
kubectl get pods -o wide    # Get Pods list with wide options
[List pods with wide option which also provide Node information on which Pod is running]


## Service 
kubectl get service         # Get Service Info
kubectl get svc             # Alias name for Service is svc


# Inspect the config with Describe Command
## PODs
kubectl describe pod <Pod-Name>     # Describe the Pod
kubectl describe pod my-first-pod

kubectl describe pod/<Pod-Name>     # Describe the Pod
kubectl describe pod/my-first-pod

## Service
kubectl describe service <Service-Name>         # Describe Service
kubectl describe service my-first-service

kubectl describe service/<Service-Name>         # Describe Service
kubectl describe service/my-first-service



# Clean-Up [Delete]
kubectl delete pod <Pod-Name>       # Delete Pod
kubectl delete pod my-first-pod     # Delete Pod

```

## 1. PODs

### Create a pod
```
# Template
kubectl run <desired-pod-name> --image <Container-Image> 

# Creating first pod
kubectl run my-first-pod --image stacksimplify/kubenginx:1.0.0
kubectl run my-first-pod --image ghcr.io/stacksimplify/kubenginx:1.0.0

```

### List pod
```
# To get list of pod names
kubectl get pods            # Get Pods list with status
kubectl get pods -o wide    # Get Pods list with wide options

```

### Inspect a pod
```
# Inspect the config with Describe Command
kubectl describe pod <Pod-Name>     # Describe the Pod
kubectl describe pod/<Pod-Name>     # Describe the Pod

kubectl describe pod my-first-pod   # Describe the Pod
kubectl describe pod/my-first-pod   # Describe the Pod

```

### Delete a pod
```
# Delete Pod
kubectl delete pod <Pod-Name>
kubectl delete pod my-first-pod

```


## 2. Load Balancer Service

### Expose Pod with a Service

- Expose pod with a service (Load Balancer Service) to access the application externally (from internet)
- **Ports**
  - **port:** Port on which node port service listens in Kubernetes cluster internally
  - **targetPort:** We define container port here on which our application is running.
- Verify the following before LB Service creation
  - Azure Standard Load Balancer created for Azure AKS Cluster
    - Frontend IP Configuration
    - Load Balancing Rules
  - Azure Public IP 

```
# Create  a Pod
kubectl run <desired-pod-name> --image <Container-Image> 
kubectl run my-first-pod --image ghcr.io/stacksimplify/kubenginx:1.0.0 

# Expose Pod as a Service
kubectl expose pod <Pod-Name> --type=LoadBalancer --port=80 --name=<Service-Name>
kubectl expose pod my-first-pod --type=LoadBalancer --port=80 --name=my-first-service

# Get Service Info
kubectl get service
kubectl get svc

# Describe Service
kubectl describe service my-first-service

# Access Application
http://<External-IP-from-get-service-output>
```