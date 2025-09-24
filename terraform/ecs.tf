resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# Task role and execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole-koronet"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Attach managed policies for ECS tasks (pull images, write logs)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_sg" {
  name        = "koronet-ecs-sg"
  vpc_id      = aws_vpc.this.id
  description = "Allow HTTP outbound and ephemeral inbound"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Example task definition (FARGATE)
resource "aws_ecs_task_definition" "web_task" {
  family = "koronet-web"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name = "web",
      image = "${var.docker_image}",
      essential = true,
      portMappings = [{ containerPort = 3000, hostPort = 3000, protocol = "tcp" }],
      environment = [
        { name = "DATABASE_URL", value = "${var.database_url}" }
      ]
    },
    {
      name = "prometheus-sidecar",
      image = "prom/prometheus:latest",
      essential = false,
      portMappings = [{ containerPort = 9090, hostPort = 9090, protocol = "tcp" }]
    }
  ])
}
