# rubocop:disable LineLength
#
# Cookbook Name:: cabot
# Recipe:: default
#
# Copyright (C) 2014 Rafael Fonseca
#
# MIT License
#

%w(ubuntu git nginx python redis build-essential).each do |cookbook|
  include_recipe cookbook
end

group node[:cabot][:group]

user node[:cabot][:user] do
  supports manage_home: false
  home node[:cabot][:home_dir]
  group node[:cabot][:group]
  shell '/bin/bash'
end

package 'ruby1.9.1' do
  action :install
end

gem_package 'foreman' do
  action :install
end

directory node[:cabot][:home_dir] do
  owner node[:cabot][:user]
  group node[:cabot][:group]
end

git node[:cabot][:home_dir] do
  action :sync
  repository node[:cabot][:repo_url]
  user node[:cabot][:user]
  group node[:cabot][:group]
end

template "#{node[:cabot][:home_dir]}/conf/production.env" do
  action :create
  source 'production.env.erb'
  variables(
            debug: node[:cabot][:debug],
            database_url: node[:cabot][:database_url],
            port: node[:cabot][:port],
            virtualenv_dir: node[:cabot][:virtualenv_dir],
            admin_email: node[:cabot][:admin_email],
            from_email: node[:cabot][:from_email],
            ical_url: node[:cabot][:ical_url],
            celery_broker_url: node[:cabot][:celery_broker_url],
            django_secret_key: node[:cabot][:django_secret_key],
            graphite_api_url: node[:cabot][:graphite_api_url],
            graphite_username: node[:cabot][:graphite_username],
            graphite_password: node[:cabot][:graphite_password],
            hipchat_room_id: node[:cabot][:hipchat_room_id],
            hipchat_api_key: node[:cabot][:hipchat_api_key],
            jenkins_api_url: node[:cabot][:jenkins_api_url],
            jenkins_username: node[:cabot][:jenkins_username],
            jenkins_password: node[:cabot][:jenkins_password],
            smtp_host: node[:cabot][:smtp_host],
            smtp_username: node[:cabot][:smtp_username],
            smtp_password: node[:cabot][:smtp_password],
            smtp_port: node[:cabot][:smtp_port],
            twilio_account_sid: node[:cabot][:twilio_account_sid],
            twilio_auth_token: node[:cabot][:twilio_auth_token],
            twilio_outgoing_number: node[:cabot][:twilio_outgoing_number],
            www_http_host: node[:cabot][:www_http_host],
            www_scheme: node[:cabot][:www_scheme]
          )
  notifies :run, 'bash[install from requirements.txt]'
end

bash 'run migrations' do
  cwd node[:cabot][:home_dir]
  code <<-EOH
    foreman run python manage.py syncdb -e conf/#{node[:cabot][:environment]}.env
    foreman run python manage.py migrate cabotapp --noinput -e conf/#{node[:cabot][:environment]}.env
  EOH
  action :nothing
  notifies :run, 'bash[collect static assets]', :immediately
end

bash 'collect static assets' do
  cwd node[:cabot][:home_dir]
  code <<-EOH
    foreman run python manage.py collectstatic --noinput -e conf/#{node[:cabot][:environment]}.env
    foreman run python manage.py compress -e conf/#{node[:cabot][:environment]}.env
  EOH
  action :nothing
  notifies :run, 'bash[setup upstart]', :immediately
end

service 'cabot' do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

bash 'setup upstart' do
  cwd node[:cabot][:home_dir]
  code <<-EOH
    foreman export upstart /etc/init -f #{node[:cabot][:home_dir]}/Procfile -e #{node[:cabot][:home_dir]}/conf/#{node[:cabot][:environment]}.env -u #{node[:cabot][:user]} -a cabot -t #{node[:cabot][:home_dir]}/upstart
  EOH
  action :nothing
  notifies :start, 'service[cabot]'
end
