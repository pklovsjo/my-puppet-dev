require 'spec_helper'
describe 'area51_adauth' do

  context 'with defaults for all parameters' do
    it { should contain_class('area51_adauth') }
  end
end
