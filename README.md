# cabot-cookbook
![travis build status](https://travis-ci.org/rafaelmagu/chef-cabot.svg?branch=master)


[Cabot](http://cabotapp.com) is a self-hosted watchdog for your websites and infrastructure. This cookbook installs and configures a basic setup.

## Supported Platforms

Made with love for Ubuntu (12.04, 14.04)

## Dependencies

This cookbook depends on community versions of the following cookbooks:

* build-essential
* git
* nginx
* nodejs
* npm
* python
* redis

Additionally, it will install Ruby from default APT repos, and Foreman.

## Attributes

All keys below live under the <tt>cabot</tt> namespace. Eg. <tt>user</tt> is available as <tt>node[:cabot][:user]</tt>

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>user</tt></td>
    <td>String</td>
    <td>User to run Cabot as</td>
    <td><tt>cabot</tt></td>
  </tr>
  <tr>
    <td><tt>group</tt></td>
    <td>String</td>
    <td>Group to run Cabot as</td>
    <td><tt>cabot</tt></td>
  </tr>
  <tr>
    <td><tt>home_dir</tt></td>
    <td>String</td>
    <td>Home dir</td>
    <td><tt>/opt/cabot</tt></td>
  </tr>
  <tr>
    <td><tt>log_dir</tt></td>
    <td>String</td>
    <td>Log dir</td>
    <td><tt>/var/log/cabot</tt></td>
  </tr>
  <tr>
    <td><tt>repo_url</tt></td>
    <td>String</td>
    <td>GitHub repository to pull Cabot code from.</td>
    <td><tt>https://github.com/arachnys/cabot.git</tt></td>
  </tr>
  <tr>
    <td><tt>environment</tt></td>
    <td>String</td>
    <td>Sets the environment type (development or production). This sets whether to use SQLite or PostgreSQL databases.</td>
    <td><tt>production</tt></td>
  </tr>
  <tr>
    <td><tt>database_url</tt></td>
    <td>String</td>
    <td>Sets the Django database URL</td>
    <td><tt>sqlite:///cabot.db</tt></td>
  </tr>
  <tr>
    <td><tt>port</tt></td>
    <td>Integer</td>
    <td>Sets the port on which Cabot UI listens for requests</td>
    <td><tt>5000</tt></td>
  </tr>
  <tr>
    <td><tt>admin_email</tt></td>
    <td>String</td>
    <td>Emails sent from Django are sent to</td>
    <td><tt>you@example.com</tt></td>
  </tr>
  <tr>
    <td><tt>from_email</tt></td>
    <td>String</td>
    <td>From address to send emails with</td>
    <td><tt>cabot@example.com</tt></td>
  </tr>
  <tr>
    <td><tt>ical_url</tt></td>
    <td>String</td>
    <td>URL of calendar to synchronise rota with</td>
    <td><tt>http://www.google.com/calendar/ical/example.ics</tt></td>
  </tr>
  <tr>
    <td><tt>celery_broker_url</tt></td>
    <td>String</td>
    <td>Django setting</td>
    <td><tt>redis://:yourrediskey@localhost:6379/1</tt></td>
  </tr>
  <tr>
    <td><tt>django_secret_key</tt></td>
    <td>String</td>
    <td>Django setting</td>
    <td><tt>2FL6ORhHwr5eX34pP9mMugnIOd3jzVuT45f7w430Mt5PnEwbcJgma0q8zUXNZ68A</tt></td>
  </tr>
  <tr>
    <td><tt>graphite_api_url</tt></td>
    <td>String</td>
    <td>Hostname of Graphite server instance</td>
    <td><tt>http://graphite.example.com/</tt></td>
  </tr>
  <tr>
    <td><tt>graphite_username</tt></td>
    <td>String</td>
    <td>Username used to authenticate with Graphite</td>
    <td><tt>username</tt></td>
  </tr>
  <tr>
    <td><tt>graphite_password</tt></td>
    <td>String</td>
    <td>Password used to authenticate with Graphite</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>hipchat_room_id</tt></td>
    <td>String</td>
    <td>Hipchat room ID (find it at https://hipchat.com/admin/rooms)</td>
    <td><tt>123456</tt></td>
  </tr>
  <tr>
    <td><tt>hipchat_api_key</tt></td>
    <td>String</td>
    <td>Hipchat API key (get one at https://hipchat.com/admin/api)</td>
    <td><tt>your_hipchat_api_key</tt></td>
  </tr>
  <tr>
    <td><tt>jenkins_api_url</tt></td>
    <td>String</td>
    <td>Jenkins server URL</td>
    <td><tt>https://jenkins.example.com/</tt></td>
  </tr>
  <tr>
    <td><tt>jenkins_username</tt></td>
    <td>String</td>
    <td>Username used to authenticate with Jenkins (optiona/td>
    <td><tt>username</tt></td>
  </tr>
  <tr>
    <td><tt>jenkins_password</tt></td>
    <td>String</td>
    <td>Password used to authenticate with Jenkins</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>smtp_host</tt></td>
    <td>String</td>
    <td>SMTP hostname to use for sending emails</td>
    <td><tt>email-smtp.us-east-1.amazonaws.com</tt></td>
  </tr>
  <tr>
    <td><tt>smtp_username</tt></td>
    <td>String</td>
    <td>SMTP username</td>
    <td><tt>username</tt></td>
  </tr>
  <tr>
    <td><tt>smtp_password</tt></td>
    <td>String</td>
    <td>SMTP password</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>smtp_port</tt></td>
    <td>String</td>
    <td>SMTP port</td>
    <td><tt>465</tt></td>
  </tr>
  <tr>
    <td><tt>twilio_account_sid</tt></td>
    <td>String</td>
    <td>Your Twilio account SID</td>
    <td><tt>your_twilio_account_sid</tt></td>
  </tr>
  <tr>
    <td><tt>twilio_auth_token</tt></td>
    <td>String</td>
    <td>Your Twilio auth token</td>
    <td><tt>your_twilio_auth_token</tt></td>
  </tr>
  <tr>
    <td><tt>twilio_outgoing_number</tt></td>
    <td>String</td>
    <td>Your Twilio number for outbound calls</td>
    <td><tt>+1234567890</tt></td>
  </tr>
  <tr>
    <td><tt>www_http_host</tt></td>
    <td>String</td>
    <td>Used for pointing links back in alerts, etc.</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>www_scheme</tt></td>
    <td>String</td>
    <td>Which URL scheme to use (http or https)</td>
    <td><tt>http</tt></td>
  </tr>
  <tr>
    <td><tt>www_port</tt></td>
    <td>Integer</td>
    <td>Port to set reverse proxy on</td>
    <td><tt>80</tt></td>
  </tr>
  <tr>
    <td><tt>django_settings_module</tt></td>
    <td>String</td>
    <td>Django settings module name</td>
    <td><tt>cabot.settings</tt></td>
  </tr>
</table>

## Usage

### cabot::default

Include `cabot` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cabot::default]"
  ]
}
```

### cabot::proxy

Include `cabot::proxy` in your node's `run_list` to have Nginx as a reverse proxy to Cabot on port 80.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Rafael Fonseca (<rafael.magu@gmail.com>)
