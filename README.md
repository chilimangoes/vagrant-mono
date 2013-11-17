Vagrant-Mono
============

This project contains everything necessary to set up a Vagrant box running Mono 3.x on Ubuntu 12.04 64-bit LTS (see below for instructions on changing the Mono version or Ubuntu platform).

Note that downloading and compiling Mono takes a *long* time. For this reason, I would not recommend directly using the code in this repository as a base for your own projects. Instead, after cloning the repository and building the Vagrant box with Mono, package up the resulting box and use the packaged box as a base for your own Vagrant project (see below for details). For an example of this, see the vagrant-mono-nginx repository, which uses the output from this box to build an ASP.NET web server running under Mono.


Prerequisites:
==============

1. Install VirtualBox - NOTE: If you are running on Windows 8 please make sure not to install the network drivers, as explained in this post: [http://www.grumpydev.com/2013/06/19/windows-8-hyper-v-virtualbox-vagrant-and-hanging-on-boot/](http://www.grumpydev.com/2013/06/19/windows-8-hyper-v-virtualbox-vagrant-and-hanging-on-boot/)
2. Install Vagrant from [http://www.vagrantup.com/](http://www.vagrantup.com/)


How to use this Vagrant box:
============================

Build it yourself
-------------------

```shell
	git clone git://github.com/chilimangoes/vagrant-mono.git
	cd vagrant-mono
	vagrant up
```

After that (compiling Mono can take 30 minutes or more), you'll have a Vagrant box running and ready to use Mono. Just run `vagrant ssh` to connect to the box and start using it. Note that your local directory will automatically be shared on the guest OS under the `/vagrant` directory, so you can edit code in your favorite IDE on your host OS and easilly run them on the guest OS without having to sync files back and forth.

After completing the provisioning and compilation process above, I would highly recommend packaging it up and using that packaged version as a base for you own boxes, rather than including the Mono compilation as part of your own VagrantFile. The reason is because the compilation process for Mono can take 30 minutes or more, which means that any time you want a clean slate, by using `vagrant destroy`, followed by `vagrant up`, the reprovisioning process will take a *very* long time.

You can package up your box by using the following comands:

```shell
	cd vagrant-mono
	vagrant package --base [VM_NAME]
```

... where `[VM_NAME]` is the name of the virtual machine in Virtual Box (or whatever VM provider you're using) that is being used for the current Vagrant Box. For example, right now on my machine, my `vagrant-mono` box is using a virtual machine, in Virtual Box, named `vagrant-mono-30_default_1380584429` so I would use the following command to package it up:

	vagrant package --base vagrant-mono_default_1383883992

The packaging process will take a few minutes, after which you will have a file named `package.box` in your current directory. You upload this box to a server to make it available to other developers, and you can add it to the list of boxes that Vagrant knows about using the following command:

	vagrant box add my_mono_box package.box

... where `my_mono_box` is the name you want to give to this packaged box. To create a new Vagrant box using your package, execute the follwing commands:

```shell
	cd ..
	mkdir mono_test
	cd mono_test
	vagrant init my_mono_box
	vagrant up
```

Use a pre-packaged box
----------------------

If you don't want to build Mono yourself, you can download the pre-built VM:

```shell
	vagrant box add vagrant-mono https://github.com/chilimangoes/vagrant-mono/releases/3.2.3/package.box
	vagrant init vagrant-mono
	vagrant up
```

You can also navagate to [https://github.com/chilimangoes/vagrant-mono/releases](https://github.com/chilimangoes/vagrant-mono/releases) to get prepackaged boxes for other versions of Mono (the release version will be the same as the version of Mono installed on that box).

Changing the Ubuntu or Mono release and other options
-----------------------------------------------------

You can change the linux distribution/platform/version by editing the `config.vm.box` and `config.vm.box_url` parameters in the Vagrantfile for this box. You can find a list of potential base boxes to use at [http://www.vagrantbox.es/](http://www.vagrantbox.es/). The `bootstrap.sh` file uses `apt-get` for installing prerequites, so I believe any debian-based distro will work, though I've only tested it with Ubunu.

To change the release of Mono, edit the `MONO_VERSION` variable at the top of the `./buld-support/provisioning/install-mono.sh` file. You can see a list of available Mono releases at [http://download.mono-project.com/sources/mono](http://download.mono-project.com/sources/mono).

This box comes configured with 512MB RAM. Depending on your application's needs, you can increase the amount of RAM allocated to your box by adding or editing the following setting in your VagrantFile:

	config.vm.provider :virtualbox do |vb|
		vb.customize ["modifyvm", :id, "--memory", "512"]
	end


Reference:
==========

The Vagrantfile and setup scripts used here are based on code and examples from various locations:

* https://github.com/NancyFx/Nancy.Vagrant
* https://github.com/david-mitchell/vagrant-mono-3.0
* http://christoph.ruegg.name/blog/test-csharp-fsharp-on-mono-with-vagrant.html
* http://alexfalkowski.blogspot.com/2013/03/web-development-on-mono.html

