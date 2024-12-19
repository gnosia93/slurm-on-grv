![](https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/ansible.png =250x)

<img src = "https://github.com/gnosia93/slurm-on-grv/blob/main/tutorial/images/ansible.png" width="20%" height="20%">


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
* Ansible Config Location Priority
  * ANSIBLE_CONFIG (environment variable if set)
  * ansible.cfg (in the current directory)
  * ~/.ansible.cfg (in the home directory)
  * /etc/ansible/ansible.cfg


* Create user with option --disabled-password by Ansible
  * https://stackoverflow.com/questions/39013796/create-user-with-option-disabled-password-by-ansible
  * https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html
  * https://www.baeldung.com/linux/user-account-without-password

  ```
  password: ''            # login without password with '' or passwd -d slurm at tty
  ```

## Reference ##
* https://github.com/lopentusska/slurm_ubuntu_gpu_cluster
* https://github.com/nateGeorge/slurm_gpu_ubuntu?tab=readme-ov-file
* [Ansible을 활용한 NVIDIA-Driver 설치 과정 자동화](https://velog.io/@todd98/Ansible%EC%9D%84-%ED%99%9C%EC%9A%A9%ED%95%9C-NVIDIA-Driver-%EC%84%A4%EC%B9%98-%EA%B3%BC%EC%A0%95-%EC%9E%90%EB%8F%99%ED%99%94)
* https://docs.nvidia.com/datacenter/tesla/pdf/NVIDIA_Driver_Installation_Quickstart.pdf
