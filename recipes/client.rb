#
# Cookbook Name:: sensuconfig
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/sensu/plugins/check-socket.rb" do
  backup false
  path "/etc/sensu/plugins/check-socket.rb"
  action :create_if_missing
  mode 0755
end

cookbook_file "/etc/sensu/plugins/disk-usage-metrics.rb" do
  backup false
  path "/etc/sensu/plugins/disk-usage-metrics.rb"
  action :create_if_missing
  mode 0755
end

cookbook_file "/etc/sensu/plugins/vmstat-metrics.rb" do
  backup false
  path "/etc/sensu/plugins/vmstat-metrics.rb"
  action :create_if_missing
  mode 0755
end

# set up vmstat-metrics check
sensu_check "vmstat_metrics" do
  command "/etc/sensu/plugins/vmstat-metrics.rb --scheme stats.:::name:::"
  handlers ["graphite"]
  subscribers ["all"]
  standalone true
  interval 30
  type "metric"
end

# set up disk check
sensu_check "disk_usage_metrics" do
  command "/etc/sensu/plugins/disk-usage-metrics.rb --scheme stats.:::name:::.disk_usage"
  handlers ["graphite"]
  subscribers ["all"]
  interval 30
  type "metric"
  standalone true
end
