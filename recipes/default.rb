#
# Cookbook Name:: set_hostname
# Recipe:: default
#
# Copyright 2013, Jon A
# forked from 3ofcoins / chef-cookbook-hostname: https://github.com/3ofcoins/chef-cookbook-hostname
# See COPYRIGHT for original copyright notification
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

unless node.name === node['hostname']
    hostname = node.name

    hostname_file = file '/etc/hostname' do
        content "#{hostname}\n"
        mode '0644'
    end

    exec_hostname = execute "hostname #{hostname}" do
        only_if { node['hostname'] != hostname }
#        notifies :restart, "service[networking]"
    end

    hostsfile_entry 'localhost' do
        ip_address '127.0.0.1'
        hostname 'localhost'
        action    :create_if_missing
    end

    hostname_entry = hostsfile_entry 'set hostname' do
        ip_address '127.0.1.1'
        hostname hostname
        action :create
    end

    ohai 'reload for hostname and fqdn' do
        only_if do
            [hostname_file, exec_hostname, hostname_entry].
                map(&:updated_by_last_action?).any?
        end
        action :reload
    end

    # should probably do this with a dhclient restart 
    # (since there's no need to restart networking when we're not on dhcp
    execute 'restart dhclient' do
        command "echo 'restarting dhclient'; dhclient -r -v; dhclient -v;"
        action :run
    end

#    service "networking" do
#        case node["platform"]
#        when "ubuntu"
#            service_name "networking"
#            if node["platform_version"].to_f >= 9.10 && node["platform_version"].to_f < 14.04
#                provider Chef::Provider::Service::Upstart
#            else
                # dummy else, since 14.04 no longer supports networking "restart"
#                service_name "networking"
#            end
#        when "fedora"
#            service_name "network"
#            action :restart
#        else
#            service_name "network"
#            action :restart
#        end
#    end
else
    log 'hostname set' do
        message 'hostname matches node name, not doing anything'
        level :warn
    end
    return
end
