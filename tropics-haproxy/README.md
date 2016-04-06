Script to deploy an haproxy instance locally for tropics load balancing.
This load balances between 2 tropics instances with sticky sessions enabled.

Requirements:
 - Edit script/provision.sh with your machines local IP address

example usage:
 - navigate to project directory (cd tropics-haproxy)
 - create instance (vagrant up)
 - destroy instance (vagrant destroy)
