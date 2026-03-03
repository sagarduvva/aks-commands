# AKS Fundamentals with Kubectl commands (Imperative)

## Basic AKS Kubectl Commands

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

## ReplicaSets
kubectl get replicaset      # Get ReplicaSets Info
kubectl get rs              # Alias name for ReplicaSets is rs

## Multi Services
kubectl get pods,svc        # List all pods and Services
kubectl get rc,services     # List all replication controllers and services



# List from all namespaces
kubectl get pods --all-namespaces     # List all pods existing in all namespaces



# List a pod identified by type and name specified in "pod.yaml"
kubectl get -f pod.yaml



# Get all Objects in default namespace
kubectl get all



# Clean-Up [Delete]
## Delete Pod
kubectl delete pod <Pod-Name>               # Delete Pod
kubectl delete pod my-first-pod     
[or]
kubectl delete pod/my-first-pod

## Delete Service
kubectl delete svc <Service-Name>           # Delete Service
kubectl delete svc my-first-service
[or]
kubectl delete svc/my-first-service

## Delete ReplicaSet
kubectl delete rc <ReplicaSet-Name>         # Delete ReplicaSet
kubectl delete rs my-helloworld-rs
[or]
kubectl delete rs/my-helloworld-rs

```

---
---


## Inspect AKS with Kubectl Commands

```

# Inspect the config with Describe Command
## PODs
kubectl describe pod <Pod-Name>     # Describe the Pod
kubectl describe pod my-first-pod
[or]
kubectl describe pod/<Pod-Name>     # Describe the Pod
kubectl describe pod/my-first-pod

## Service
kubectl describe service <Service-Name>         # Describe Service
kubectl describe service my-first-service
[or]
kubectl describe service/<Service-Name>         # Describe Service
kubectl describe service/my-first-service

## ReplicaSets
kubectl describe rs <replicaset-name>           # Describe ReplicaSets
kubectl describe rs my-helloworld-rs
[or]
kubectl describe rs/<replicaset-name>           # Describe ReplicaSets
kubectl describe rs/my-helloworld-rs



# Verify Logs

## PODs
kubectl logs <pod-name>             # POD Logs
kubectl logs my-first-pod
[or]
kubectl logs <pod-name>             # Stream POD logs with -f option
kubectl logs -f my-first-pod



# Get YAML Output

## Get pod definition YAML output
kubectl get pod my-first-pod -o yaml   

## Get service definition YAML output
kubectl get service my-first-service -o yaml   



```

---
---

## 1. PODs

### Create a pod
```
# Template
kubectl run <desired-pod-name> --image <Container-Image> 

# Creating first pod
kubectl run my-first-pod --image stacksimplify/kubenginx:1.0.0
kubectl run my-first-pod --image ghcr.io/stacksimplify/kubenginx:1.0.0

```


### Expose Pod as a Service
- **Ports**
  - **port:** Port on which node port service listens in Kubernetes cluster internally
  - **targetPort:** We define container port here on which our application is running.
- **Type**
  - **LoadBalance:**

```
# Expose Pod as a Service
kubectl expose pod <Pod-Name> --type=LoadBalancer --port=80 --name=<Service-Name>
kubectl expose pod my-first-pod --type=LoadBalancer --port=80 --name=my-first-service
```

### List pod
```
# To get list of pod names
kubectl get pods            # Get Pods list with status
kubectl get pods -o wide    # Get Pods list with wide options

```

### Inspect a pod
```
# Inspect the POD config with Describe Command
kubectl describe pod <Pod-Name>     # Describe the Pod
kubectl describe pod my-first-pod

kubectl describe pod/<Pod-Name>     # Describe the Pod
kubectl describe pod/my-first-pod


# Verify POD Logs
kubectl logs <pod-name>             # Dump Pod logs
kubectl logs my-first-pod

# Stream pod logs with -f option and access application to see logs
kubectl logs <pod-name>
kubectl logs -f my-first-pod

```


### Connect to Container in a POD
```
# Connect to a Container in POD and execute commands
## Connect to Nginx Container in a POD
kubectl exec -it <pod-name> -- /bin/bash
kubectl exec -it my-first-pod -- /bin/bash

## Execute some commands in Nginx container
ls
cd /usr/share/nginx/html
cat index.html
exit

# Running individual commands in a Container
kubectl exec -it <pod-name> -- env

## Sample Commands
kubectl exec -it my-first-pod -- env
kubectl exec -it my-first-pod -- ls
kubectl exec -it my-first-pod -- ls /usr/share/nginx/html
kubectl exec -it my-first-pod -- cat /usr/share/nginx/html/index.html
```

### Get YAML Output of Pod & Service
```
# Get pod definition YAML output
kubectl get pod my-first-pod -o yaml   

