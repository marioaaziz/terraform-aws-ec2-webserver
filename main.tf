provider "aws" {
    region = "us-east-1"
   access_key = "00000000000000000000"
   secret_key = 000000000000000000000"
}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "prod" 
           }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

}

#route table
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "prod"
  }
}


resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

tags = {
  Name = "prod-sub"
}
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.route-table.id
}
  
  resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web-traffic"
  description = "Allow web traffic"
  vpc_id      =  aws_vpc.my-vpc.id 

  ingress {
    description = "HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "net-interface" {
  subnet_id       = aws_subnet.sub1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web_traffic.id]
}

resource "aws_eip" "my-eip" {
domain                    = "vpc"
network_interface         = aws_network_interface.net-interface.id
associate_with_private_ip = "10.0.1.50"
depends_on = [ aws_internet_gateway.igw]
}

resource "aws_instance" "ubuntu-server" {
   ami           = "ami-07041441b708acbd6"  
  instance_type = "t4g.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key"

   network_interface {
     device_index = 0
     network_interface_id = aws_network_interface.net-interface.id
   }
  user_data = <<-EOF
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl start apache2
  sudo bash -c 'echo "your first server" > /var/www/html/index.html'
  EOF

  tags = {
    Name = "web-server"
  }
}
