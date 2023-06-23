# claranet-infra-terraform

This repository uses terraform modules to create an entire AWS infrastructure for the cloud-phoenix-kata application deployment.

The terraform code is composed of :

- **An Application Load Balancer and its Target Groups** 

- **An ASG for the application instances**

- **An instance for MongoDB** 

- **SSM Parameters**

- **SNS Topic**

- **CLoud Watch Alarms** 

## Prerequisites
    Everything is variabilized as much as possible. You will find some variables with "to_define" value, you will need to adapt them according to your cloud environment (VPC, subnets, ami, etc...).


## How to deploy the infrastructure

- Use this command to intialize terraform
   
    ```bash        
    terraform init
    ```

- Use these commands to plan an apply with terraform in order to deploy your infrastructure

    ```bash
    cd <app>
    terraform plan -var-file="config/vars.tfvars" -out plan
    terraform apply plan
    ```

- To destroy infrastructure :
    ```bash
    cd <app>
    terraform destroy -var-file="config/vars.tfvars"
    ```

## CI:CD pipeline
- You can also find a JenkinsFile that executes all the commands quoted before in a pipeline.
