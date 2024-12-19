


## EFS ##

* [Add EFS to an Amazon Linux 2 AWS EC2 Instance with Terraform](https://medium.com/@wblakecannon/add-efs-to-an-amazon-linux-2-aws-ec2-instance-with-terraform-bb073b6de7)
* [EFS 설정](https://my-studyroom.tistory.com/entry/AWS-%EC%8B%A4%EC%8A%B5-EFSElastic-File-System-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EA%B8%B0)
* https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest

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
