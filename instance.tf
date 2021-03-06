resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.tr_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    description = "HTTP from VPC"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    description = "HTTP from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    description = "HTTP from VPC"
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf"
  }
}

resource "aws_security_group" "allow_consul" {
  name        = "allow_consul"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.tr_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  ami                    = "ami-03d5c68bab01f3496"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.tr_subnet_1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id, aws_security_group.allow_rabbit.id, aws_security_group.allow_mongo.id]
  key_name               = "tr_key"

  credit_specification {
    cpu_credits = "unlimited"
  }


  tags = {
    Name = "tf"
  }

}


output "instance_ip_addr" {
  value       = aws_instance.sv_1.public_ip
  description = "The public IP address of the main server instance."

}


resource "aws_instance" "rb_consul" {
  ami                    = "ami-03d5c68bab01f3496"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.tr_subnet_1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id, aws_security_group.allow_rabbit.id, aws_security_group.allow_consul.id]
  key_name               = "tr_key"

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "tf1"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.rb_consul.id
  allocation_id =  "eipalloc-02f0749a1ef3ce326"
}



resource "local_file" "application1" {
  content = templatefile("application.tmpl",
    {
      host_ip = aws_instance.sv_1.public_ip
      host_ip_1 = aws_instance.rb_consul.public_ip
    }
  )
  filename = "ansible/src/main/resources/application.yml"

}

resource "local_file" "consl-service" {
  content = templatefile("consul-service.tmpl",
    {
      host_priv_ip = aws_instance.rb_consul.private_ip
    }
  )
  filename = "ansible/consul/tasks/consul-service"

}

resource "local_file" "consl-config" {
  content = templatefile("consul-config.tmpl",
    {
      host_priv_ip = aws_instance.rb_consul.private_ip
    }
  )
  filename = "ansible/consul/tasks/consul-config"

}

