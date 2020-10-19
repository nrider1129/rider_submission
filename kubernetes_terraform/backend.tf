terraform {
  backend "s3" {
    bucket              = "rider-kubernetes-terraform" 
    key                 = "environment/test/"
    dynamodb_table      =  "terraform-state"
    region              = "us-east-1"
  }
}