# terraform-aws-codedeploy  [![Senora](https://github.com/Senora-dev/assets/blob/main/senora-logo.png?raw=true)](https://senora.dev)
A Terraform module that implements Blue-Green deployment using AWS CodeDeploy as part of a AWS CodePipeline pipeline.

Learn more in the [AWS CodeDeploy Guides Series](https://medium.com/@senora-dev).

## Usage
```terraform
module "codedeploy"{
    source  = "Senora-dev/codedeploy/aws"
    version = "~>1.0.0"

    app_name = "my-app-name"
    s3_bucket = "codepipeline-bucket-name"
    ecs_cluster_name = "my-app-cluster-name"
    ecs_cluster_name = "my-app-ecs-sevrice-name"
    load_balancer_listener_arn = "${data.my_alb_listener_arn}"
    load_balancer_test_listener_arn = "${data.my_test_listener_arn}"
    load_balancer_blue_target_group = "my-blue-tg-name"
    load_balancer_green_target_group = "my-green-tg-name"
}
```
***After applying the changes, make sure to add CodeDeploy as a stage in CodePipeline. The CI stage (defined in buildspec.yaml) should pass Appspec.yaml through the 'artifacts' section.***

## Contributing
Contributions to this project are welcome! Feel free to submit issues, feature requests, or pull requests to help improve the self-service backend.

## License
This project is licensed under the [Apache 2.0 License](LICENSE).
