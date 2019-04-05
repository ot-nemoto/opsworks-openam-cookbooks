execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

package %w(java-1.7.0-openjdk java-1.7.0-openjdk-devel)

remote_file '/tmp/opendj.rpm' do
  source node['OPENDJ_RPM_URI'] || ENV['OPENDJ_RPM_URI']
end

rpm_package '/tmp/opendj.rpm' do
  action :install
end

service 'opendj' do
  action [:enable, :start]
end

execute "opendj-setup" do
  user "root"
  environment ({
    "ROOT_PW" => (node['ROOT_PW'] || ENV['ROOT_PW']),
    "BASE_DN" => (node['BASE_DN'] || ENV['BASE_DN'])
  })
  command <<-EOH
    /opt/opendj/setup --cli \
                      --acceptLicense \
                      --rootUserPassword ${ROOT_PW} \
                      --backendType pdb \
                      --baseDN ${BASE_DN} \
                      --addBaseEntry \
                      --no-prompt
  EOH
  action :run
end
