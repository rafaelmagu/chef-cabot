# rubocop:disable LineLength
require 'spec_helper'

describe 'cabot::proxy' do
  cached(:chef_run) { ChefSpec::Runner.new(log_level: :fatal).converge(described_recipe) }

  before do
    stub_command('which nginx').and_return('/usr/bin/nginx')
  end

  it 'should include nginx cookbook' do
    expect(chef_run).to include_recipe('nginx')
  end
end
