Role Name
=========

Bootstrap Rubrik Cluster

Requirements
------------

Node or Cluster at factory defaults

Role Variables
--------------

````
--user_name
--node_name
--cluster_name
--admin_email
--management_gateway
--management_subnet_mask
--enable_encryption
--dns_nameservers
--dns_search_domains
--wait_for_completion
--node_mgmt_ips_var
--node_names_var
--interface_name
````

Dependencies
------------

Rubrik CDM Galaxy Collection

Example Playbook
----------------

````
- name: Bootstrap Cluster
  hosts: localhost
  roles:
    - bootstrap-cluster
````

License
-------

GPL-2.0-or-later

Author Information
------------------

Michael Minichino
