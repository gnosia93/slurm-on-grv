* [EFS 설정](https://my-studyroom.tistory.com/entry/AWS-%EC%8B%A4%EC%8A%B5-EFSElastic-File-System-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EA%B8%B0)
* https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest


## EFS ##

* [Add EFS to an Amazon Linux 2 AWS EC2 Instance with Terraform](https://medium.com/@wblakecannon/add-efs-to-an-amazon-linux-2-aws-ec2-instance-with-terraform-bb073b6de7)



Ubuntu에서 sudo mount -t efs -o tls fs-d7ac42b7:/ /mnt/efs/fs1 명령어를 넣어주기 전에 다음과 같은 과정을 해야 한다.
 
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
sudo apt install ./build/amazon-efs-utils*deb
```
