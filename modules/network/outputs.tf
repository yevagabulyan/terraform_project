output "vpc_id" {
  value   =  aws_vpc.my_vpc.id
}


output "public_subnet_id" {
  value   =  aws_subnet.public_subnet.id
}

output "public_subnet1_id" {
  value   =  aws_subnet.public_subnet1.id
}

output "instance_sg_id" {
  value   = aws_security_group.instance_sg.id
}

output "alb_sg" {
  value   = aws_security_group.alb_sg.id
}
