# flask-app Arista# Test update

Repository 1: flask-app-infra (Infrastructure)
├── .github/
│   └── workflows/
│       ├── deploy-infra-dev.yml
│       ├── deploy-infra-staging.yml
│       └── deploy-infra-prod.yml
├── terraform/
│   ├── modules/
│   │   ├── ecs/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── ecr/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── backend.tfvars
│   │   ├── staging/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── backend.tfvars
│   │   └── prod/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── terraform.tfvars
│   │       └── backend.tfvars
│   └── scripts/
│       └── deploy.sh
├── README.md
└── .gitignore

Repository 2: flask-app (Application)
├── .github/
│   └── workflows/
│       ├── deploy-app-dev.yml
│       ├── deploy-app-staging.yml
│       └── deploy-app-prod.yml
├── src/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── tests/
│   ├── test_app.py
│   └── test_requirements.txt
├── scripts/
│   ├── build.sh
│   └── test.sh
├── README.md
├── .gitignore
└── docker-compose.yml

