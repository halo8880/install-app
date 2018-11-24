Vagrant.configure("2") do |config|

    config.vm.define :alpha do |alpha|
      alpha.vm.box = "ubuntu/trusty64"
      alpha.vm.network "private_network", ip: "192.168.10.6"
	  
	#  alpha.vm.network "forwarded_port", guest: 5432, host: 65432
	#  alpha.vm.network "forwarded_port", guest: 8080, host: 8081
	#  alpha.vm.network "forwarded_port", guest: 1234, host: 1234
	#  alpha.vm.network "forwarded_port", guest: 5000, host: 5001
	#  alpha.vm.network "forwarded_port", guest: 3000, host: 3001
  
  
      alpha.vm.hostname = "server"
      alpha.vm.provider "virtualbox" do |vba|
         vba.gui = false
         vba.memory = "2048"
       end
    end
    
    config.vm.define :beta do |beta|
      beta.vm.box = "ubuntu/trusty64"
      beta.vm.network "private_network", ip: "192.168.10.7"
      beta.vm.hostname = "developer"
	  
	  beta.vm.network "forwarded_port", guest: 5432, host: 65432
	  
      beta.vm.provider "virtualbox" do |vbb|
         vbb.gui = false
         vbb.memory = "1024"
       end
    end
	
	config.vm.define :gamma do |gamma|
      gamma.vm.box = "ubuntu/trusty64"
      gamma.vm.network "private_network", ip: "192.168.10.8"
      gamma.vm.hostname = "student"
	  gamma.vm.network "forwarded_port", guest: 8080, host: 8081
      gamma.vm.provider "virtualbox" do |vbb|
         vbb.gui = false
         vbb.memory = "1024"
       end
    end

end