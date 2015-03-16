.PHONY: all install

VAGRANT_DEB ?= https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb

all:
	# Type 'make install' to install

install: install-vagrant install-ansible vagrant-provision clean

install-ansible:
	@echo "Installing ansible"
	@sudo ./scripts/install-ansible.sh

install-vagrant:
	@echo "Installing vagrant"
	@sudo ./scripts/install-vagrant.sh

nfs:
	@echo "Installing nfs-kernel-server"
	@sudo apt-get install nfs-kernel-server

vagrant-provision: nfs
	@echo "Provisioning virtual machine"
	@vagrant plugin install vagrant-vbguest
	@vagrant plugin install vagrant-share
	@vagrant up --provision

clean:
	@sudo apt-get clean
