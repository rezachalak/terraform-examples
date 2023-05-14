module "eks_example_self_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//examples/eks_managed_node_group"
  version = "19.13.1"
}