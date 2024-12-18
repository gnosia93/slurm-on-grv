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
