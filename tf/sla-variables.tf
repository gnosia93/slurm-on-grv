provider "aws" {
  region = "ap-northeast-2"
}

/*
terraform {
  required_providers {

    templatefile = {
      version = "1.9.1"
  }
 }
}
*/

variable "key_pair" {
    type = string
    default = "aws-kp-2"                ## 콘솔에서 생성한 키페어 명칭으로 변경.
}

variable "your_ip_cidr" {
    type = string
    default = "211.202.61.0/24"       ## 네이버에서 "내아이피" 로 검색한 후, 결과값을 CIDR 형태로 입력.
}

variable "github_webhook_ips" {
    type = list(string)
    default = [
        "192.30.252.0/22",
        "185.199.108.0/22",
        "140.82.112.0/20",
        "143.55.64.0/20"
    ]
    description = "List of IP addresses for github web hook"
}


locals {
  cluster_name = "slurm-on-aws"
  all_ingress_ciders = tolist(setunion([var.your_ip_cidr], var.github_webhook_ips))
}

/*
output "all_ingress_ciders" {
    value = local.all_ingress_ciders
}
*/

# https://search.naver.com/search.naver?where=nexearch&sm=top_sug.pre&fbm=0&acr=1&acq=%EB%82%B4%EC%95%84%EC%9D%B4%ED%94%BC&qdt=0&ie=utf8&query=%EB%82%B4%EC%95%84%EC%9D%B4%ED%94%BC
