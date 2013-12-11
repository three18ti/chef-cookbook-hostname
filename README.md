# DESCRIPTION:

Sets hostname of the node. 

This is intended to set the hostname of a new vm when running knife bootstrap. 
Requires the --node-name parameter is specified when running the bootstrap. e.g.:

    knife bootstrap saucy64 --node-name chef-set-hostname --run-list 'recipe[hostname],role[base]' 

    knife bootstrap 192.168.1.15 --node-name chef-set-hostname --run-list 'recipe[hostname],role[base]' --environment test

# RECIPES:

## default

Will set node's hostname to value of node['name']
Compares ohai detected attribute node['hostname'] to node['name'] to determine if run is required

## vmware

`hostname::vmware` recipe sets hostname automatically using vmtoolsd.
You do not need to set node["set_fqdn"].

If you intend to use this recipe, it is suggested you use the original: https://github.com/3ofcoins/chef-cookbook-hostname
As this recipe is no longer compatible with set_hostname
