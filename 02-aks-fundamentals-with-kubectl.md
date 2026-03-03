# AKS Fundamentals with Kubectl commands (Imperative)


## Kubectl Get Commands
```
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

## Deployment
kubectl get deployments     # Get Deployments Info
kubectl get deploy          # Alias name for Deployments is deploy

## Multi Services
kubectl get pods,svc        # List all pods and Services
kubectl get rc,services     # List all replication controllers and services

# List from all namespaces
kubectl get pods --all-namespaces     # List all pods existing in all namespaces

# List a pod identified by type and name specified in "pod.yaml"
kubectl get -f pod.yaml

# Get all Objects in default namespace
kubectl get all
```


## Load Balancer Service [NETWORK]

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
# Expose Pod with a Service

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


## Clean-Up [DELETE]
```
## Delete Pod
kubectl delete pod <Pod-Name>                   # Delete Pod
kubectl delete pod my-first-pod     
[or]
kubectl delete pod/my-first-pod

## Delete Service
kubectl delete svc <Service-Name>               # Delete Service
kubectl delete svc my-first-service
[or]
kubectl delete svc/my-first-service

## Delete ReplicaSet
kubectl delete rc <ReplicaSet-Name>             # Delete ReplicaSet
kubectl delete rs my-helloworld-rs
[or]
kubectl delete rs/my-helloworld-rs

## Delete Deployment
kubectl delete deployment <ReplicaSet-Name>         # Delete Deployment
kubectl delete deployment my-first-deployment
[or]
kubectl delete deployment/my-first-deployment
```


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

## Deployment
kubectl describe deployment  <deployment-name>           # Describe Deployment 
kubectl describe deployment  my-helloworld-rs
[or]
kubectl describe deployment/<deployment-name>           # Describe Deployment
kubectl describe deployment/my-first-deployment
```


## Verify Logs
```
## PODs
kubectl logs <pod-name>             # POD Logs
kubectl logs my-first-pod
[or]
kubectl logs <pod-name>             # Stream POD logs with -f option
kubectl logs -f my-first-pod
```


## Get YAML Output of Pod & Service
```
# Get pod definition YAML output
kubectl get pod my-first-pod -o yaml   

# Get service definition YAML output
kubectl get service my-first-service -o yaml   
```

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
[OR]
kubectl describe pod/<Pod-Name>     # Describe the Pod
kubectl describe pod/my-first-pod

# Verify POD Logs
kubectl logs <pod-name>             # Dump Pod logs
kubectl logs my-first-pod

# Stream pod logs with -f option and access application to see logs
kubectl logs <pod-name>             # Stream pod logs with -f option
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
kubectl delete pod <Pod-Name>                   # Delete Pod
kubectl delete pod my-first-pod     
[or]
kubectl delete pod/my-first-pod
```


---
## 2. ReplicaSets

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
kubectl describe replicaset/<replicaset-name>       # Describe ReplicaSets
kubectl describe replicaset/my-helloworld-rs
[OR]
kubectl describe replicaset <replicaset-name>       # Describe ReplicaSets
kubectl describe replicaset my-helloworld-rs

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
- Expose ReplicaSet with a service (Load Balancer Service) to access the application externally (from internet)
```
# Expose ReplicaSet as a Service
kubectl expose rs <ReplicaSet-Name>  --type=LoadBalancer --port=80 --target-port=8080 --name=<Service-Name-To-Be-Created>
kubectl expose rs my-helloworld-rs  --type=LoadBalancer --port=80 --target-port=8080 --name=my-helloworld-rs-service 

# Get Service Info
kubectl get service         # Get Service Info
kubectl get svc             # Alias name for Service is svc                   

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
kubectl delete pod <Pod-Name>                   # Delete Pod

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

### Delete Service created for ReplicaSet
kubectl delete svc <Service-Name>           # Delete Service
kubectl delete svc my-first-service
[or]
kubectl delete svc/my-first-service

### Delete ReplicaSet
kubectl delete rc <ReplicaSet-Name>         # Delete ReplicaSet
kubectl delete rs my-helloworld-rs
[or]
kubectl delete rs/my-helloworld-rs

### Verify if Service & ReplicaSet got deleted
kubectl get svc
kubectl get rs
[OR]
kubectl get svc,rs
```

---
## 3. Deployments

