include_recipe "mongodb-10gen::branch20"

node.set['mongodb']['node_type'] = "configsvr"
node.load_attribute_by_short_filename("default","mongodb-10gen")

directory File.join(node['mongodb']['data_dir'], node['mongodb']['nodename']) do
  owner "mongodb"
  group "mongodb"
  mode 00700
end

directory File.join(node['mongodb']['log_dir']) do
  owner "mongodb"
  group "mongodb"
  mode 00755
end

template File.join("/etc/init", "#{node['mongodb']['nodename']}.conf") do
  source "init_mongodb.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :nodename => node['mongodb']['nodename'],
    :data_dir => node['mongodb']['data_dir'],
    :log_dir  => node['mongodb']['log_dir']
  )
end

template File.join("/etc/logrotate.d", node['mongodb']['nodename']) do
  source "logrotate_mongodb.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :nodename => node['mongodb']['nodename'],
    :log_dir  => node['mongodb']['log_dir']
  )
end

template File.join(node['mongodb']['etc_dir'], "#{node['mongodb']['nodename']}.conf") do
  source "mongodb.conf.erb"
  owner "mongodb"
  group "mongodb"
  mode 00600
  variables(
                 :nodename => node['mongodb']['nodename'],
                 :data_dir => node['mongodb']['data_dir'],
                  :log_dir => node['mongodb']['log_dir'],
                     :port => node['mongodb']['port'],
              :enable_rest => node['mongodb']['enable_jsonp'],
             :enable_jsonp => node['mongodb']['enable_jsonp'],
          :enable_shardsvr => node['mongodb']['enable_shardsvr'],
         :enable_configsvr => node['mongodb']['enable_configsvr'],
         :enable_nojournal => node['mongodb']['enable_nojournal'],
    :enable_directoryperdb => node['mongodb']['enable_directoryperdb']
  )
  notifies :restart, "service[#{node['mongodb']['nodename']}]"
end


service node['mongodb']['nodename'] do
  case node['platform']
  when "ubuntu"
    if node['platform_version'].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [:enable, :start]
end
