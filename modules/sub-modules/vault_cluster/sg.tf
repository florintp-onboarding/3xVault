resource "aws_security_group" "vault" {
  name        = "vault-sg-${var.region}-${var.random_id}"
  description = "SG for Vault SSH and Vault traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "vault-${var.region}-${var.random_id}"
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.myip}"]
    # cidr_blocks = ["143.178.71.148/32"]
    #  cidr_blocks = ["0.0.0.0/0"]
  }

  # Vault Client Traffic
  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Vault cluster (node-to-node) traffic 

  ingress {
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # All TCP connections are allowed if they are located in the same SG
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  # All UDP connections are allowed if they are located in the same SG
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }

  # All ICMP connections are allowed if they are located in the same SG
  ingress {
    from_port = 0
    to_port   = 254
    protocol  = "icmp"
    self      = true
  }

  # Allow ICMP Echo and Replya if they are having MYIP as source
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${var.myip}"]
  }

  # Leaving traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
