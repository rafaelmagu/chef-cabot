require 'spec_helper'

describe 'Cabot server' do
  it 'should have Cabot listening on port 5000' do
    expect(port 5000).to be_listening
  end
end
