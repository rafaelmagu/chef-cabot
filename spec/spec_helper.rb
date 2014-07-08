require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require_relative 'support/matchers'

# ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'
end
