locals {
  user_data = yamldecode(file("./users.yaml")).users
  
  user_role = flatten([
    for user in local.user_data : [
      for role in user.roles : {
        username = user.username
        role     = role
      }
    ]
  ])
}


output "user_output" {
  
  value =local.user_role
}

resource "aws_iam_user" "main" {
for_each = toset(local.user_data[*].username)
name = each.value
}
resource "aws_iam_user_login_profile" "examplemain" {
  for_each = aws_iam_user.main
  user =each.value.name
  password_length = 12
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}


#attaching policy
resource "aws_iam_user_policy_attachment" "test-attach" {
  for_each = {
    for pair in local.user_role :"${pair.username}-${pair.role}" => pair
  }

  user       = aws_iam_user.main[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}