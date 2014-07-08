# rubocop:disable LineLength
require 'spec_helper'

describe 'cabot::default' do
  cached(:chef_run) { ChefSpec::Runner.new(log_level: :fatal).converge(described_recipe) }

  before do
    # stub_command("npm -v 2>&1 | grep '1.1.0-3'").and_return(true)
    stub_command('which nginx').and_return('/usr/bin/nginx')
  end

  it 'should include dependency cookbooks' do
    %w(ubuntu git nginx python redis build-essential).each do |cookbook|
      expect(chef_run).to include_recipe(cookbook)
    end
  end

  it 'should create a cabot group' do
    expect(chef_run).to create_group('cabot')
  end

  it 'should create a cabot user' do
    expect(chef_run).to create_user('cabot').with(supports: { manage_home: true }, home: '/opt/cabot')
  end

  it 'should install ruby and foreman gem' do
    expect(chef_run).to install_package('ruby1.9.1')
    expect(chef_run).to install_gem_package('foreman')
  end

  it 'should create home dir manually' do
    expect(chef_run).to create_directory('/opt/cabot')
  end

  it 'should sync app code from repo' do
    expect(chef_run).to sync_git('/opt/cabot')
  end

  it 'should create an environment template for production' do
    expect(chef_run).to create_template('/opt/cabot/conf/production.env')
  end

  { 'Django' => '1.4.10', 'PyJWT' => '0.1.2', 'South' => '0.7.6', 'amqp' => '1.3.3', 'anyjson' => '0.3.3',
    'argparse' => '1.2.1', 'billiard' => '3.3.0.13', 'celery' => '3.1.7', 'distribute' => '0.6.24',
    'dj-database-url' => '0.2.2', 'django-appconf' => '0.6', 'django-celery' => '3.1.1',
    'django-celery-with-redis' => '3.0', 'django-compressor' => '1.2', 'django-jsonify' => '0.2.1',
    'django-mptt' => '0.6.0', 'django-polymorphic' => '0.5.3', 'django-redis' => '1.4.5', 'django-smtp-ssl' => '1.0',
    'gunicorn' => '18.0', 'hiredis' => '0.1.1', 'httplib2' => '0.7.7', 'icalendar' => '3.2', 'kombu' => '3.0.8',
    'mock' => '1.0.1', 'psycopg2' => '2.5.1', 'pytz' => '2013.9', 'redis' => '2.9.0', 'requests' => '0.14.2',
    'six' => '1.5.1', 'twilio' => '3.4.1', 'wsgiref' => '0.1.2', 'python-dateutil' => '2.1' }.each do |mod, version|
    it "should install the version #{version} of python module #{mod}" do
      expect(chef_run).to install_pip(mod).with(version: version)
    end
  end
end
