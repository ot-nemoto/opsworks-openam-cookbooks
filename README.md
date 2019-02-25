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

### cookbooks

- ダウンロード可能な環境に `OpenAM-13.0.0.war` を配置
- `OpenAM-13.0.0.war` は https://backstage.forgerock.com/downloads/browse/am/archive からダウンロード可能(要アカウント登録)

```sh
git clone https://github.com/ot-nemoto/opsworks-openam.git cookbooks
cd cookbooks

export OPENAM_WAR_URI=https://example.com/OpenAM-13.0.0.war

# 実行
chef-client -z -o 'recipe[openam::default]'
```
