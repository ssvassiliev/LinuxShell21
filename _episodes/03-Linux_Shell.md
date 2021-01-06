---
title: "Using Unix Shell"
teaching: 0
exercises: 0
questions:
- "Key question (FIXME)"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

## Introduction

## Setup

Windows:
- MobaXterm https://mobaxterm.mobatek.net/
- WSL
- Built-in ssh client

## Connecting to Compute Canada systems

You can connect to any of the following systems:
- beluga.computecanada.ca
- cedar.computecanada.ca
- graham.computecanada.ca
- siku.ace-net.ca

If you are using Mac, Linux or WSL open a terminal window and type:

~~~
ssh someuser@siku.ace-net.ca
~~~
{: .bash}

If you have MobaXterm, create a new SSH session.


Download some data:
~~~
git clone https://github.com/ssvassiliev/data-shell
~~~
{: .bash}


### Setting up passwordless access.
Create ssh key pair.
~~~
ssh-keygen
~~~
{: .bash}
Just press enter when prompted to use the default filename for the keys. The program will create a private key and a public key.

Where are they stored?

- By convention configuration settings of programs are stored in directories/files starting with '.'
- ssh stores keys and other settings in the directory .ssh
- Graphical file managers as well as command line utilities normally treat such files as hidden. Use 'ls -a' to show hidden files.

~~~
ls -l ~/.ssh
~~~
{: .bash}

~~~
total 2
-rw-------. 1 svassili svassili 1232 Jan 15  2020 authorized_keys
-rw-------. 1 svassili svassili 1679 Oct  1  2019 id_rsa
-rw-r--r--. 1 svassili svassili  412 Oct  1  2019 id_rsa.pub
-rw-r--r--. 1 svassili svassili 2086 Jan  4 19:57 known_hosts
~~~
{: .output}

The authorized_keys file contains public keys generated on the computers from which you want to enable passwordless access. Passwordless access from your laptop can be enabled manually by pasting contents of the local file ~/.ssh/id_rsa into the file ~/.ssh/authorized_keys on the remote computer. There a utility ssh-copy-id to assist with this process.

Copy your public key to the remote computer:

~~~
ssh-copy-id -i ~/.ssh/id_rsa someuser@siku.ace-net.ca:
~~~
{: .bash}

Permissions of the file authorized_keys are important! Passwordless access will only work if the file authorized_keys is accessible only for the owner.

#### WSL
[Installing WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10)

Highly recommend installing the open source [Windows Terminal](https://www.microsoft.com/en-ca/p/windows-terminal/9n0dx20hk701),  it is designed to give the best possible experience with command line.

### JupyterHubs on Beluga and Siku
[Beluga](https://jupyterhub.beluga.calculcanada.ca/hub/login)
[Siku](https://services.siku.ace-net.ca/jupyter/hub/spawn)

### Using Virtual Environments in JupyterHub

#### Installing and activating virtual environment:

~~~
module load StdEnv/2020 python/3.8.2 scipy-stack
virtualenv env-382
source env-382/bin/activate
pip install ipykernel
python -m ipykernel install --user --name=env-382
~~~
{: .bash}

#### Uninstalling virtual environment:

~~~
jupyter kernelspec list
jupyter kernelspec uninstall env-382
~~~
{: .bash}

Restart server:
File -> Hub Control Panel -> Stop My Server -> My Server

#### Visualization nodes on Graham
Graham has dedicated visualization node **gra-vdi.computecanada.ca**. To start using it you need to install TigerVNC Viewer. RealVNC or any other client will not work.
- Direct connection from your laptop with TigerVNC Viewer.
- Visualization node is shared between all logged in users, may be lagging depending on the workload.



#### Connecting to a compute node.
It is also possible to connect to a remote VNC desktop running on any compute node. For this you need to start VNC server on a compute node and establish ssh tunnel from your local computer to the node.

Exercise

- On Cedar submit interactive job

~~~
[svassili@cedar5 scratch]$ salloc --mem-per-cpu=1000 --time=3:0:0 --account=def-somePI
~~~
{: .bash}

- Once allocation is granted start VNC server

~~~
[svassili@cdr774 scratch]$ vncserver
~~~
{: .bash}

~~~
New 'cdr774.int.cedar.computecanada.ca:1 (svassili)' desktop is cdr774.int.cedar.computecanada.ca:1
~~~
{: .output}

Note the name of compute node (cdr774) and number of VNC session (:1). The base port number of VNC server is 5900. Port number to connect to vnc session is 5900 + session number = 5901 in this example. Do not close this terminal.
- Open ssh tunnel from your local computer to cdr774 (this command is executed on your LOCAL computer)

~~~
darkstar:~$ ssh cedar -L 5901:cdr774:5901
~~~
{: .source}

It will link port 5901 on cdr774 with port 5901 on your laptop.  Format of the command is LocalPort:RemoteHost:RemotePort. Once connection is established you can connect VNC viewer on your local computer to localhost:5901.

[Machine learning tutorial](
https://docs.computecanada.ca/wiki/Tutoriel_Apprentissage_machine/en)


{% include links.md %}
