# Hetznerish LAMP stack

VAGRANTFILE_API_VERSION = '2'

BOX = {
	name: 'debian64',
  url: 'https://github.com/kraksoft/vagrant-box-debian/releases/download/7.8.0/debian-7.8.0-amd64.box'
}.freeze

PORTS = {
	www: { guest: 80, host: 8000 },
	mysql: { guest: 3306, host: 8306 }
}

def sites_path
  path = ENV['SITES_PATH'] || File.join(ENV['HOME'], 'Sites')
  `mkdir -p #{path}` unless Dir.exist?(path)
  path
end

def array_wrap(obj)
  obj = [obj] unless obj.is_a?(Array)
  obj
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 2
	end

	config.vm.network "private_network", ip: '10.0.99.101'

	PORTS.each do |_name, ports|
    array_wrap(ports).each do |port|
      config.vm.network "forwarded_port", port
    end
	end

	config.vm.box = BOX[:name]
	config.vm.box_url = BOX[:url]
	config.vm.synced_folder sites_path, "/var/www/sites", type: "nfs", mount_options: ['rw', 'vers=4', 'tcp', 'fsc', 'actimeo=2'] # requires nfs-kernel-server on host

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision/lamp-playbook.yml"
  end
end
