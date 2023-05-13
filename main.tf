terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAT4EDDZXUESRBRP5F"
  secret_key = "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"
}

resource "aws_vpc" "sailorvpc" {
  cidr_block = "172.10.0.0/16"
  tags = {
    Name = "sailorvpc"
  }
}

resource "aws_subnet" "sailorpubsn1" {
  cidr_block = "172.10.1.0/24"
  availability_zone = "ap-south-1a"
  vpc_id = aws_vpc.sailorvpc.id
  tags = {
    Name = "sailorpubsn1"
  }
}

resource "aws_route_table_association" "sailor-rt-ass" {
  route_table_id = aws_route_table.sailorig-rt.id
  subnet_id = aws_subnet.sailorpubsn1.id
}

resource "aws_route_table" "sailorig-rt" {
    vpc_id = aws_vpc.sailorvpc.id
    tags = {
      Name = "sailorig-rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sailorig.id
    }
}


resource "aws_internet_gateway" "sailorig" {
  vpc_id = aws_vpc.sailorvpc.id
  tags = {
    Name = "sailorig"
  }
}

resource "aws_security_group" "sailorsg" {
  vpc_id = aws_vpc.sailorvpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
 
  tags = {
    Name = "sailor-sg"
  }
}


resource "aws_key_pair" "devopskeypair" {
  key_name = "devopskp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRCB6iq46zOzX3eu5MuhrkPsXksWC9uF7HEOMbzHYkZOpf71W7AuqLDzRcT2T6OsbHoSBja00BtiU60Dz34qSTGAgO6GOdBoiT9dcVYH4+ayqhvKQUTN59rLp+52Xo/gCzPnPqTVH24ThQOP46fPyG8teV7oio14VKynkyVp9APrKKiH5EgCwUAA3HRutrjT9g/mLkT3UJJQKNGrS0iz8JAOccOWtTwEStWEcbMhQDxFs5g0RCSJAdP9sp/OiNDwW8D1Wzl2ocGTdw46/GLYsn4fMDcBSxlJMdb5959Wr8gksYcb6xHgeWnHrvUKIfouCbcUj3/lLvJWuRvyv3I1VvSB4XoG5PmasVceh4N1Q5aYL0Tc3yux7VIrFSEHBXKDd+PVopLDWzUzM2JF4i0T9hoyiUWuAjFlEr3FOStNJuXcI6J6/1+lcj48pcPlCnHAiwhet+2Ozh6OXD6YUlWW0/qtYkVUtrpJGOZy2wVM/iOF1ErZG+CZkJSE/2K8tXsC0= ved@Vedprakashs-MacBook-Air.local"
}

resource "aws_instance" "sailorec2" {
  subnet_id = aws_subnet.sailorpubsn1.id
  instance_type = "t2.micro"
  ami = "ami-02eb7a4783e7e9317"
  associate_public_ip_address = true
  security_groups = [aws_security_group.sailorsg.id]
  key_name = aws_key_pair.devopskeypair.key_name

  tags = {
    Name = "javaserver"
  }
}