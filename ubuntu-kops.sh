#!/usr/bin/env bash
set -euo pipefail

# Legacy kops learning script. It deliberately does not apply the cluster
# to AWS; review the generated spec before running "kops update cluster --yes".
# Configure credentials with an AWS profile/role before running this script.

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this setup script as root or through an approved privilege-escalation method." >&2
  exit 1
fi

: "${KOPS_STATE_BUCKET:?Set KOPS_STATE_BUCKET to an S3 bucket that you own and have verified}"
: "${KOPS_CLUSTER_NAME:?Set KOPS_CLUSTER_NAME to a DNS name for your own cluster}"
: "${KOPS_ZONES:?Set KOPS_ZONES to two or more comma-separated Availability Zones, e.g. us-east-1a,us-east-1b}"

AWS_REGION="${AWS_REGION:-us-east-1}"
KOPS_VERSION="v1.36.2"

apt-get update
apt-get install -y awscli curl ca-certificates

echo "Verifying the active AWS identity before proceeding:"
aws sts get-caller-identity

if ! aws s3api head-bucket --bucket "${KOPS_STATE_BUCKET}"; then
  echo "The configured kops state bucket is not accessible. Create a bucket you own, enable versioning, and retry." >&2
  exit 1
fi

VERSIONING_STATUS="$(aws s3api get-bucket-versioning --bucket "${KOPS_STATE_BUCKET}" --query Status --output text)"
if [[ "${VERSIONING_STATUS}" != "Enabled" ]]; then
  echo "Enable versioning on your own kops state bucket before continuing." >&2
  exit 1
fi

KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
curl -fsSLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl kubectl.sha256

curl -fsSL "https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64" -o /tmp/kops-linux-amd64
curl -fsSL "https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64.sha256" -o /tmp/kops-linux-amd64.sha256
(
  cd /tmp
  sha256sum --check kops-linux-amd64.sha256
)
install -o root -g root -m 0755 /tmp/kops-linux-amd64 /usr/local/bin/kops
rm -f /tmp/kops-linux-amd64 /tmp/kops-linux-amd64.sha256

export AWS_REGION
export KOPS_STATE_STORE="s3://${KOPS_STATE_BUCKET}"

echo "Using AWS region: ${AWS_REGION}"
echo "Using kops state store: ${KOPS_STATE_STORE}"
echo "Using cluster name: ${KOPS_CLUSTER_NAME}"
echo "Using zones: ${KOPS_ZONES}"

kops create cluster \
  --name "${KOPS_CLUSTER_NAME}" \
  --zones "${KOPS_ZONES}" \
  --master-count="${KOPS_MASTER_COUNT:-1}" \
  --master-size="${KOPS_MASTER_SIZE:-t3.medium}" \
  --node-count="${KOPS_NODE_COUNT:-2}" \
  --node-size="${KOPS_NODE_SIZE:-t3.small}"

echo
echo "Cluster configuration created, but AWS infrastructure has NOT been applied."
echo "Review first: kops get cluster --name \"${KOPS_CLUSTER_NAME}\" -o yaml"
echo "Apply only after reviewing cost and network settings:"
echo "  kops update cluster --name \"${KOPS_CLUSTER_NAME}\" --yes --admin"
