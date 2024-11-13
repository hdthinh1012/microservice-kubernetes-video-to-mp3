# Microservice Video-to-Mp3 converter with Kubernetes, RabbitMQ Flask Python, MySQL, MongoDB
## Overview
The project consists of 5 different service
- Gateway (Python)
- Auth (Python)
- Video-to-Mp3 Converter (Python)
- Notification (Python)
- RabbitMQ

## Setup
### Python services virtual env
Change directory to each of Python service folder (auth,gateway,converter,notification), then run commands to create virtual environment and install dependency
```cmd
python -m venv venv
.\venv\bin\Activate.ps1
pip install -r requirements.txt
```
### Deploy local Kubernetes
Install these dependency
- kubectl (K8s CLI tool to interact with Kubernetes API)
- K9s (K8s Management GUI)
- minikube (Local Kubernetes Instance Container)
- AWS CLI
- AWS Tools for Powershell (ECR module)
- MySQL 8.

### Setup MySQL
The auth service pod will interact with MySQL running local machine host (native)
Change directory to auth and execute init.sql

```cmd
mysql -u root -e "source init.sql"
```

### Deployment
Start minikube
```powershell
minikube start
```
Execute script
```powershell
.\deployment\StartDeploy.ps1
```

## Guide
The project is built initially based on FreeCodeCamp guide for Microservice & Kubernetes [video](https://youtu.be/hmkF77F9TLw?feature=shared)
