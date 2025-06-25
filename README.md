# AWS CodeDeploy Terraform Module

This Terraform module creates an AWS CodeDeploy application and deployment group for ECS services with blue/green deployment capabilities.

## Features

- CodeDeploy application for ECS services
- Blue/Green deployment configuration
- Automatic rollback on deployment failure
- Traffic routing through Application Load Balancer
- IAM roles and policies for CodeDeploy
- CloudWatch logging integration
- ECS service integration
- Lambda execution permissions

## Usage

```hcl
module "codedeploy" {
  source = "Senora-dev/codedeploy/aws"

  app_name = "my-app"
  ecs_cluster_name = "my-cluster"
  ecs_service_name = "my-service"
  
  load_balancer_listener_arn = "arn:aws:elasticloadbalancing:region:account:listener/app/alb/1234567890abcdef/1234567890abcdef"
  load_balancer_test_listener_arn = "arn:aws:elasticloadbalancing:region:account:listener/app/alb/1234567890abcdef/0987654321fedcba"
  
  load_balancer_blue_target_group = "blue-tg"
  load_balancer_green_target_group = "green-tg"
  
  termination_wait_time_in_minutes = 120
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_name | Name of the application | `string` | n/a | yes |
| ecs_cluster_name | Name of the ECS cluster | `string` | n/a | yes |
| ecs_service_name | Name of the ECS service | `string` | n/a | yes |
| load_balancer_listener_arn | ARN of the production listener | `string` | n/a | yes |
| load_balancer_test_listener_arn | ARN of the test listener | `string` | n/a | yes |
| load_balancer_blue_target_group | Name of the blue target group | `string` | n/a | yes |
| load_balancer_green_target_group | Name of the green target group | `string` | n/a | yes |
| termination_wait_time_in_minutes | Time to wait before terminating old instances | `number` | `120` | no |

## Outputs

| Name | Description |
|------|-------------|
| codedeploy_app_name | Name of the CodeDeploy application |
| codedeploy_deployment_group_name | Name of the deployment group |
| codedeploy_role_arn | ARN of the CodeDeploy IAM role |

## Notes

- The module creates a CodeDeploy application specifically for ECS services
- Blue/Green deployment is configured with traffic routing through an ALB
- Automatic rollback is enabled for failed deployments
- The module creates necessary IAM roles and policies for CodeDeploy
- CloudWatch logging is configured for deployment monitoring
- Lambda execution permissions are attached to the CodeDeploy role

## License

MIT Licensed. See LICENSE for full details.

## Maintainers

This module is maintained by [Senora.dev](https://senora.dev). 