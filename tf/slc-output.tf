output "graviton-workers" {
  value = [for instance in module.slc-wg : instance.public_ip]
}

output "nvidia-workers" {
  value = [for instance in module.slc-wn : instance.public_ip]
}
