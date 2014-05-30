#
# Cookbook Name:: pm2
# Resource:: app
#

actions :create, :delete, :restart

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => 'pm2'
attribute :port, :kind_of => [String], :default => node['pm2']['port']
attribute :path, :kind_of => [String], :default => node['pm2']['path']
attribute :js, :kind_of => [String], :default => node['pm2']['js']
attribute :user, :kind_of => [String], :default => node['pm2']['user']
attribute :group, :kind_of => [String], :default => node['pm2']['group']

attr_accessor :exists

def initialize(*args)
    super
    @action = :create
end
