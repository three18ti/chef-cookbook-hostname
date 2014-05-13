require 'chefspec'

describe 'set_hostname::vmware' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'set_hostname::vmware' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
