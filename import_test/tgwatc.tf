resource "aws_vpc_endpoint" "vpcend-s3" {
  service_name    = "com.amazonaws.ca-central-1.s3"
  vpc_id          = "vpc-0f8af692fead0eaea"
  route_table_ids = ["rtb-05623991dbb664c96"]
  # route_table_ids = [aws_route_table.rt-tf-import.id]

  tags = {
    Name = "vpcend-s3-tf-import"
  }
}
