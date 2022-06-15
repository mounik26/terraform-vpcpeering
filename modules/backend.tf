terraform {
   backend "s3" {
     bucket = "mybucket543345"
     key = "my/terraform.tfstate"
     region = "ap-south-1"
  }
}
      
