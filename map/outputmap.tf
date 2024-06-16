output "usernamedisplay" {
  value = "Could you please tell username ${var.username}"
}
output "useroutput" {
  value = "The Age of ${var.username} is ${lookup(var.user, var.username)}"
}