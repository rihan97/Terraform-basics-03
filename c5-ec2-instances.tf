
data "aws_availability_zones" "my-az" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

#declaring our ec2 instances
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.amz-linux2.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  user_data = file("/Users/rayhanalam/Documents/Training/Terraform/Terraform-basics-03/User-data/app1-install.sh")
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id,aws_security_group.vpc-web.id]
  # create EC2 instance in all availability zones of a Vpc
  # london say has three AZ's you need a instance in each AZ, to do this you can use for_each argument
  # so here we are passing the set of strings from az inside the for_each, 
  for_each = toset (data.aws_availability_zones.my-az.names )
  availability_zone = each.key
  # You can also use each.value because for list items each.key == each.value
  tags = {
    Name = "EC2 instance 1-${each.key}"  //or each.value 
  }
}