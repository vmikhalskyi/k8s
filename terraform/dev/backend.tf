terraform {
  backend "s3" {
    bucket = "tfstate-mikhalskyi"
    key    = "dev-state/state.tfstate"
    region = "us-east-1"
  }
}