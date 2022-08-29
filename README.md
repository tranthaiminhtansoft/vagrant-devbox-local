## Setup tools:

   - Install [Git](https://git-scm.com/downloads)
   - Install [VSCode](https://code.visualstudio.com/download)
   - Install VSCode extentions: "Remote - SSH"
   - Install [Vagrant](https://www.vagrantup.com/downloads.html)
   - Install [VirtualBox 6.x](https://www.virtualbox.org/wiki/Downloads)

## Up and running devbox:

The installation can take from 15-60 mins to finish, depends on your network speed.

### 1. Local VirtualBox machine:

```console
cd vagrant-virtualbox-1804
vagrant up
```

Port mapping from guest devbox to host:
- 22  <--> 2222
- 80  <--> 30080
- 443 <--> 30443

User/pass: `vagrant`/`vagrant`.

### 2. vSphere VM:

```console
cd vagrant-vsphere-1804
vagrant plugin install vagrant-vsphere
vagrant up
```



## Start coding inside devbox:

Open VSCode, use Remote SSH to connect to devbox.

Now, open a folder and start hacking the world.

VSCode shortcuts:
- Open folder: Ctrl + K + O
- Open Terminal: Ctrl + `