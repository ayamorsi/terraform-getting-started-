//create vpc 
resource "aws_vpc" "first_vpc" {
     cidr_block = "10.0.0.0/16"
     tags = {
         Name = "ITI_VPC"
     }
 }

//gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.first_vpc.id}"

  tags = {
    Name = "main"
  }
}

//private subnet 1
 resource "aws_subnet" "private1" {
  vpc_id     = "${aws_vpc.first_vpc.id}"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "private_Subnet1"
  }
}

//private subnet 2
resource "aws_subnet" "private2" {
  vpc_id     = "${aws_vpc.first_vpc.id}"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_Subnet2"
  }
}

//route table for private subnets
resource "aws_route_table" "route_for_private" {
    vpc_id = "${aws_vpc.first_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "private_Subnet"
    }
}

//associate private subnet 1
resource "aws_route_table_association" "associate-private1" {
    subnet_id = "${aws_subnet.private1.id}"
    route_table_id = "${aws_route_table.route_for_private.id}"
}

//associate private subnet2
resource "aws_route_table_association" "associate-private2" {
    subnet_id = "${aws_subnet.private2.id}"
    route_table_id = "${aws_route_table.route_for_private.id}"
}

//public subnet 1
resource "aws_subnet" "public1" {
  vpc_id     = "${aws_vpc.first_vpc.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public_Subnet1"
  }
}

//public subnet 2
resource "aws_subnet" "public2" {
  vpc_id     = "${aws_vpc.first_vpc.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public_Subnet2"
  }
} 

//route table for public subnets 
resource "aws_route_table" "route_for_public" {
    vpc_id = "${aws_vpc.first_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "Public_Subnet"
    }
}

resource "aws_route_table_association" "associate_public1" {
    subnet_id = "${aws_subnet.public1.id}"
    route_table_id = "${aws_route_table.route_for_public.id}"
}

resource "aws_route_table_association" "associate_public2" {
    subnet_id = "${aws_subnet.public2.id}"
    route_table_id = "${aws_route_table.route_for_public.id}"
}
