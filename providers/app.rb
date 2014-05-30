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
        c = shell_out('pm2 list')
        @current_resource.exists = c.stdout.include?(new_resource.name)
    end
end

action :create do
    converge_by("Create start script for #{new_resource.name}") do
        t = template "#{new_resource.path}/server-start.sh" do
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
        end
    end

    converge_by("Starting app: #{new_resource.name}") do
        server_start = execute "run #{new_resource.name}" do
            command './server-start.sh'
            cwd new_resource.path
            user new_resource.user
            group new_resource.group
            action :nothing
        end

        if not @current_resource.exists or t.updated_by_last_action?
            server_start.run_action(:run)
            new_resource.updated_by_last_action(true)
        end
    end
end

action :delete do
    template "#{new_resource.path}/server-start.sh" do
        action :delete
    end

    execute "pm2 kill #{new_resource.name}"
end
