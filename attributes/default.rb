# app location and node server ID
default['pm2']['app_name']    = 'app'

# rando port to run the backend on
default['pm2']['port']        = '8080'

# url prefix used to access the node app via http
default['pm2']['mount_point'] = '/'

default['pm2']['path']    = '/var/www/app'
default['pm2']['user']    = 'nobody'
default['pm2']['group']   = 'nobody'
default['pm2']['js']      = 'app.coffee'
