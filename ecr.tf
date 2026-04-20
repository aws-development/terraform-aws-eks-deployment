resource "aws_ecr_repository" "ecr_repo" {
  name                 = "wiz-demo-repo"
  image_tag_mutability = "MUTABLE" # Or "IMMUTABLE" based on your needs
  encryption_type = "KMS"
  image_scanning_configuration {
    scan_on_push = true # Set to true if you want to scan images as they are pushed
  }
}
