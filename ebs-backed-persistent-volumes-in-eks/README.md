# EBS-backed persistent volumes for EKS, sample  
## How to setup, from scratch, persistent volumes in AWS EKS.  
### Create IAM policy and role for the EBS CSI driver.
 * Provision a working EKS cluster.
 * Set your working region.  
```export AWS_DEFAULT_REGION=sa-east-1```
 * View your cluster's OIDC provider URL (update your cluster name in parameter '--name')  
```
aws eks describe-cluster \
  --name TestK8sCluster \ 
  --query "cluster.identity.oidc.issuer" \
  --output text
```  
 * Create file 'aws-ebs-csi-driver-trust-policy.json' with the following content (Update: OIDC code, account number, region).  
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::111122223333:oidc-provider/oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud": "sts.amazonaws.com",
          "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
```  
 * Create the role.  
```
aws iam create-role \
  --role-name my-AmazonEKS_EBS_CSI_DriverRole \
  --assume-role-policy-document file://"aws-ebs-csi-driver-trust-policy.json"
```  
 * Attach the required AWS managed policy to the role.  
```
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --role-name my-AmazonEKS_EBS_CSI_DriverRole
```
### Install eksctl (to create an IAM OIDC identity provider for your cluster)  
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
```  
```
sudo mv /tmp/eksctl /usr/local/bin
```  
To test:
```
eksctl version
```  
### Create an IAM OIDC identity provider for your cluster (using eksctl)
Test if you have an existing IAM OIDC provider for your cluster. If the second command returns anything, then no.  
```
oidc_id=$(aws eks describe-cluster --name TestK8sCluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
```
```
aws iam list-open-id-connect-providers | grep $oidc_id
```
Create an IAM OIDC identity provider for your cluster with the following command.  
```
eksctl utils associate-iam-oidc-provider --cluster TestK8sCluster --approve
```
### Adding the Amazon EBS CSI add-on  
```
aws eks create-addon \
  --cluster-name TestK8sCluster \
  --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::516176675572:role/my-AmazonEKS_EBS_CSI_DriverRole
```

 * 


``````
``````
References:  
 - https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html


oidc_id=$(aws eks describe-cluster --name TestK8sCluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

k apply -f volpod.yml
k apply -f broken-pod.yml
k apply -f meuservico.yml
k apply -f meuservico2.yml

k delete -f volpod.yml
k delete -f broken-pod.yml
k delete -f meuservico.yml
k delete -f meuservico2.yml

  
Comando para dar "watch":  
```
watch -n 1 "echo "pods:" && kubectl get pods && echo "" && echo "sc:" && kubectl get storageclasses && echo "" && echo "pv:" && kubectl get persistentvolume && echo "" && echo "pvc:" && kubectl get persistentvolumeclaim"
```