1. Create Deployment
2. Scale the Deployment
3. Expose Deployment as a Service
4. Update Deployment
5. Rollback Deployment
6. Rolling Restarts
7. Pause & Resume Deployments
8. Canary Deployments (Will be covered at Declarative section of Deployments)


### 3. 1. Create Deployment
- Create Deployment to rollout a ReplicaSet
- Verify Deployment, ReplicaSet & Pods

```
# Create Deployment
kubectl create deployment <Deplyment-Name> --image=<Container-Image>
kubectl create deployment my-first-deployment --image=ghcr.io/stacksimplify/kubenginx:1.0.0 

# Verify Deployment
kubectl get deployments

# Describe Deployment
kubectl describe deployment <deployment-name>
kubectl describe deployment my-first-deployment

# Verify Deployment
kubectl get all
```

### 3. 2. Scaling the Deployment
- Scale the deployment to increase the number of replicas (pods)

```
# Scale Up the Deployment
kubectl scale --replicas=10 deployment/<Deployment-Name>
kubectl scale --replicas=10 deployment/my-first-deployment 

# Verify Deployment
kubectl get all

# Scale Down the Deployment
kubectl scale --replicas=2 deployment/my-first-deployment 
kubectl get all
```

### 3. 3. Expose Deployment as a Service
```
# Expose Deployment as a Service
kubectl expose deployment <Deployment-Name>  --type=LoadBalancer --port=80 --target-port=80 --name=<Service-Name-To-Be-Created>
kubectl expose deployment my-first-deployment --type=LoadBalancer --port=80 --target-port=80 --name=my-first-deployment-service

# Verify Deployment
kubectl get all

# Access the Application using Public IP
http://<External-IP-from-get-service-output>
```

### 3. 4. Update Deployment

- We can update deployments using two options
  1. Set Image
  2. Edit Deployment

#### Step-01: Updating Application version V1 to V2 using "Set Image" Option

##### Update Deployment
  - Observation: Please Check the container name in spec.container.name yaml output and make a note of it and replace in kubectl set image command

```
# Get Container Name from current deployment
kubectl get deployment my-first-deployment -o yaml

# Update Deployment - SHOULD WORK NOW
kubectl set image deployment/<Deployment-Name> <Container-Name>=<Container-Image> --record=true
kubectl set image deployment/my-first-deployment kubenginx=stacksimplify/kubenginx:2.0.0 --record=true
```

##### Verify Rollout Status (Deployment Status)
  - Observation: By default, rollout happens in a rolling update model, so no downtime.

```
# Verify Rollout Status 
kubectl rollout status deployment/my-first-deployment

# Verify Deployment
kubectl get all
```

##### Describe Deployment
  - Observation:
    - Verify the Events and understand that Kubernetes by default do "Rolling Update" for new application releases.
    - With that said, we will not have downtime for our application.

```
# Descibe Deployment
kubectl describe deployment my-first-deployment
```

##### Verify ReplicaSet & Pods
  - Observation: New ReplicaSet will be created for new version
  - Observation: Pod template hash label of new replicaset should be present for PODs letting us know these pods belong to new ReplicaSet.

```
# Verify Deployment
kubectl get all
```

##### Verify Rollout History of a Deployment
  - Observation: We have the rollout history, so we can switch back to older revisions using revision history available to us.

```
# Check the Rollout History of a Deployment
kubectl rollout history deployment/<Deployment-Name>
kubectl rollout history deployment/my-first-deployment  

# Verify Deployment
kubectl get all
```

##### Access the Application using Public IP
  - We should see Application Version:V2 whenever we access the application in browser

```
# Get Load Balancer IP
kubectl get svc

# Application URL
http://<External-IP-from-get-service-output>
```

#### Step-02: Update the Application from V2 to V3 using "Edit Deployment" Option
```
# Edit Deployment
kubectl edit deployment/<Deployment-Name> --record=true
kubectl edit deployment/my-first-deployment --record=true

# Change From 2.0.0
    spec:
      containers:
      - image: stacksimplify/kubenginx:2.0.0

# Change To 3.0.0
    spec:
      containers:
      - image: stacksimplify/kubenginx:3.0.0
```

##### Verify Rollout Status
  - Observation: Rollout happens in a rolling update model, so no downtime.

```
# Verify Rollout Status 
kubectl rollout status deployment/my-first-deployment
```

