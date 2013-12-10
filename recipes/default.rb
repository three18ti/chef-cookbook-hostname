#
# Cookbook Name:: hostname
# Recipe:: default
#
# Copyright 2011, Maciej Pasternacki
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
#

unless node.name === node.hostname 
    hostname = node.name

    hostname_file = file '/etc/hostname' do
        content "#{hostname}\n"
        mode "0644"
    end
    
    exec_hostname = execute "hostname #{hostname}" do
        only_if { node['hostname'] != hostname }
        notifies :restart, "service[networking]"
    end

    hostsfile_entry "localhost" do
        ip_address "127.0.0.1"
        hostname "localhost"
        action :create
    end

    hostname_entry = hostsfile_entry "set hostname" do
        ip_address "127.0.1.1"
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

    service "networking" do
        service_name "networking"
        case node["platform"]
        when "ubuntu"
            if node["platform_version"].to_f >= 9.10
                provider Chef::Provider::Service::Upstart
            end
        end
        action :restart
    end
else
    log "hostname already set, not doing anything" do
        level :warn
    end
end
