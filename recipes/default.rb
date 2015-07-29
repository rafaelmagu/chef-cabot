# rubocop:disable LineLength
#
# Cookbook Name:: cabot
# Recipe:: default
#
# Copyright (C) 2014 Rafael Fonseca
#
# MIT License
#

# dependency setup
%w(ubuntu git npm python redis build-essential).each do |cookbook|
  include_recipe cookbook
end

%w(ruby1.9.1 libpq-dev).each do |pkg|
  package pkg do
    action :install
  end
end

%w(coffee-script less).each do |pkg|
  npm_package pkg do
    action :install
  end
end

gem_package 'foreman' do
  action :install
end

{
    'Django' => '1.6.5',
        'Markdown' => '2.5',
        'PyJWT' => '0.1.2',
        'South' => '1.0',
        'anyjson' => '0.3.3',
        'argparse' => '1.2.1',
        'billiard' => '3.3.0.13',
        'celery' => '3.1.7',
        'distribute' => '0.6.24',
        'dj-database-url' => '0.2.2',
        'django-appconf' => '0.6',
        'django-celery' => '3.1.1',
        'django-celery-with-redis' => '3.0',
        'django-compressor' => '1.4',
        'django-filter' => '0.7',
        'django-jsonify' => '0.2.1',
        'django-mptt' => '0.6.0',
        'django-polymorphic' => '0.5.6',
        'django-redis' => '1.4.5',
        'django-smtp-ssl' => '1.0',
        'djangorestframework' => '2.4.2',
        'gunicorn' => '18.0',
        'gevent' => '1.0.1',
        'hiredis' => '0.1.1',
        'httplib2' => '0.7.7',
        'icalendar' => '3.2',
        'kombu' => '3.0.8',
        'mock' => '1.0.1',
        'psycogreen' => '1.0',
        'psycopg2' => '2.5.1',
        'pytz' => '2013.9',
        'redis' => '2.9.0',
        'requests' => '0.14.2',
        'six' => '1.5.1',
        'twilio' => '3.4.1',
        'wsgiref' => '0.1.2',
        'python-dateutil' => '2.1',
}.each do |mod, version|
  python_pip mod do
    action :install
    version version
  end
end

# user setup
group node[:cabot][:group]

user node[:cabot][:user] do
  supports manage_home: false
  home node[:cabot][:home_dir]
  group node[:cabot][:group]
  shell '/bin/bash'
end

directory node[:cabot][:home_dir] do
  action :create
  owner node[:cabot][:user]
  group node[:cabot][:group]
end

directory node[:cabot][:log_dir] do
  owner node[:cabot][:user]
  group node[:cabot][:group]
  mode 0775
end

# app deploy
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
            django_settings_module: node[:cabot][:django_settings_module],
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
  notifies :run, 'bash[run migrations]', :immediately
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
    foreman run python manage.py compress --force -e conf/#{node[:cabot][:environment]}.env
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
