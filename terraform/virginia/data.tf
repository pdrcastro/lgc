data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "letsgetchecked-terraform"
    key    = "letsgetchecked-aws/global/state"
    region = "us-east-1"
  }
}