##### Verify Replicasets
  - Observation: We should see 3 ReplicaSets now, as we have updated our application to 3rd version 3.0.0

```
# Verify Deployment
kubectl get all

# Verify Rollout History
# Check the Rollout History of a Deployment
kubectl rollout history deployment/<Deployment-Name>
kubectl rollout history deployment/my-first-deployment   
```

##### Access the Application using Public IP
  - We should see Application Version:V3 whenever we access the application in browser

```
# Get Load Balancer IP
kubectl get svc

# Application URL
http://<External-IP-from-get-service-output>
```

### 3. 5. Rollback Deployment

- We can rollback a deployment in two ways.
  1. Previous Version
  2. Specific Version

#### Step-01: Rollback a Deployment to Previous Version
```
# Verify Rollout History
# Check the Rollout History of a Deployment
kubectl rollout history deployment/<Deployment-Name>
kubectl rollout history deployment/my-first-deployment  
```

##### Verify changes in each revision
  - Observation: Review the "Annotations" and "Image" tags for clear understanding about changes.

```
# List Deployment History with revision information
kubectl rollout history deployment/my-first-deployment --revision=1
kubectl rollout history deployment/my-first-deployment --revision=2
kubectl rollout history deployment/my-first-deployment --revision=3
```

##### Rollback to previous version
  - Observation: If we rollback, it will go back to revision-2 and its number increases to revision-4

```
# Undo Deployment
kubectl rollout undo deployment/my-first-deployment

# List Deployment Rollout History
kubectl rollout history deployment/my-first-deployment  

# Verify Deployment, Pods, ReplicaSets
kubectl get deploy
kubectl get rs
kubectl get po
kubectl get all
kubectl describe deploy my-first-deployment
```

##### Access the Application using Public IP

```
# Get Load Balancer IP
kubectl get svc

# Application URL
http://<External-IP-from-get-service-output>
```

#### Step-02: Rollback to Specific Version
```
# List Deployment Rollout History
kubectl rollout history deployment/<Deployment-Name>
kubectl rollout history deployment/my-first-deployment 

# Rollback Deployment to Specific Revision
kubectl rollout undo deployment/my-first-deployment --to-revision=3
```

##### List Deployment History
  - Observation: If we rollback to revision 3, it will go back to revision-3 and its number increases to revision-5 in rollout history

```
# List Deployment Rollout History
kubectl rollout history deployment/my-first-deployment  

# Verify Deployment
kubectl get all
```

##### Access the Application using Public IP
  - We should see Application Version:V3 whenever we access the application in browser

```
# Get Load Balancer IP
kubectl get svc

# Application URL
http://<Load-Balancer-IP>
```


#### Step-03: Rollback Restarts of Application
```
# Rolling Restarts
kubectl rollout restart deployment/<Deployment-Name>
kubectl rollout restart deployment/my-first-deployment

# Verify Deployment
kubectl get all
```



### 3. 6. Pause & Resume Deployments

#### Step-01: Check current State of Deployment & Application
```
# Check the Rollout History of a Deployment
kubectl rollout history deployment/my-first-deployment  
Observation: Make a note of last version number

# Get list of ReplicaSets
kubectl get rs
Observation: Make a note of number of replicaSets present.

# Access the Application 
http://<External-IP-from-get-service-output>
Observation: Make a note of application version
```

#### Step-02: Pausing a Deployment and Making Two Changes
```
# Pause the Deployment
kubectl rollout pause deployment/<Deployment-Name>
kubectl rollout pause deployment/my-first-deployment

# Update Deployment - Application Version from V3 to V4
kubectl set image deployment/my-first-deployment kubenginx=stacksimplify/kubenginx:4.0.0 --record=true

# Check the Rollout History of a Deployment
kubectl rollout history deployment/my-first-deployment  
Observation: No new rollout should start, we should see same number of versions as we check earlier with last version number matches which we have noted earlier.

# Get list of ReplicaSets
kubectl get rs
Observation: No new replicaSet created. We should have same number of replicaSets as earlier when we took note. 

# Make one more change: set limits to our container
kubectl set resources deployment/my-first-deployment -c=kubenginx --limits=cpu=20m,memory=30Mi
```

