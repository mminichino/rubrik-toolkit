# rubrik-toolkit

Note: The Ansible Helper used in these examples can be found here: [ansible-helper](https://github.com/mminichino/ansible-helper) 

You can download the Rubrik Backup Service (RBS) packages to a central location. Note the downloaded packages are cluster and version specific and the RBS is only needed to enable certain functionality. Only install it if needed, and only on hosts associated with that cluster.
````
$ ansible-helper.py playbooks/rubrik-get-service.yaml -e /path/to/vault.yaml -P vault_password_variable --cluster_name rubrik01 --local_dir /rubrik_service
````

You can bootstrap a new Cluster via ipv6 link-local address:
````
$ ansible-helper.py playbooks/bootstrap-cluster.yaml --node_name fe80::250:56ff:fea1:d06b --interface_name ens192 --cluster_name rubrik01 --admin_email email@domain.com --management_gateway 10.10.1.1 --dns_nameservers 10.10.2.2,10.10.2.3 --dns_search_domains domain.com --enable_encryption false --node_mgmt_ips 10.10.1.24 --node_names VRVWAIR000000001
````

You can integrate with Managed Volumes (not SLA Managed Volumes, the begin/end is automatic with SLA Managed Volumes). The Managed Volume must be mounted with options supported by RMAN. The Oracle Scripts collection can be found here: [oracle-scripts](https://github.com/mminichino/oracle-scripts)
````
rubrik:/mnt/managedvolume/orabkup01_channel0_60250031 /ora_backup_1 nfs rw,bg,hard,rsize=1048576,wsize=1048576,tcp,actimeo=0,vers=3,timeo=600 0 0
````
Then run the backup using the Managed Volume:
````
$ ansible-helper.py playbooks/managed_volume_snap.yaml --cryptfile /home/oracle/playbooks/group_vars/all/vault.yaml -P rubrik_password --node_name rubrik --volume orabkup01 --action begin
$ db-incr-merge.sh -n -s test19c -d /ora_backup_1
$ ansible-helper.py playbooks/managed_volume_snap.yaml --cryptfile /home/oracle/playbooks/group_vars/all/vault.yaml -P rubrik_password --node_name rubrik --volume orabkup01 --action end
````

To send a quick SLA Compliance Report if there are active weather alerts near a CDM system:
````
$ ansible-helper.py weather-alert.yaml --latitude 12.345678 --longitude -123.456789 --cryptfile /path/to/ansible/vault.yaml -P cdm_password_var --node_name rubrik --mail_to email@example.com --mail_from info@example.com --mail_password email_password_var
````

Or use the Ansible Helper save feature to store static options:
````
$ ansible-helper.py weather-alert.yaml -s rubrik-weather
Customize parameters? (y/n) [n]: y
Ask for password? (y/n) [n]:
Password variable? [None]: cdm_password_var
Vault file? [None]: /path/to/ansible/vault.yaml
Enable debug output? (y/n) [n]:
Enable quiet (JSON) output? (y/n) [n]:
user_name:
node_name: rubrik
latitude:
longitude:
mail_to: email@example.com
mail_from: info@example.com
mail_host:
mail_password: email_password_var
sms:
carrier:
number:
$ ansible-helper.py weather-alert.yaml -r rubrik-weather --latitude 12.345678 --longitude -123.456789
````

The Ansible Helper includes a setup utility that can help setup Ansible Vault. Read the Ansible documentation on Ansible Vault for more information.
````
$ ansible-vault edit /path/to/ansible/vault.yaml
````
