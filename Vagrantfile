# -*- mode: ruby -*-
# vi: set ft=ruby :

registry_rb = './lib/registry.rb'
load registry_rb

Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/bionic64"
  config.vm.network "private_network", ip: "192.168.50.2"
  config.vm.provider "virtualbox" do |vb, override|
    vb.gui = false
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.define "faas" do |faas|
    faas.vm.hostname = "openfaas"
    faas.vm.provision "faas", type: "shell",
      path: "scripts/provision.sh",
      env: {"CR_SERVER" => Registry.new, "CR_USER" => Username.new, "CR_PAT" => Password.new},
      privileged: false
  end
end
