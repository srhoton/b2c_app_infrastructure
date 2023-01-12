data "aws_vpc" "b2c_vpc" {
  filter {
    name = "tag:Name"
    values = ["b2c_vpc"]
  }
}
