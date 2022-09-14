#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "stage" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                                      = "terraform-eks-stage-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_subnet" "stage" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.stage.id

  tags = tomap({
    "Name"                                      = "terraform-eks-stage-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_internet_gateway" "stage" {
  vpc_id = aws_vpc.stage.id

  tags = {
    Name = "terraform-eks-stage"
  }
}

resource "aws_route_table" "stage" {
  vpc_id = aws_vpc.stage.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stage.id
  }
}

resource "aws_route_table_association" "stage" {
  count = 2

  subnet_id      = aws_subnet.stage.*.id[count.index]
  route_table_id = aws_route_table.stage.id
}