#### Step-03: Resume Deployment
```
# Resume the Deployment
kubectl rollout resume deployment/my-first-deployment

# Check the Rollout History of a Deployment
kubectl rollout history deployment/my-first-deployment  
Observation: You should see a new version got created

# Get list of ReplicaSets
kubectl get rs
Observation: You should see new ReplicaSet.

# Get Load Balancer IP
kubectl get svc

# Access the Application 
http://<External-IP-from-get-service-output>
Observation: You should see Application V4 version
```

#### Step-04: Clean-Up
```
# Delete Deployment
kubectl delete deployment my-first-deployment

# Delete Service
kubectl delete svc my-first-deployment-service

# Get all Objects from Kubernetes default namespace
kubectl get all
```

### 3. 7. Canary Deployments
- Will be covered at Declarative section of Deployments


---
## 4. Services

### Step-01: Introduction to Services
- **Service Types**
  1. ClusterIp
  2. NodePort
  3. LoadBalancer
  4. ExternalName
  5. Ingress
- We are going to look in to ClusterIP and LoadBalancer Service in this section with a detailed example. 
- LoadBalancer Type is primarily for cloud providers and it will differ cloud to cloud, so we will do it accordingly (per cloud basis)
- ExternalName doesn't have Imperative commands and we need to write YAML definition for the same, so we will look in to it as and when it is required in our course. 

### Step-02: ClusterIP Service - Backend Application Setup
- Create a deployment for Backend Application (Spring Boot REST Application)
- Create a ClusterIP service for load balancing backend application. 
```
# Create Deployment for Backend Rest App
kubectl create deployment my-backend-rest-app --image=stacksimplify/kube-helloworld:1.0.0 

# Get Deployments
kubectl get deployment

# Create ClusterIp Service for Backend Rest App
kubectl expose deployment my-backend-rest-app --port=8080 --target-port=8080 --name=my-backend-service

> Observation: We don't need to specify "--type=ClusterIp" because default setting is to create ClusterIp Service.

# Get Service 
kubectl get service
```
> **Important Note:** If backend application port (Container Port: 8080) and Service Port (8080) are same we don't need to use **--target-port=8080** but for avoiding the confusion i have added it. Same case applies to frontend application and service. 

>> **Backend HelloWorld Application Source** [kube-helloworld](https://github.com/stacksimplify/kubernetes-fundamentals/tree/master/00-Docker-Images/02-kube-backend-helloworld-springboot/kube-helloworld)


### Step-03: LoadBalancer Service - Frontend Application Setup
- We have implemented **LoadBalancer Service** multiple times so far (in pods, replicasets and deployments), even then we are going to implement one more time to get a full architectural view in relation with ClusterIp service. 
- Create a deployment for Frontend Application (Nginx acting as Reverse Proxy)
- Create a LoadBalancer service for load balancing frontend application. 
- **Important Note:** In Nginx reverse proxy, ensure backend service name `my-backend-service` is updated when you are building the frontend container. We already built it and put ready for this demo (stacksimplify/kube-frontend-nginx:1.0.0)

**Nginx Conf File**
```conf
server {
    listen       80;
    server_name  localhost;
    location / {
    # Update your backend application Kubernetes Cluster-IP Service name  and port below      
    # proxy_pass http://<Backend-ClusterIp-Service-Name>:<Port>;      
    proxy_pass http://my-backend-service:8080;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
> **Docker Image Location:** https://hub.docker.com/repository/docker/stacksimplify/kube-frontend-nginx
>> **Frontend Nginx Reverse Proxy Application Source** [kube-frontend-nginx](https://github.com/stacksimplify/kubernetes-fundamentals/tree/master/00-Docker-Images/03-kube-frontend-nginx)

```
# Create Deployment for Frontend Nginx Proxy
kubectl create deployment my-frontend-nginx-app --image=stacksimplify/kube-frontend-nginx:1.0.0 

# Get Deployments
kubectl get deployment

# Create LoadBalancer Service for Frontend Nginx Proxy
kubectl expose deployment my-frontend-nginx-app  --type=LoadBalancer --port=80 --target-port=80 --name=my-frontend-service

# Get Load Balancer IP
kubectl get svc
http://<External-IP-from-get-service-output>/hello

# Scale backend with 10 replicas
kubectl scale --replicas=10 deployment/my-backend-rest-app

# Test again to view the backend service Load Balancing
http://<External-IP-from-get-service-output>/hello
```

---