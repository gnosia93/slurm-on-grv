#! /bin/bash
sudo apt update
sudo apt install -y net-tools 
sudo apt install -y git 
sudo apt install -y make 
sudo apt install -y binutils 
sudo apt install -y pkg-config 
sudo apt install -y libssl-dev 
sudo apt install -y cargo 
git clone https://github.com/aws/efs-utils 
cd efs-utils  
./build-deb.sh 
sudo apt install -y ./build/amazon-efs-utils*deb >> /home/ubuntu/userdata_output.txt 2>&1
sudo mkdir /mnt/efs >> /home/ubuntu/userdata_output.txt 2>&1
sudo mount -t efs -o tls ${EFS_ID}:/ /mnt/efs >> /home/ubuntu/userdata_output.txt 2>&1
sudo chmod 0777 /mnt/efs >> /home/ubuntu/userdata_output.txt 2>&1
sudo hostnamectl set-hostname ${HOST_NAME} >> /home/ubuntu/userdata_output.txt 2>&1
sudo sed -i '/127.0.0.1 localhost/ s/$/ ${HOST_NAME}/' /etc/hosts >> /home/ubuntu/userdata_output.txt 2>&1
sudo echo ${EFS_ID} >> /home/ubuntu/userdata_output.txt 2>&1
sudo echo ${HOST_NAME} >> /home/ubuntu/userdata_output.txt 2>&1

#cloud-config	
#runcmd:
#- sudo hostnamectl set-hostname ${HOST_NAME}
#- sudo sed -i '/127.0.0.1 localhost/ s/$/ ${HOST_NAME}/' /etc/hosts

