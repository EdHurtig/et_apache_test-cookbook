require 'serverspec'

# Required by serverspec
set :backend, :exec

# Generic Apache Server Tests
describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

# ensure that apache2 is installed and running
describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

# ensure port 80 is open and listening
describe port(80) do
  it { should be_listening }
end

# Note that these are dependent on node attributes which 
# I can't seem to access in this test file
describe file("/srv/www/test-site.evertrue.com/index.php") do
  it { should be_file }
end

describe file("/srv/www/test-site.evertrue.com/") do
  it { should be_directory }
end

# Ensure that PHP is installed
describe package('php5'), :if => os[:family] == 'ubuntu' do
 it { should be_installed }
end

describe file('/etc/alternatives/php') do 
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_executable.by_user('www-data') }
end 

describe file('/usr/bin/php') do
  it { should be_linked_to '/etc/alternatives/php' }
end

# Some Example PHP ini configuration variables
describe 'PHP config parameters' do
 context  php_config('default_mimetype') do
   its(:value) { should eq 'text/html' }
 end

 context php_config('session.cache_expire') do
   its(:value) { should eq 180 }
 end
end
