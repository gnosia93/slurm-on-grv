<p align="center">
  <img src = "https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/ansible.png" align="center" width="30%" height="30%">
</p>

* [Ansible 제대로 사용하기](https://brunch.co.kr/@growthminder/66)

## Simple Example ##

```
cat <<_EOF > playbook.yml
- name: get date from workers
  hosts: workers
  tasks:
   - name: ansible_date_time
     debug:
       var: ansible_date_time
_EOF
```

```
$ ansible-playbook playbook.yml -i ansible_hosts --user ubuntu --key-file ~/aws-kp-2.pem
```


## Ansible Configuration Findings ##
* Ansible Config Priority
  * ANSIBLE_CONFIG (environment variable if set)
  * ansible.cfg (in the current directory)
  * ~/.ansible.cfg (in the home directory)
  * /etc/ansible/ansible.cfg

* How to ignore ansible SSH authenticity checking
  * https://stackoverflow.com/questions/32297456/how-to-ignore-ansible-ssh-authenticity-checking
  * https://stackoverflow.com/questions/71712244/ansible-how-do-you-properly-skip-ssh-first-connection-to-fresh-host

* Create user with option --disabled-password by Ansible
  * https://stackoverflow.com/questions/39013796/create-user-with-option-disabled-password-by-ansible
  * https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  * https://www.baeldung.com/linux/user-account-without-password

  ```
  password: ''            # login without password with '' or passwd -d slurm at tty
  ```

* Getting a python warning when running playbook EC2 inventory
  * https://stackoverflow.com/questions/70202432/getting-a-python-warning-when-running-playbook-ec2-inventory


* Ansible: Add IPs from inventory to /etc/hosts of all nodes
  * https://serverfault.com/questions/832799/ansible-add-ips-from-inventory-to-etc-hosts-of-all-nodes
  ```
  - name: update /etc/hosts of each node with the hostname and private ip of all the node of cluster 
  hosts: all
  tasks:
  - name: update /etc/hosts
    become: yes
    blockinfile:
      backup: yes
      path: /etc/hosts
      block: |
        {% for host in groups['all'] %} 
        {{ hostvars[host]['ansible_facts']['ens5']['ipv4']['address'] }} {{ hostvars[host]['ansible_facts']['hostname'] }} 
        {% endfor %}
  ```

## Reference ##

* [Ansible을 활용한 NVIDIA-Driver 설치 과정 자동화](https://velog.io/@todd98/Ansible%EC%9D%84-%ED%99%9C%EC%9A%A9%ED%95%9C-NVIDIA-Driver-%EC%84%A4%EC%B9%98-%EA%B3%BC%EC%A0%95-%EC%9E%90%EB%8F%99%ED%99%94)
* https://docs.nvidia.com/datacenter/tesla/pdf/NVIDIA_Driver_Installation_Quickstart.pdf
* https://freddiekim.tistory.com/m/6
