output "graviton-workers" {
  value = [for instance in module.slc-wg : instance.public_ip]
}
