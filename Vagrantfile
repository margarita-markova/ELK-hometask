Vagrant.configure("2") do |config|
    config.vm.box = "sbeliakou/centos"

    config.vm.define "tomcat" do |tomcat|
        tomcat.vm.hostname = "Tomcat-Node"
        tomcat.vm.network "private_network", ip: "192.168.45.30"

        tomcat.vm.provider "virtualbox" do |vb|
            vb.name = "Tomcat-Node"
            vb.memory = "2048"
        end

        tomcat.vm.provision 'shell', path: "script1.sh"
    end

    config.vm.define "elastic-kibana" do |elkb|
        elkb.vm.hostname = "EK"
        elkb.vm.network "private_network", ip: "192.168.46.30"

        elkb.vm.provider "virtualbox" do |vb|
            vb.name = "elastic-kibana"
            vb.memory = "2048"
        end

        elkb.vm.provision 'shell', path: "script2.sh"
    end
end