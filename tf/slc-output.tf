# https://stackoverflow.com/questions/76669970/how-to-use-instance-ids-from-the-ec2-module-into-another-resource-in-terraform
output "master" {
  value = values(module.slc-mst)[1].public_ip
}

output "client" {
  value = values(module.slc-mst)[0].public_ip
}

output "graviton-workers" {
  value = [for instance in module.slc-wg : instance.public_ip]
}

output "nvidia-workers" {
  value = [for instance in module.slc-wn : instance.public_ip]
}

output "prometheus" {
  value = [module.slc-mon["prometheus"].public_dns, module.slc-mon["prometheus"].public_ip]
}
