require 'spec_helper'

describe package('python'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end
