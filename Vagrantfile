# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/kinetic64"
  config.vm.box_check_update = false

  # In the virtual machine the project will be
  # accessible under the /host folder.
  config.vm.synced_folder ".", "/host"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  # Install FPGA tools and add vagrant user to the plugdev
  # group to allow it to access the USB->UART device.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y --no-install-recommends \
      fpga-icestorm \
      yosys \
      nextpnr-ice40 \
      iverilog \
      make
	usermod -a -G plugdev vagrant
  SHELL
end
