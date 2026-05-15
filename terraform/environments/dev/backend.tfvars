bucket         = "arista-terraform-state-bucket"
key            = "flask-app-infra/dev/terraform.tfstate"
region         = "ap-southeast-1"
encrypt        = true
dynamodb_table = "terraform-locks"