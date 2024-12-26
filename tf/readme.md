<p align="center">
  <img src="https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/terraform.png" width="15%">
</p>
<br>

## Get your IP ##
* https://whatismyipaddress.com/#google_vignette

## Amazon EC2 T4G ##

![](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/ec2-t4g-1.png)



## Modify EC2 hostname ##
* https://www.cyberciti.biz/faq/set-change-hostname-in-amazon-linux-ec2-instance-server/
* https://stackoverflow.com/questions/9591744/how-to-add-to-the-end-of-lines-containing-a-pattern-with-sed-or-awk
* https://stackoverflow.com/questions/67569017/need-terraform-entry-to-change-hostname-of-newly-created-ec2-instance-using-r
* https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/user-data.html
* https://discuss.hashicorp.com/t/terraform-passing-variables-from-resource-to-cloudinit-data-block/51143
* https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/   
  #### [ec2.tf] ####
  terraform file named ec2.tf has user_data section, in there you call `templatefile` function with teamplte file path and some parameter.
  This replace two placehoder ${HOST_NAME} and ${EFS_ID} in userdata.tpl template file.
  ```
  module "slurm-worker-grv" {
    source  = "terraform-aws-modules/ec2-instance/aws"
  
    for_each = toset(["w1", "w2", "w3"])
    name = "sle-${each.key}"
    ...
  
    user_data              = templatefile("${path.module}/userdata.tpl", {
        EFS_ID = module.efs.id,
        HOST_NAME = "sle-${each.key}"
    })
  
    ...    
  ```
  #### [userdata.tpl] ####
  `>> /home/ubuntu/userdata_output.txt 2>&1` is added at the end of line for debug. If there are no errrors in initialization, userdata_output file has just efs_id and converetd host_name.
  ```
  ...
  sudo apt install -y ./build/amazon-efs-utils*deb
  sudo mkdir /mnt/efs >> /home/ubuntu/userdata_output.txt 2>&1
  sudo mount -t efs -o tls ${EFS_ID}:/ /mnt/efs >> /home/ubuntu/userdata_output.txt 2>&1
  sudo chmod 0777 /mnt/efs >> /home/ubuntu/userdata_output.txt 2>&1
  sudo hostnamectl set-hostname ${HOST_NAME} >> /home/ubuntu/userdata_output.txt 2>&1
  sudo sed -i '/127.0.0.1 localhost/ s/$/ ${HOST_NAME}/' /etc/hosts >> /home/ubuntu/userdata_output.txt 2>&1
  sudo echo ${EFS_ID} >> /home/ubuntu/userdata_output.txt 2>&1
  sudo echo ${HOST_NAME} >> /home/ubuntu/userdata_output.txt 2>&1
  ```
  #### cloud-init log file ##
  * /var/log/cloud-init-output.log
          
## EFS ##

* [Add EFS to an Amazon Linux 2 AWS EC2 Instance with Terraform](https://medium.com/@wblakecannon/add-efs-to-an-amazon-linux-2-aws-ec2-instance-with-terraform-bb073b6de7)
* [EFS 설정](https://my-studyroom.tistory.com/entry/AWS-%EC%8B%A4%EC%8A%B5-EFSElastic-File-System-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EA%B8%B0)
* https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest
* https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file.html#attributes-reference
  
### 설치하기 ###
* [step 1] 아래를 ec2 의 user_data 안에 넣어야 한다. yum 은 지원하나 ubuntu 의 경우 직접 컴파일해서 설치해야 한다.  
```
sudo apt install git
git clone https://github.com/aws/efs-utils
sudo apt install -y make
sudo apt install -y binutils
sudo apt install -y cargo
sudo apt install -y pkg-config
sudo apt install -y libssl-dev

cd efs-utils
./build-deb.sh
sudo apt install -y ./build/amazon-efs-utils*deb
```

* [step 2] ec2 에서 파일 시스템으로 마운트한다.  fs-01d9f13a1c92ac757 는 콘솔에서 조회한다. 
```
sudo mkdir /mnt/efs
sudo chmod 0777 /mnt/efs
sudo mount -t efs -o tls fs-01d9f13a1c92ac757:/ /mnt/efs
```

## Lustre ##
* https://docs.aws.amazon.com/ko_kr/fsx/latest/LustreGuide/getting-started.html

## Terraform ##

* [파일(file, templatefile)을 활용한 리소스 구성하기](https://dewble.tistory.com/entry/configuring-terraform-resources-with-files)


## Reference ##

* [DeepsOps](https://www.itmaya.co.kr/wboard/view.php?wb=tech&idx=23)
