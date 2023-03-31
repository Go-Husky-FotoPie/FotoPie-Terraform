#nat gw
resource "aws_eip" "nat1" {
    vpc = "true"
    tags = {Name = "tf-eip1"}
}

resource "aws_eip" "nat2" {
    vpc = "true"
    tags = {Name = "tf-eip2"}
}



resource "aws_nat_gateway" "nat-gw1" {
    allocation_id = "${aws_eip.nat1.id}"
    
    subnet_id = "${aws_subnet.main-public-1.id}"
    tags = {Name = "tf-nat1"}
    
}

resource "aws_nat_gateway" "nat-gw2" {
    allocation_id = "${aws_eip.nat2.id}"
    
    subnet_id = "${aws_subnet.main-public-2.id}"
    tags = {Name = "tf-nat2"}
}


#vpc setup for VPC
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route  {
        cidr_block="0.0.0.0/0"
       # aws_nat_gateway= "${aws_nat_gateway.nat-gw1.id}"
        gateway_id ="${ aws_internet_gateway.main-gw.id}"
    }
    tags = {
      Name = "main-public-routetable"
    }
}

#route associations public
resource "aws_route_table_association" "main-public-1" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
  
}
resource "aws_route_table_association" "main-public-2" {
    subnet_id = "${aws_subnet.main-public-2.id}"
    route_table_id = "${aws_route_table.main-public.id}"
  
}

resource "aws_route_table" "private-rt1" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gw1.id
    }
    tags = {
        Name="tf-private-rt1"
    }

}
resource "aws_route_table" "private-rt2" {
    vpc_id = aws_vpc.main.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gw2.id
    }
    tags = {
        Name="tf-private-rt2"
    }
}

resource "aws_route_table_association" "private1" {
    subnet_id = aws_subnet.main-private-1.id
    route_table_id = aws_route_table.private-rt1.id
  
}

resource "aws_route_table_association" "private2" {
    subnet_id = aws_subnet.main-private-2.id
    route_table_id = aws_route_table.private-rt2.id
  
}