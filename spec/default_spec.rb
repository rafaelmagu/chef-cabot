# rubocop:disable LineLength
require 'spec_helper'

describe 'cabot::default' do
  cached(:chef_run) { ChefSpec::Runner.new(log_level: :fatal).converge(described_recipe) }

  before do
    stub_command("npm -v 2>&1 | grep '1.4.20'").and_return(true)
  end

  context 'dependency setup' do
    %w(ubuntu git npm python redis build-essential).each do |cookbook|
      it "should include #{cookbook}" do
        expect(chef_run).to include_recipe(cookbook)
      end
    end

    %w(ruby1.9.1 libpq-dev).each do |pkg|
      it "should install #{pkg}" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'should install foreman ruby gem' do
      expect(chef_run).to install_gem_package('foreman')
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
      it "should install version #{version} of python module #{mod}" do
        expect(chef_run).to install_python_pip(mod).with(version: version)
      end
    end
  end

  context 'user setup' do
    it 'should create home dir manually' do
      expect(chef_run).to create_directory('/opt/cabot').with(owner: 'cabot', group: 'cabot')
    end

    it 'should create log dir manually' do
      expect(chef_run).to create_directory('/var/log/cabot').with(owner: 'cabot', group: 'cabot', mode: 0775)
    end

    it 'should create a cabot group' do
      expect(chef_run).to create_group('cabot')
    end

    it 'should create a cabot user' do
      expect(chef_run).to create_user('cabot').with(supports: { manage_home: false }, home: '/opt/cabot')
    end
  end

  context 'app deploy' do
    it 'should sync app code from repo' do
      expect(chef_run).to sync_git('/opt/cabot')
    end

    it 'should create an environment template for production' do
      expect(chef_run).to create_template('/opt/cabot/conf/production.env')
    end
  end
end
