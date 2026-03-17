resource "aws_ecr_repository" "frontend" {
  name                 = "fullstack-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = { Name = "fullstack-frontend" }
}

resource "aws_ecr_repository" "backend" {
  name                 = "fullstack-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags = { Name = "fullstack-backend" }
}