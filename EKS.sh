#!/bin/bash

# Install AWS CLI

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
aws --version
aws configure

# Install kubectl

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client

# Install eksctl

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
tar -xzf eksctl_Linux_amd64.tar.gz -C /tmp
sudo install -m 0755 /tmp/eksctl /usr/local/bin/eksctl
rm eksctl_Linux_amd64.tar.gz
rm /tmp/eksctl
eksctl version

# Create EKS Cluster

eksctl create cluster --name eks-cluster --region eu-west-1 --node-type c7i-flex.large --nodes-min 2 --nodes-max 2
aws eks update-kubeconfig --region eu-west-1 --name eks-cluster
kubectl get nodes

