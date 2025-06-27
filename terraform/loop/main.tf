resource "aws_iam_user" "myusers" {
  for_each = var.users
  name = each.value
}