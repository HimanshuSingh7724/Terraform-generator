provider "aws" {
    region = "eu-north-1"
}

resource "aws_key_pair" "my_key"{
    key_name = "my_key"
    public_key = file("${path.module}/my_key.pub")

}

resource "aws_instance" "example" { 
    ami= "ami-042b4708b1d05f512"
    instance_type = "t3.micro"
    key_name = aws_key_pair.my_key.key_name

    tags= {
        Name = "TerraformEC2"
    }
}

