execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

package %w(httpd tomcat tomcat-webapps tomcat-admin-webapps java-1.8.0-openjdk java-1.8.0-openjdk-devel)

template '/etc/httpd/conf.d/openam.conf' do
  source 'httpd/openam.erb'
end

service 'httpd' do
  action [:enable, :start]
end

service 'tomcat' do
  action [:enable, :start]
end
