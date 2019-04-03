ENV["LC_ALL"] = "fr_FR.UTF-8"

Vagrant.configure(2) do |config|
    # Master 1 (node 1)
    config.vm.define "docker1" do |docker1|
        puts "name=docker1, fqdn=docker1.example.com, ip=10.10.0.201"
        # Ubuntu 18.04
        docker1.vm.box = "peru/ubuntu-18.04-desktop-amd64"
        docker1.vm.box_version = "20190401.01"
        docker1.vm.box_check_update = false
        docker1.vm.hostname = "docker1"
        ## Private network
        docker1.vm.network :private_network, ip: "10.10.0.201", netmask: "255.255.0.0", auto_config: true

        docker1.vm.provider "virtualbox" do |vb|
            vb.name = "docker1"
            vb.gui = false
            vb.linked_clone = true
            vb.memory = 4*1024
            vb.cpus = 2
        end

        docker1.vm.hostname = "docker1.example.com"
        docker1.vm.provision 'shell', path: 'provision-base.sh'
        docker1.vm.provision 'shell', path: 'provision-hosts.sh', args: ["docker1"]
    end

    # Slave 1 (node 2)
    config.vm.define "docker2" do |docker2|
        puts "name=docker2, fqdn=docker2.example.com, ip=10.10.0.202"
        # Ubuntu 18.04
        docker2.vm.box = "ubuntu/bionic64"
        docker2.vm.box_version = "20190402.0.0"
        docker2.vm.box_check_update = false
        docker2.vm.hostname = "docker2"
        ## Private network
        docker2.vm.network :private_network, ip: "10.10.0.202", netmask: "255.255.0.0", auto_config: true

        docker2.vm.provider "virtualbox" do |vb|
            vb.name = "docker2"
            vb.gui = false
            vb.linked_clone = true
            vb.memory = 2*1024
            vb.cpus = 1
        end

        docker2.vm.hostname = "docker2.example.com"
        docker2.vm.provision 'shell', path: 'provision-base.sh'
        docker2.vm.provision 'shell', path: 'provision-hosts.sh', args: ["docker2"]
    end

    # Slave 2 (node 3)
    config.vm.define "docker3" do |docker3|
        puts "name=docker3, fqdn=docker3.example.com, ip=10.10.0.203"
        # Ubuntu 18.04
        docker3.vm.box = "ubuntu/bionic64"
        docker3.vm.box_version = "20190402.0.0"
        docker3.vm.box_check_update = false
        docker3.vm.hostname = "docker3"
        ## Private network
        docker3.vm.network :private_network, ip: "10.10.0.203", netmask: "255.255.0.0", auto_config: true

        docker3.vm.provider "virtualbox" do |vb|
            vb.name = "docker3"
            vb.gui = false
            vb.memory = 2*1024
            vb.cpus = 1
        end

        docker3.vm.hostname = "docker3.example.com"
        docker3.vm.provision 'shell', path: 'provision-base.sh'
        docker3.vm.provision 'shell', path: 'provision-hosts.sh', args: ["docker3"]
    end
end
