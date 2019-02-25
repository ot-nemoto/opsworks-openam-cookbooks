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

```sh
git clone https://github.com/ot-nemoto/opsworks-openam.git cookbooks
cd cookbooks

# 実行
chef-client -z -o 'recipe[openam::default]'
```
