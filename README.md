# AWS Fault Injection Simulator Experiment Templates

Purpose-built templates and setup steps for running AWS Fault Injection Simulator
(FIS) experiments against EKS. The goal is to help you quickly reproduce common
failure modes (CPU, memory, network, pod delete) so you can validate resiliency
and alerting in a consistent way.

<p align="center">
  <a href="https://youtu.be/mT7krCMu_Ko" title="Durable Terraform Applies with Temporal (Retries, State, Parallel Modules)">
    <img src="https://img.youtube.com/vi/mT7krCMu_Ko/maxresdefault.jpg" alt="Watch on YouTube" width="600">
  </a>
</p>

## What's in this repo
- `cpu-stress`, `memory-stress`, `network-blackhole`, `network-latency`, `pod-delete`: Example FIS experiments
- `terraform`: Supporting infrastructure for IAM roles and permissions

## Quick start
1. Apply `fis-pod.yaml`
2. Create the FIS experiment role access entry:

```bash
aws eks create-access-entry \
  --cluster-name <your-cluster> \
  --principal-arn arn:aws:iam::<acct-id>:role/<fis-experiment-role> \
  --username fis-experiment
```

3. Create the IAM role
4. Change the cluster authentication mode to `API_AND_CONFIG_MAP`:

```bash
aws eks update-cluster-config \
  --name <CLUSTER_NAME> \
  --access-config authenticationMode=API_AND_CONFIG_MAP
```

## Terraform apply
Apply the Terraform in `terraform` before running any experiments. It creates the
IAM roles and permissions that FIS needs to execute the templates.

```bash
cd terraform
terraform init
terraform apply
```