# Get service definition YAML output
kubectl get service my-first-service -o yaml   
```

### Delete a pod
```
# Delete Pod
kubectl delete pod <Pod-Name>
kubectl delete pod my-first-pod

```

---
---

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

---
---


## 3. ReplicaSets


### Step-01: Create ReplicaSet
```
kubectl create -f replicaset-demo.yml
```

**replicaset-demo.yml**
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-helloworld-rs
  labels:
    app: my-helloworld
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-helloworld
  template:
    metadata:
      labels:
        app: my-helloworld
    spec:
      containers:
      - name: my-helloworld-app
        image: stacksimplify/kube-helloworld:1.0.0
```


### Step-02: Inspect a ReplicaSets
```
# List ReplicaSets
kubectl get replicaset            # Get list of ReplicaSets
kubectl get rs 

# Describe ReplicaSet
kubectl describe rs/<replicaset-name>       # Describe ReplicaSets
kubectl describe rs/my-helloworld-rs
[or]
kubectl describe rs <replicaset-name>       # Describe ReplicaSets
kubectl describe rs my-helloworld-rs

# Get list of Pods
kubectl get pods                            # Get Pods list with status
kubectl get pods -o wide                    # Get Pods list with wide options
kubectl describe pod <pod-name>             # Describe the Pod

# Verify the Owner of the Pod
- Verify the owner reference of the pod.
- Verify under **"name"** tag under **"ownerReferences"**. We will find the replicaset name to which this pod belongs to. 
kubectl get pods <pod-name> -o yaml
kubectl get pods my-helloworld-rs-c8rrj -o yaml 

```


## Step-03: Expose ReplicaSet as a Service
```
- Expose ReplicaSet with a service (Load Balancer Service) to access the application externally (from internet)
# Expose ReplicaSet as a Service
kubectl expose rs <ReplicaSet-Name>  --type=LoadBalancer --port=80 --target-port=8080 --name=<Service-Name-To-Be-Created>
kubectl expose rs my-helloworld-rs  --type=LoadBalancer --port=80 --target-port=8080 --name=my-helloworld-rs-service 

# Get Service Info
kubectl get service               # Get Service Info
kubectl get svc                   

- **Access the Application using External or Public IP**
http://<External-IP-from-get-service-output>/hello
```


## Step-04: Test Replicaset Reliability or High Availability 
```
- Test how the high availability or reliability concept is achieved automatically in Kubernetes
- Whenever a POD is accidentally terminated due to some application issue, ReplicaSet should auto-create that Pod to maintain desired number of Replicas configured to achive High Availability.

# To get Pod Name
kubectl get pods

# Delete the Pod
kubectl delete pod <Pod-Name>

# Verify the new pod got created automatically
kubectl get pods   (Verify Age and name of new pod)
``` 


## Step-05: Test ReplicaSet Scalability feature 
```
- Test how scalability is going to seamless & quick
- Update the **replicas** field in **replicaset-demo.yml** from 3 to 6.

## Before change
spec:
  replicas: 3

## After change
spec:
  replicas: 6

# Update the ReplicaSet

### Apply latest changes to ReplicaSet
kubectl replace -f replicaset-demo.yml

### Verify if new pods got created
kubectl get pods -o wide
```


## Step-06: Delete ReplicaSet & Service
```
# Delete ReplicaSet & Service

### Delete ReplicaSet
kubectl delete rc <ReplicaSet-Name>         # Delete ReplicaSet
kubectl delete rs my-helloworld-rs
[or]
kubectl delete rs/my-helloworld-rs

### Verify if ReplicaSet got deleted
kubectl get rs


### Delete Service created for ReplicaSet
kubectl delete svc <Service-Name>           # Delete Service
kubectl delete svc my-first-service
[or]
kubectl delete svc/my-first-service

### Verify if Service got deleted
kubectl get svc

```


---
---


## 4. Deployments
1. Create Deployment
2. Scale the Deployment
3. Expose Deployment as a Service
4. Update Deployment
5. Rollback Deployment
6. Rolling Restarts
7. Pause & Resume Deployments
8. Canary Deployments (Will be covered at Declarative section of Deployments)


### 4. 1. Create Deployment




### 4. 2. Scaling the Deployment




### 4. 3. Expose Deployment as a Service





### 4. 4. Update Deployment




### 4. 5. Rollback Deployment




### 4. 6. Pause & Resume Deployments





### 4. 7. Canary Deployments
- Will be covered at Declarative section of Deployments


