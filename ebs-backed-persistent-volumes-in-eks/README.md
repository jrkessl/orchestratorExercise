# EBS-backed persistent volumes for EKS, sample  
## How to setup, from scratch, persistent volumes in AWS EKS.  
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
 * 


``````
``````
References:  
 - https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html
