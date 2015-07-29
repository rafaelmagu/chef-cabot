default[:cabot][:user] = 'cabot'
default[:cabot][:group] = 'cabot'
default[:cabot][:home_dir] = '/opt/cabot'
default[:cabot][:log_dir] = '/var/log/cabot'
default[:cabot][:virtualenv_dir] = "#{node[:cabot][:home_dir]}/venv"

default[:cabot][:repo_url] = 'https://github.com/arachnys/cabot.git'

default[:cabot][:environment] = 'production'

if node[:cabot][:environment] == 'production'
  default[:cabot][:debug] = 't'
else
  default[:cabot][:debug] = 'f'
end

default[:cabot][:database_url] = 'sqlite:///cabot.db'
default[:cabot][:port] = 5000
default[:cabot][:admin_email] = 'you@example.com'
default[:cabot][:from_email] = 'cabot@example.com'
default[:cabot][:ical_url] = 'http://www.google.com/calendar/ical/example.ics'
default[:cabot][:celery_broker_url] = 'redis://:yourrediskey@localhost:6379/1'
default[:cabot][:django_secret_key] = '2FL6ORhHwr5eX34pP9mMugnIOd3jzVuT45f7w430Mt5PnEwbcJgma0q8zUXNZ68A' # rubocop:disable LineLength
default[:cabot][:graphite_api_url] = 'http://graphite.example.com/'
default[:cabot][:graphite_username] = 'username'
default[:cabot][:graphite_password] = 'password'
default[:cabot][:hipchat_room_id] = '123456'
default[:cabot][:hipchat_api_key] = 'your_hipchat_api_key'
default[:cabot][:jenkins_api_url] = 'https://jenkins.example.com/'
default[:cabot][:jenkins_username] = 'username'
default[:cabot][:jenkins_password] = 'password'
default[:cabot][:smtp_host] = 'email-smtp.us-east-1.amazonaws.com'
default[:cabot][:smtp_username] = 'username'
default[:cabot][:smtp_password] = 'password'
default[:cabot][:smtp_port] = '465'
default[:cabot][:twilio_account_sid] = 'your_twilio_account_sid'
default[:cabot][:twilio_auth_token] = 'your_twilio_auth_token'
default[:cabot][:twilio_outgoing_number] = '+1234567890'
default[:cabot][:www_http_host] = 'localhost'
default[:cabot][:www_scheme] = 'http'
default[:cabot][:www_port] = 80
default[:cabot][:django_settings_module] = 'cabot.settings'

default[:cabot][:postgresql][:database] = 'index'
default[:cabot][:postgresql][:username] = 'cabot'
default[:cabot][:postgresql][:password] = 'changeme'

default[:'build-essential'][:compile_time] = true

default[:apt][:compile_time_update] = true
default[:nginx][:default_site_enabled] = false
default[:npm][:version] = '1.4.20'
default[:nodejs][:npm] = node[:npm][:version]
# default[:nodejs][:install_method] = 'package'
