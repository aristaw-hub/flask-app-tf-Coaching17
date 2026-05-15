aws_region   = "ap-southeast-1"
project_name = "flask-app"
environment  = "dev"

# Networking
vpc_id      = "vpc-09e68bf2108bdf122"
subnet_ids  = [
  "subnet-00a54cae228ee1732",
  "subnet-0e44557b9401fd38b",
  "subnet-00eb3ade335259f01"
]

container_port = 8080
task_cpu       = 256
task_memory    = 512
desired_count  = 1

enable_auto_scaling = false