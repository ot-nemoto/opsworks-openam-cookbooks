execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

package %w(git httpd ruby-devel gcc gcc-c++ system-rpm-config zlib-devel libxml2-devel libxslt-devel mariadb mariadb-devel mariadb-server)

template '/etc/httpd/conf.d/sso-app.conf' do
  source 'httpd/sso-app.erb'
end

# BasicAuth
template '/etc/httpd/conf.d/basic-auth.conf' do
  source 'httpd/basic-auth.conf.erb'
end unless node['basic_auth'].nil?

file '/etc/httpd/conf/.htpasswd' do
  content lazy {
    f = Chef::Util::FileEdit.new(File.file?(path) ? path : '/dev/null')
    node['basic_auth'].each do |user|
      f.insert_line_if_no_match(/^#{user.name}:/, "#{user.name}:#{user.password.crypt('salt')}\n")
    end
    f.send(:editor).lines.join
  }
end unless node['basic_auth'].nil?

service 'httpd' do
  action [:enable, :start]
end

execute "ruby-install" do
  user "root"
  command <<-EOH
    amazon-linux-extras install -y ruby2.4 && \
    gem install bundler -v 1.17.3
  EOH
  action :run
end

service 'mariadb' do
  action [:enable, :start]
end

git "/home/ec2-user/sso-by-saml-sample-app" do
  repository "https://github.com/ot-nemoto/sso-by-saml-sample-app.git"
  user 'ec2-user'
  action :sync
end

template '/home/ec2-user/sso-by-saml-sample-app/.env' do
  source 'env.erb'
  owner 'ec2-user'
  group 'ec2-user'
end

execute "bundle-install" do
  user "ec2-user"
  command <<-EOH
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --path vendor/bundle && \
    bundle exec rake db:create && \
    bundle exec rake db:migrate && \
    bundle exec rails s -b 0.0.0.0 -d
  EOH
  cwd '/home/ec2-user/sso-by-saml-sample-app'
  environment ({
    'HOME' => '/home/ec2-user',
    'USER' => 'ec2-user'
  })
  action :run
end
