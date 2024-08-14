
resource "aws_instance" "web" {
  ami                    = var.imageid
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = file("${path.module}/script.sh")
  tags = {
    Name = "HelloWorld"
  }
  #connection
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip

  }
  #file,localexc,remote exe
  provisioner "file" {
    source      = "readme.md"
    destination = "/tmp/readme.md"

  }
  provisioner "file" {
    content     = "This is a content"
    destination = "/tmp/content.md"

  }
  provisioner "local-exec" {

    working_dir = "/tmp"
    command     = "echo ${self.public_ip}>mypublicip.txt"

  }
  provisioner "local-exec" {
    command = "echo 'at create'"

  }
  provisioner "local-exec" {
    command = "echo 'at destroy'"

  }
  provisioner "remote-exec" {
    inline = [
      "ifconfig >/tmp/output.txt",
      "echo 'hello gaurav' >/tmp/output1.txt"
    ]

  }
  provisioner "remote-exec" {
    script = "./testscript.sh"
  }

}




