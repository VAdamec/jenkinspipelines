require 'spec_helper'

describe package('redis'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('redis'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
end
