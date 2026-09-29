#!/bin/bash
set -euo pipefail

NAMESPACE="app-$site"
SA_NAME="jenkins-deployer"
SECRET_NAME="jenkins-deployer-token"
CLUSTER_NAME="$site-cluster"
CONTEXT_NAME="jenkins-$site-context"

SERVER="https://127.0.0.1:6443"

OUTPUT_FILE="kubeconfig-$site.yaml"

TOKEN=$(kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o jsonpath='{.data.token}' | base64 -d)
CA_CERT=$(kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o jsonpath='{.data.ca\.crt}')

if [[ -z "$TOKEN" || -z "$CA_CERT" ]]; then
  echo "ERROR: token atau ca.crt masih kosong. Cek Secret-nya dulu, mungkin controller belum selesai isi."
  exit 1
fi

cat <<EOF > "$OUTPUT_FILE"
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CA_CERT}
    server: ${SERVER}
contexts:
- name: ${CONTEXT_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    namespace: ${NAMESPACE}
    user: ${SA_NAME}
current-context: ${CONTEXT_NAME}
users:
- name: ${SA_NAME}
  user:
    token: ${TOKEN}
EOF

chmod 600 "$OUTPUT_FILE"
echo "Kubeconfig berhasil dibuat: $OUTPUT_FILE"
