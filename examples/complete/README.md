# Complete CodeDeploy Example

A complete example of using the `terraform-aws-codedeploy` module to set up a blue/green deployment pipeline for an ECS service.

## Features

- VPC with public and private subnets
- Application Load Balancer with production and test listeners
- Blue and green target groups for deployment
- ECS cluster and service
- ECS task execution role
- S3 bucket for CodeDeploy artifacts
- CodeDeploy application and deployment group
- Security groups for ALB
- NAT Gateway for private subnet internet access

## Usage

```hcl
provider "aws" {
  region = "us-west-2"
}

# VPC and ALB resources
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# Application Load Balancer
resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = module.vpc.public_subnets
}

# ALB Listeners
resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.example.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}

# Target Groups
resource "aws_lb_target_group" "blue" {
  name     = "blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group" "green" {
  name     = "green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "example-alb-sg"
  description = "Security group for example ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "example" {
  name = "example-cluster"
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Service
resource "aws_ecs_service" "example" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "example"
    container_port   = 80
  }
}

# S3 Bucket for CodeDeploy
resource "aws_s3_bucket" "codedeploy" {
  bucket = "example-codedeploy-bucket"
}

# CodeDeploy Module
module "codedeploy" {
  source = "../../"

  name = "example-app"
  s3_bucket = aws_s3_bucket.codedeploy.id
  ecs_cluster_name = aws_ecs_cluster.example.name
  ecs_service_name = aws_ecs_service.example.name

  alb_listener_arn = aws_lb_listener.prod.arn
  alb_test_listener_arn = aws_lb_listener.test.arn
  alb_tg_blue_name = aws_lb_target_group.blue.name
  alb_tg_green_name = aws_lb_target_group.green.name

  ecs_iam_roles_arns = [aws_iam_role.ecs_task_execution_role.arn]
  termination_wait_time_in_minutes = 120
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Notes

- The example creates a complete infrastructure for blue/green deployments
- The ALB is configured with two listeners: one for production (port 80) and one for testing (port 8080)
- The ECS service is configured to use the blue target group initially
- CodeDeploy is set up to manage the blue/green deployment process
- The S3 bucket is used to store deployment artifacts
- The ECS task execution role is created with the necessary permissions
- Security groups are configured to allow HTTP traffic on both production and test ports
- NAT Gateway is enabled for private subnet internet access 