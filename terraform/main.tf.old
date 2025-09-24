provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_ecs_cluster" "main" {
  name = "koronet-test-cluster"
}

resource "aws_ecs_task_definition" "web" {
  family                   = "koronet-test-web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions    = jsonencode([
    {
      name      = "web"
      image     = "${var.docker_image}"
      essential = true
      portMappings = [{ containerPort = 3000 }]
      environment = [
        { name = "DATABASE_URL", value = "${var.database_url}" },
        { name = "REDIS_URL", value = "${var.redis_url}" }
      ]
    },
    {
      name      = "sidecar"
      image     = "prom/prometheus"
      essential = false
    }
  ])
}

variable "docker_image" {}
variable "database_url" {}
variable "redis_url" {}
