#! /bin/bash
sudo apt-get update
#sudo apt-get install -y ca-certificates curl gnupg lsb-release
#sudo mkdir -p /etc/apt/keyrings
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#echo \
# "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
# $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 
sudo apt install -y jq 
# sudo apt install -y awscli 
# sudo apt install -y openjdk-17-jdk-headless 
# sudo apt install -y apache2-utils 
sudo apt install -y net-tools 
sudo apt install -y git 
sudo apt install -y make 
sudo apt install -y binutils 
sudo apt install -y pkg-config 
sudo apt install -y libssl-dev 
# sudo apt --fix-broken install -y 
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

