#
# Cookbook Name:: pm2
# Recipe:: default
#
# Copyright 2014, Joe Richards
#

include_recipe 'pm2::nodejs'
include_recipe 'pm2::pm2'

pm2_app node['pm2']['app_name']
