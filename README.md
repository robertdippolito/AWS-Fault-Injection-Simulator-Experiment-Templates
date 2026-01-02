# AWS-Fault-Injection-Simulator-Experiment-Templates
Simple Templates and Setup Instructions for AWS FIS.

1. Apply fis-pod.yaml
2. Create FIS experiment role

aws eks create-access-entry \
  --cluster-name <your-cluster> \
  --principal-arn arn:aws:iam::<acct-id>:role/<fis-experiment-role> \
  --username fis-experiment

3. Create IAM role 
4. Change cluster to API_AND_CONFIG_MAP

aws eks update-cluster-config \
  --name <CLUSTER_NAME> \
  --access-config authenticationMode=API_AND_CONFIG_MAP