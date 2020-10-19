# rider_submission

I was not successfully able to complete the task fully. With the steps below all necessary services, pods and ingress will successfully deploy and the kibana interface will become available at localhost. What is incomplete is kibana having access to the elasticsearch data. I am unsure if it was a cluster configuration issue or an application issue. I do feel as though this is a technology that I could pick up quickly. If you'd like to look at some of the configs that I found to not work, they are located under failed_attempts. I started with elasticsearch and kibana version 7.9.2, but my final product is in 6.8.4 as there was more information on the internet to help troubleshoot some of the problems.

In the spirit of wanting to give you something that is complete and functional, I have also commited some terraform that I wrote the night after our technical discussion. This terraform will deploy all the necessary infrastructure in AWS and also deploy an EKS cluster. I did this that night to attempt to gain a little knowledge about kubernetes before the assignment came. There are some instructions with it as well which I will include at the end.

### Cluster Instructions ###

Install Kind and Docker to you machine
    - Installing Kind via chocolatey (Windows, assuming homebrew will do the same, but not sure) will automatically install docker as well. 
    - Ensure virtualization is enabled on your machine

Create cluster in Kind
    - Be in the rider_submission\kubernetes_cluster\kubernetes_config directory when running the below command
    - kind create cluster --config .\ingress-cluster-config.yaml
    - It is very important to ensure you do the --config. Without that nginx will not work 
    - Optional to --name to specify a name for your cluster. I left it blank so default is "kind"

Bring up the nginx ingress-controller
    - apply necessary patches, depending on version used, you may have to change the webhook validation address. When using the latest ingress-controller, only line 426, I had to change to admissionregistration.k8s.io/v1beta1 instead of admissionregistration.k8s.io/v1. Run the below commands to bring the controller up:
    - Go to the rider_submission\kubernetes_cluster\kubernetes_config directory
    - Copy and paste below command in:
        - kubectl apply -f ./deploy.yaml

Bring up elasticsearch
    - kubectl apply -f ./elasticsearch
    - I've found that waiting until elasticsearch pods are completely up tends to make the rest of the deployment go easier. I would wait until the pods are running to move on to the next step.

Bring up logstash
    - kubectl apply -f ./logstash

Bring up filebeat
    - kubectl apply -f ./filebeat

Bring up kibana
    - I am not sure if this should matter or does matter. But I have been putting the cluster IP  of the elasticsearch cluster in the elasticsearch_url variable. To find this do a kubectl get services --namespace kube-system. Copy the ClusterIP and paste it into the value on line 23 of the kibana-deployment.yaml. Ensure the port is still at the end.
    - kubectl apply -f ./kibana

Lastly, once all services/pods are running configure nginx for resources in this namespace
    - kubectl apply -f ./nginx-ingress

After this step, everything should come up from an access perspective, elasticsearch data is not populating in kibana.

### Terraform Instructions ###

Install terraform
    - Chocolatey (Windows) or Homebrew (Mac) can be used here for simplicity

Install the AWSCLI
    - Windows: https://awscli.amazonaws.com/AWSCLIV2.msi and follow the installer
    - Mac: Open terminal and run curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg" then sudo installer -pkg AWSCLIV2.pkg -target /
    - Run aws configure and input the information requested. AKID/SKID will be necessary for this deployment. If you do not have it, create a user in an AWS and make sure that programatic credentials is selected

Set your credentials file
    - For this setup of terraform we are using the shared credentials file to obtain the permissions needed to execute the terraform
    - We need to go to the ~/.aws/credentials directory and ensure that are AKID/SKID are set to default profile

Setting the backend
    - I personally like to create the S3 bucket and DynamoDB table manually as it protects against someone accidentally deleting them using terraform. There are other ways it can be done automatically and still protect (CloudFormation would be the easiest). In this scenario lets create them manually to make it simple
    - Create the DynamoDB table, name it however you'd like
    - The Dynamo table only needs a single string key created. The value will be LockID
    - Take the name of the table and go to the backend.tf file and replace the value of the dynamodb_table with your table name
    - Create the S3 bucket
    - Take the name of the s3 bucket and go to backend.tf file and replace the value of the bucket with your table name
    - Once this is done run terraform init and it should say Intitialization successful

Deploy the terraform
    - You can run a terraform plan to see what resource will be setup. After that run terraform apply. You have the option of doing --auto-approve for it to go straight through to deploying. If you do not do that, then you will be required to say yes or no after another plan is done.
    - The EKS cluster and nodegroup can take some time to come up (roughly 15 minutes)
