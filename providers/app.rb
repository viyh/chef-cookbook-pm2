#
# Cookbook Name:: pm2
# Provider:: app
#

require 'fileutils'

use_inline_resources

def whyrun_supported?
    true
end

def load_current_resource
    @current_resource = Chef::Resource::Pm2App.new(new_resource.name)
    run_context.include_recipe 'pm2::nodejs'
    run_context.include_recipe 'pm2::pm2'

    if ::File.exists?("#{new_resource.path}/server-start.sh")
        c = cli_run('pm2 list')
        @current_resource.exists = c.stdout.include?(new_resource.name)
    end
end

def cli_run(command)
    shell = Mixlib::ShellOut.new("#{command} 2>&1")
    shell.run_command
end

action :create do
    t = template "#{new_resource.path}/server-start.sh" do
        cookbook new_resource.cookbook
        owner new_resource.user
        group new_resource.group
        variables ({
            :name   => new_resource.name,
            :path   => new_resource.path,
            :js     => new_resource.js,
            :port   => new_resource.port,
            :user   => new_resource.user,
            :group  => new_resource.group
        })
        mode 00755
        source 'server-start.sh.erb'
        notifies :run, "execute[run #{new_resource.name}]", :delayed
    end

    server_start = execute "run #{new_resource.name}" do
        command './server-start.sh'
        cwd new_resource.path
        user new_resource.user
        group new_resource.group
        only_if { ::File.exists?("#{new_resource.path}/server-start.sh") }
        action :nothing
    end

    if not @current_resource.exists or t.updated_by_last_action?
        server_start.run_action(:run)
        new_resource.updated_by_last_action(true)
    end
end

action :delete do
    template "#{new_resource.path}/server-start.sh" do
        action :delete
    end

    execute "pm2 kill #{new_resource.name}"
end

action :restart do
    server_start = execute "run #{new_resource.name}" do
        command './server-start.sh'
        cwd new_resource.path
        user new_resource.user
        group new_resource.group
        only_if { ::File.exists?("#{new_resource.path}/server-start.sh") }
        action :run
    end
end
