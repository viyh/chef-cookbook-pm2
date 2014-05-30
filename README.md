pm2 Cookbook
======================
This Chef cookbook provides recipes to install and setup [node.js](http://nodejs.org/), [pm2](https://github.com/unitech/pm2) and provides an LWRP for easy setup of node apps managed by pm2.

Requirements
------------
The only requirement is the `nodejs` cookbook

Attributes
----------

#### pm2::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pm2']['app_name']</tt></td>
    <td>String</td>
    <td>A name for the node app</td>
    <td><tt>app</tt></td>
  </tr>
  <tr>
    <td><tt>['pm2']['port']</tt></td>
    <td>String</td>
    <td>Port for the backend</td>
    <td><tt>8080</tt></td>
  </tr>
  <tr>
    <td><tt>['pm2']['path']</tt></td>
    <td>String</td>
    <td>Path to the root of the node app</td>
    <td><tt>/var/www/app</tt></td>
  </tr>
  <tr>
    <td><tt>['pm2']['user']</tt></td>
    <td>String</td>
    <td>User to run the node app as</td>
    <td><tt>nobody</tt></td>
  </tr>
  <tr>
    <td><tt>['pm2']['group']</tt></td>
    <td>String</td>
    <td>Group to run the node app as</td>
    <td><tt>nobody</tt></td>
  </tr>
  <tr>
    <td><tt>['pm2']['js']</tt></td>
    <td>String</td>
    <td>Main JS file to run</td>
    <td><tt>app.coffee</tt></td>
  </tr>
</table>

Usage
-----
#### pm2::default

Installs node.js, pm2, and a pm2 application. You must set the pm2 attributes for this recipe to work and it assumes you are running only a single application with pm2.

#### pm2::nodejs

Installs node.js using the nodejs::default recipe.

#### pm2::pm2

Installs pm2 and associated packages.

#### LWRP: pm2_app

This LWRP provides a simple way to deploy multiple applications with pm2. Usage is as follows:

```
pm2_app 'my_app_1' do
    path    '/var/www/my_app_1'
    js      'main.js'
    user    'nobody'
    group   'nobody'
    port    '8080'
    action  :create
end
```

This will setup a node.js application with pm2 called "my_app_1" with your code located at the path specified. Pm2 will run the code as the specified user/group and setup a listener on the specified port. If these attributes aren't specified, it will default to the node pm2 attributes.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Joe Richards <nospam-github@disconformity.net>
