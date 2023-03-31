resource "aws_ecr_repository" "demo-repository" {
  name                 = "tmp3"
  image_tag_mutability = "IMMUTABLE"
}
