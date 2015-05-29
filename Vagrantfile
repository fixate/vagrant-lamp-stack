# Hetznerish LAMP stack

VAGRANTFILE_API_VERSION = '2'

BOX = {
	name: 'debian64',
  url: 'https://github.com/kraksoft/vagrant-box-debian/releases/download/7.8.0/debian-7.8.0-amd64.box'
}.freeze

PORTS = {
	www: { guest: 80, host: 3000 },
	mysql: { guest: 3306, host: 8306 }
}

ENV.instance_eval do
  VARIABLES_REGEX = /\$([a-zA-Z_]+[a-zA-Z0-9_]*)|\$\{(.+)\}/.freeze

  def expand_variables(s)
    s.gsub(VARIABLES_REGEX) { self[$1||$2]  }
  end
end

$env = {}

def load_env!
  file = File.expand_path('../.vmrc', __FILE__)
  if File.exists?(file)
    File.open(file, 'r') do |f|
      f.each_line do |line|
        line = line.gsub(/^export /, "").strip
        key, value = line.split "="
        puts "#{key}=#{ENV.expand_variables(value)}"
        $env[key] = ENV.expand_variables(value)
      end
    end
  end
end

def sites_path
  ENV['SITES_PATH'] || $env['SITES_PATH']  || File.join(ENV['HOME'], 'Sites')
end

def array_wrap(obj)
  obj = [obj] unless obj.is_a?(Array)
  obj
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  load_env!
  puts $env

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

  config.vm.provision "shell",
    inline: <<-SHELL
      [[ -d "/usr/lib/VBoxGuestAdditions" ]] || ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
      curl -o /home/vagrant/new_site.sh https://gist.githubusercontent.com/sdbondi/37e5e02fafb8cd255118/raw/cdf238c58ea322a0a23351e279b01414ac0c6dd7/new_site.sh
    SHELL

	config.vm.box = BOX[:name]
	config.vm.box_url = BOX[:url]
	config.vm.synced_folder sites_path, "/var/www/sites", type: "nfs", mount_options: ['rw', 'vers=4', 'tcp', 'fsc', 'actimeo=2'] # requires nfs-kernel-server on host

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision/lamp-playbook.yml"
  end
end
