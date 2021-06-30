resource "null_resource" "install_env" {

  provisioner "local-exec" {
    command = "( cd ansible && ansible-playbook -u ubuntu main.yml)"
  }

  depends_on = [aws_instance.sv_1]

}


resource "null_resource" "install_env1" {

  provisioner "local-exec" {
    command = "( cd ansible && ansible-playbook -u ubuntu main1.yml)"
  }

  depends_on = [aws_instance.rb_consul]

}
