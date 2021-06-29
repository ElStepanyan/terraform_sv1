resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.tr_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.tr_vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 8082
    to_port          = 8082
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf"
  }
}

resource "aws_security_group" "allow_mongo" {
  name        = "allow_mongo"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.tr_vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf"
  }
}

resource "aws_security_group" "allow_rabbit" {
  name        = "allow_rabbit"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.tr_vpc.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf"
  }
}


variable "SSH_KEY" {
  type = string
}


resource "aws_key_pair" "key" {
  key_name   = "tr_key"
  public_key = var.SSH_KEY
}

resource "aws_instance" "sv_1" {
  ami           = "ami-03d5c68bab01f3496"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.tr_subnet_1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id, aws_security_group.allow_rabbit.id, aws_security_group.allow_mongo.id]
  key_name = "tr_key" 

  credit_specification {
    cpu_credits = "unlimited"
  }


  tags = {
    Name = "tf"
  }

}

output "instance_ip_addr" {
  value = aws_instance.sv_1.public_ip
  description = "The public IP address of the main server instance."

}

#resource "null_resource" "export_env" {
#
#  provisioner "local-exec" {
#    command = "export TF_VAR_host_ip=${aws_instance.sv_1.public_ip}"
#  }
#}

resource "local_file" "application" {
 content = templatefile("application.tmpl",
 {
     host_ip = aws_instance.sv_1.public_ip
 }
 )
 filename = "application.yml"

}



#resource "aws_instance" "wp_2" {
 # ami           = "ami-0ca5c3bd5a268e7db"
 # instance_type = "t2.micro"
 # subnet_id     = aws_subnet.tr_subnet_2.id
 # vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]
#  key_name = "tr_key"
#
#  credit_specification {
#    cpu_credits = "unlimited"
 # }
#
 # tags = {
  #  Name = "tf"
  #}
#}


