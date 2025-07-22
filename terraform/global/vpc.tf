module "network" {
  source = "../modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnets = {
    pub-a = {
      cidr = "10.0.10.0/24"
      az   = "${var.region}a"
    }
    pub-b = {
      cidr = "10.0.11.0/24"
      az   = "${var.region}b"
    }
  }
  private_subnets = {
    priv-a = {
      cidr = "10.0.20.0/24"
      az   = "${var.region}a"
    }
    priv-b = {
      cidr = "10.0.21.0/24"
      az   = "${var.region}b"
    }
  }
}