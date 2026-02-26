
---

# 📁 4️⃣ `Scripts/README.md`

```markdown
# ⚙ Pipeline Execution Scripts

This folder contains automation scripts executed by Azure DevOps pipeline.

---

## 📂 Files

- terraform.sh → Provisions infrastructure & configures AKS
- deploy.sh → Deploys Kubernetes manifests
- trivy.sh → Performs security scanning

---

## 🚀 terraform.sh

- Initializes Terraform backend
- Applies infrastructure
- Fetches AKS credentials
- Configures kubectl

---

## 🚀 deploy.sh

- Deploys application manifests from k8s/
- Verifies deployment

---

## 🔐 trivy.sh

Performs:
- Docker image scan
- Kubernetes cluster scan
- Filesystem scan

---

## ▶️ Manual Execution (Linux Only)

```bash
bash terraform.sh
bash deploy.sh
bash trivy.sh


.
├── Infra/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── test.tfvars
│ └── README.md
│
├── k8s/
│ ├── deployment.yaml
│ ├── service.yaml
│ └── README.md
│
├── monitoring/
│ ├── monitoring.sh
│ └── README.md
│
├── Scripts/
│ ├── terraform.sh
│ ├── deploy.sh
│ ├── trivy.sh
│ └── README.md
│
└── azure-pipelines.yml