require 'spec_helper'
describe 'area51_aduser' do

  context 'with defaults for all parameters' do
    it { should contain_class('area51_aduser') }
  end
end
