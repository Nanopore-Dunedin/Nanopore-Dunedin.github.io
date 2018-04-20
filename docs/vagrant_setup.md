**This markdown file will be turned into a proper html at some point, but for now...**
## Virtual boxes for nanopore sequencing analysis
For the data analysis component of the workshop we will be running the analysis through a virtual box.  
This allows you to familiarise yourself with the server-like interface on your own Desktop, with all the tools installed.

### Installation of Vagrant
Head to [Vagrant](https://www.vagrantup.com/downloads.html) and follow the instructions.

### Option 1 - preferred: Downloading the VM.
The VM has been uploaded to the Vagrant cloud, we can download it using the following commands.
1. Create the VM directory
  + `mkdir -p ~/Vagrant/nanopore_dunedin/`  
2. Change into the VM directory
  + `cd ~/Vagrant/nanopore_dunedin/`  
3. Generate the relevant Vagrant file
  + `vagrant init alexiswl/nanoporeVM`
  + *If you cannot find the vagrant command, try logging out and back in again*
4. Download the vagrant box.
  + `vagrant up`
  + This will redirect you to cloudstor. The file is a few Gbs, please be patient.
5. SSH into the vagrant box.
  + `vagrant ssh`
  + You should now be user vagrant@xenial_ont
  + xenial is the 'codename' for Ubuntu 16.

### Option 2 - alternative: Using the provided USB stick.
*Windows users should open up Git Bash, MacOSX and Ubuntu users can use terminal*  

1. Create the VM directory
  + `mkdir -p ~/Vagrant/nanopore_dunedin/`  
2. Change into the VM directory
  + `cd ~/Vagrant/nanopore_dunedin/`  
3. Move across the Vagrant box from the USB onto your computer.
  + `vagrant box add alexiswl/nanoporeVM /localpath/to/vagrant-box.box
4. Generate the relevant Vagrant file
  + `vagrant init alexiswl/nanoporeVM`
  + *If you cannot find the vagrant command, try logging out and back in again.
5. SSH into the vagrant box.
  + `vagrant up`
  + `vagrant ssh`
  + You should now be user vagrant@xenial_ont
  + xenial is the 'codename' for Ubuntu 16.
  

### Shared folders
By default, /vagrant on the VM is the mounted onto ~/Vagrant/nanopore_dunedin.  
We can use this to visualise and input our data.

### Running through Jupyter (advanced users)
For those that are fans of having a documented version of their analysis,
Jupyter is installed on the VM, however you will need to configure the vagrant file accordingly.  
See [this link](http://pythondata.com/jupyter-vagrant/) for more details.  
