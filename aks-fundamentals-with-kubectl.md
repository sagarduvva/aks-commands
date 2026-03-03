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



# Inspect the config with Describe Command
kubectl describe pod <Pod-Name>     # Describe the Pod
kubectl describe pod/<Pod-Name>     # Describe the Pod

kubectl describe pod my-first-pod   # Describe the Pod
kubectl describe pod/my-first-pod   # Describe the Pod





# Clean-Up [Delete]
kubectl delete pod <Pod-Name>       # Delete Pod
kubectl delete pod my-first-pod     # Delete Pod

```

## 1. PODs

### Create a pod
. Creating first pod

```
# Template
kubectl run <desired-pod-name> --image <Container-Image> 

# Creating first pod
kubectl run my-first-pod --image stacksimplify/kubenginx:1.0.0
kubectl run my-first-pod --image ghcr.io/stacksimplify/kubenginx:1.0.0

# To get list of pod names
kubectl get pods

# Inspect the config with Describe Command
kubectl describe pod <Pod-Name>     # Describe the Pod
kubectl describe pod/<Pod-Name>     # Describe the Pod

kubectl describe pod my-first-pod   # Describe the Pod
kubectl describe pod/my-first-pod   # Describe the Pod

# Delete Pod
kubectl delete pod <Pod-Name>
kubectl delete pod my-first-pod

```