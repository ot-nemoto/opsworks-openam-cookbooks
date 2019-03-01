# opsworks-openam-cookbooks

### Chef

```sh
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 12.18.31
chef-client -v
  # Chef: 12.18.31
```

### Git

```sh
sudo yum -y install git
```

### opsworks-openam

```sh
git clone https://github.com/ot-nemoto/opsworks-openam.git cookbooks
cd cookbooks
```

### openam

- ダウンロード可能な環境に `OpenAM-13.0.0.war` を配置
- `OpenAM-13.0.0.war` は https://backstage.forgerock.com/downloads/browse/am/archive からダウンロード可能(要アカウント登録)

```sh
export OPENAM_WAR_URI=https://example.com/OpenAM-13.0.0.war

# 実行
chef-client -z -o 'recipe[openam::default]'
```

### sso-app

```sh
export DEVISE_DEFAULT_URL_OPTIONS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
export BETTER_ERRORS_ALLOW_IP=0.0.0.0/0

# OpenAM
export OPENAM_URI=<OpenAM uri>
export OPENAM_ADMIN_USER=<OpenAM Administrator User Name>
export OPENAM_ADMIN_PASS=<OpenAM Administrator User Password>

export OPENAM_AWS_ROLE_ARN=<Aws Role Arn for OpenAM User>
export OPENAM_AWS_ID_PROVIDER_ARN=<Aws ID Provider Arn for OpenAM User>

# onelogin
export ONELOGIN_URI=https://<OneLogin Domain>/onlgoin.com
export ONELOGIN_CLIENT_ID=<API Credentials Client Id>
export ONELOGIN_CLIENT_SECRET=<API Credentials Client Secret>
export ONELOGIN_ROLE_ID=<onelogin User Role ID>
export ONELOGIN_APP_ID=<onelogin Application ID>

# 実行
chef-client -z -o 'recipe[sso-app::default]'
```
