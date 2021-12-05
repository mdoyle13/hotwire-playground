# -*- mode: ruby -*-
# vi: set ft=ruby :

$rbenv_script = <<SCRIPT
if [ ! -d ~/.rbenv ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi
if [ ! -d ~/.rbenv/plugins/ruby-build ]; then
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
eval "$(rbenv init -)"
if [ ! -e .rbenv/versions/2.7.4 ]; then
  rbenv install 2.7.4
fi

cd /vagrant
rbenv global 2.7.4 && rbenv rehash
gem install bundler
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define :ruby do |deploy_config|
    deploy_config.vm.box = "ubuntu/bionic64"
    deploy_config.vm.hostname = "deploy"
    deploy_config.vm.network 'forwarded_port', guest: 3000, host: 3000
    deploy_config.vm.network 'forwarded_port', guest: 3035, host: 3035

    deploy_config.ssh.forward_agent = true
    
    deploy_config.vm.provider 'virtualbox' do |vb|
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = (`sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4) + 1024
      vb.customize ['modifyvm', :id, '--cpus', cpus]
      vb.customize ['modifyvm', :id, '--memory', mem]
    end

    deploy_config.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt install -y postgresql postgresql-contrib libpq-dev
      sudo apt install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev
      sudo -u postgres createuser -s vagrant
    SHELL
    
    # install node, npm and yarn for webpacker
    deploy_config.vm.provision :shell, privileged: false, inline: <<-SHELL
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
      source ~/.nvm/nvm.sh
      echo "source ~/.nvm/nvm.sh" >> ~/.bashrc
      nvm install 14
      npm install --global yarn
    SHELL
    
    deploy_config.vm.provision :shell, privileged: false, inline: $rbenv_script
  end
end
