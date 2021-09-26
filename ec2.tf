
resource "aws_instance" "application-server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.medium"
  key_name             = aws_key_pair.take_home_test.id
  vpc_security_group_ids = ["${aws_security_group.take_home_test_ec2_sg.id}"]
  ebs_optimized = false
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.arachnys-take-home-test-instance-profile.name

  root_block_device {
    volume_type="gp2"
    volume_size="50"
    delete_on_termination="true"
  }

tags = "${merge(local.tags, tomap({"Name" = "${local.application}-ec2"}))}"
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }


user_data = "${file("install_sentry.sh")}"

}

