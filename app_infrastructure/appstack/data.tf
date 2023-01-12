data "aws_vpc" "b2c_vpc" {
  filter {
    name = "tag:Name"
    value = "b2c_vpc"
  }
}
