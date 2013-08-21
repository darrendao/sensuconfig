#
# Cookbook Name:: sensuconfig
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

##########################################################
# set up mailer handler
cookbook_file "/etc/sensu/handlers/mailer.rb" do
  backup false
  path "/etc/sensu/handlers/mailer.rb"
  action :create_if_missing
end
cookbook_file "/etc/sensu/handlers/mailer.json" do
  backup false
  path "/etc/sensu/handlers/mailer.json"
  action :create_if_missing
end
sensu_handler "mailer" do
  type "pipe"
  command "/etc/sensu/handlers/mailer.rb"
end

##########################################################
# GRAPHITE related stuff
#
# install gem needed for hooking into graphite
gem_package "simple-graphite"

# configure graphite handler to forward metrics to sensu
sensu_handler "graphite" do
  type "pipe"
  command "/usr/bin/ruby /etc/sensu/handlers/graphite.rb"
end
cookbook_file "/etc/sensu/handlers/graphite.rb" do
  backup false
  path "/etc/sensu/handlers/graphite.rb"
  action :create_if_missing
  mode 0755
end


#########################################################
# Example of monitoring a web service
sensu_check "check-http" do
  command "/etc/sensu/plugins/check-http.rb -h localhost -p /"
  handlers ["default"]
  subscribers ["webserver"]
  interval 30
end
