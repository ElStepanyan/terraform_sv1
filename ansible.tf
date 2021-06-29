resource "null_resource" "install_env" {

  provisioner "local-exec" {
    command = "( cd ansible && ansible-playbook -u ubuntu main.yml)"
  }

  depends_on = [aws_instance.sv_1]

}
