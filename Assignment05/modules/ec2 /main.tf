################################
# Application EC2 Instances (Private Subnets Only)
################################
resource "aws_instance" "app" {
  count                  = length(var.private_subnet_ids)
  ami                    = var.ubuntu_ami_id
  instance_type          = var.instance_type1 
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.app_sg_id]
  key_name               = var.key_name

  # IAM Instance Profile hata diya gaya hai

  tags = merge(
    var.tags,
    {
      Name = "${var.tags.Environment}-app-0${count.index + 1}"
      env  = "production"
    }
  )
}
