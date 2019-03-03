execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

package %w(git ruby-devel gcc gcc-c++ system-rpm-config zlib-devel libxml2-devel libxslt-devel mariadb mariadb-devel mariadb-server)

execute "ruby-install" do
  user "root"
  command <<-EOH
    amazon-linux-extras install -y ruby2.4 && \
    gem install bundler
  EOH
  action :run
end

service 'mariadb' do
  action [:enable, :start]
end

git "/root/sso-by-saml-sample-app" do
  repository "https://github.com/ot-nemoto/sso-by-saml-sample-app.git"
  action :sync
end

template '/root/sso-by-saml-sample-app/.env' do
  source 'env.erb'
end

execute "bundle-install" do
  user "root"
  command <<-EOH
    sudo $(which bundle) config build.nokogiri --use-system-libraries && \
    sudo $(which bundle) install --path vendor/bundle && \
    sudo $(which bundle) exec rake db:create && \
    sudo $(which bundle) exec rake db:migrate && \
    sudo $(which bundle) exec rails s -b 0.0.0.0 -p 80 -d
  EOH
  cwd '/root/sso-by-saml-sample-app'
  action :run
end
