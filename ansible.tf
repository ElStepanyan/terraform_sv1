
resource "null_resource" "install_env1" {

  provisioner "local-exec" {
    command = "( cd ansible && ansible-playbook -u ubuntu main.yml --tags tf1 -i tf1_aws_ec2.yaml)"
  }

  depends_on = [aws_instance.rb_consul]

}



resource "null_resource" "install_env" {

  provisioner "local-exec" {
    command = "( cd ansible && ansible-playbook -u ubuntu main.yml --tags tf -i tf_aws_ec2.yaml)"
  }

  depends_on = [aws_instance.sv_1]

}
