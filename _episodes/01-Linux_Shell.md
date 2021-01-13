---
title: "Using Unix Shell"
teaching: 90
exercises: 0
questions:
- "How to use Unix Shell"
- "How to connect to Compute Canada systems"
- "How to transfer data in and out of the systems"
objectives:
- "Learn to use command line interface"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

## SETUP

### Before the session
#### Please print your name and pick a guest account from the list [**here**](https://docs.google.com/document/d/1O7scs_BOs750VhutslvvCK0sL72hwGP28vi1nz6GXr8/edit?usp=sharing)

### Installing command line tools
Windows:

The best option is to install WSL.
1. Enable the "Windows Subsystem for Linux".
- Type "turn windows features on or off" on the search bar.
- Check "Windows Subsystem for Linux".
- Reboot.
2. Install [Ubuntu](https://www.microsoft.com/en-ca/p/ubuntu-2004-lts/9n6svws3rx71?rtc=1&activetab=pivot:overviewtab)
3. Install [Windows Terminal](https://www.microsoft.com/en-ca/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) (optional, but highly recommended).  This terminal app is designed to give the best possible experience with command line.

If you have an older Windows and WSL installation does not work for you, install [MobaXterm](https://mobaxterm.mobatek.net/)
### Setting up graphical connection

If you would like to try graphical remote desktop connection you will need to install TigerVNC viewer. Other VNC clients will not work with CC systems.

Ubuntu:
~~~
sudo apt install vncviewer
~~~
{: .bash}
CentOS:
~~~
sudo yum install tigervnc
~~~
{: .bash}

Windows + WSL:

- Install vncviewer from Ubuntu command prompt as described above
- Install [VcXsrv X-Server](https://sourceforge.net/projects/vcxsrv/)

Windows + MobaXterm:

- Install [TigerVNC viewer](https://bintray.com/tigervnc/stable/tigervnc/1.11.0).
Direct [download](https://bintray.com/tigervnc/stable/download_file?file_path=vncviewer-1.11.0.exe) link.

MacOS:

- Install [TigerVNC viewer](
https://bintray.com/tigervnc/stable/tigervnc/1.11.0)
Direct [download](https://bintray.com/tigervnc/stable/download_file?file_path=TigerVNC-1.11.0.dmg) link.

### Useful links
Compute Canada [VNC documentation](https://docs.computecanada.ca/wiki/VNC)

## Connecting to Compute Canada systems

With Compute Canada account you can connect to any of the following systems:
- beluga.computecanada.ca
- cedar.computecanada.ca
- graham.computecanada.ca
- siku.ace-net.ca
- nova.ace-net.training

If you are using Mac, Linux or WSL open a terminal window and type:

~~~
ssh someuser@siku.ace-net.ca
~~~
{: .bash}

If you have MobaXterm, create a new SSH session.

### Login & compute nodes
When you open ssh session you will be logged in to one of the LOGIN nodes.

How do you know if you are on a login node?

System  | Login nodes   | Compute nodes|
--------|---------------|-------------|
graham  |gra-login[1-3] | gra
cedar   |cedar[1-5]     | cdr
beluga  |beluga[1-5]    | blg
siku    |login[1-2]     | cl
nova    | login         | node, gpu-node

### Navigating files and directories

Shell has commands to:

- inspect
- create
- rename
- delete files and directories

#### Location: print working directory
~~~
pwd
~~~
{: .bash}

#### Change directory
~~~
cd $HOME # change directory to the home directory of the current user
~~~
{: .bash}

#### Inspecting contents
~~~
tree -L 1 / # Show the root directory with the max depth of 1 level
~~~
{: .bash}

#### Important system directories

| Directory | Description|
|/home| home directories of all users |
|/mnt|  temporary mountpoint for regular filesystems  (not removable media)
|/media| intended for mounting removable media devices inserted into the computer
|/cvmfs| directory where all software is installed on CC clusters
/bin| directory that contains executables of the essential commands

#### Downloading data from the Internet
~~~
wget https://github.com/ssvassiliev/LinuxShell21/raw/gh-pages/data/data-shell.tar.gz
~~~
{: .bash}

#### Unpacking archives
~~~
tar -xf data-shell.tar.gz
~~~
{: .bash}

#### Getting information about files and directories
~~~
ls
ls -F          # classify files and display decorations ( / * @ )
ls -a          # show all files
ls --classify
ls /           # list contents of the root directory
~~~
{: .bash}

#### Getting help
~~~
man ls
ls --help
~~~
{: .bash}

#### Navigating manuals and other text files

|Key|Action|
|--|--|
|B|page up|
|Space| page down|
|gg|go to the 1st page|
q|quit|

#### Contents of a different directory
~~~
ls -F /bin
~~~
{: .bash}

#### Changing directory
~~~
cd                  # go home
cd data-shell
cd ..               # go 1 level up
cd data-shell/data
cd ~                # go home
cd -                # go back
~~~
{: .bash}

#### Creating directories and files
~~~
cd ~/data-shell
mkdir thesis                      # create directory ~/data-shell/thesis
cd thesis                         # descend into the directory thesis
touch draft.txt            # create empty file  ~/data-shell/thesis/draft.txt
cd ..                             # return to the ~/data-shell directory
mv thesis/draft.txt thesis/quotes.txt # change the file’s name to quotes.txt
mv thesis/quotes.txt .     # move quotes.txt into the current directory
~~~
{: .bash}

#### Good filenames
- Don't begin the name with '-' because bash will treat all characters after '-' as options
- Avoid spaces, spaces separate command line options and arguments.
- It is safe to use numbers, ".", "_" and "-".

#### Command line text editors
~~~
vi
nano
emacs
~~~
{: .bash}

#### Moving files and directories
~~~
mv source destination
~~~
{: .bash}

#### Copying files and directories
~~~
cp quotes.txt thesis/quotations.txt
cp -r thesis thesis_backup
~~~
{: .bash}

#### Removing files and directories
~~~
rm quotes.txt  # remove the file quotes.txt
rm -r thesis   # remove the directory thesis recursively
~~~
{: .bash}

Deleting is permanent!!

#### What is inside files?
~~~
cat  file    # print file content on screen
head file    # print the first n lines of a file
tail file    # print the last n lines of a file
less file    # scroll through file, one screen at a time
~~~
{: .bash}

#### Combining existing commands to do new things (pipes)
~~~
cd ~/data-shell/molecules
less ethane.pdb
head -n 5 ethane.pdb
head -n 5 ethane.pdb > ethane_lines_1-5.pdb
tail -n 3 ethane_lines_1-5.pdb
head -n 5 ethane.pdb | tail -n 3  # prints atoms 1-3 from ethane.pdb
~~~
{: .bash}

#### Loops
Our goal is to process all molecules with a program numol.
~~~
cd ~/data-shell/molecules
./numol < methane.pdb
./numol < methane.pdb > methane.out       # numol invocation
for mol in *.pdb; do echo $mol; done
for mol in *.pdb; do ./numol < $mol; done
for mol in *.pdb; do ./numol < $mol > $mol.out; done
for mol in *.pdb; do ./numol < $mol > $(basename $mol .pdb).out ; done
~~~
{: .bash}

#### Finding things in files
Our goal is to make a table of the molecular energies sorted in the ascending order.

~~~
grep "The energy is" *.out         # print lines containing search pattern
grep energy *.out | sort -n -k4    # sort numerically using the 4th column
grep energy *.out | sort -n -k4 | sed s/".out:The energy is"//g   # substitution
~~~
{: .bash}

#### Finding files
~~~
cd ~/data-shell
find . -name *.out
find . -name *.dat
find . -name me*.pdb
find . -name *.pdb -maxdepth 2
find . -type d
~~~
{: .bash}

### Filesystems and quota

|Filesystem| Quota| Intended usage |
|----------|------|----------|
home|user|source code, small parameter files and job scripts|
projects|group| research data|
scratch|user |	intensive i/o operations, temporary files
nearline|user|	tape storage, backup and storage of large files

`home` and `projects` directories are backed up daily.

`scratch` is purged every month (data older than 60 days is deleted).

#### Your storage space limits
~~~
quota
~~~
{: .bash}

~~~
[svassili@gra-login3 ~]$ quota
                            Description                Space           # of files
                  /home (user svassili)               39G/53G            160k/500k
                /scratch (user svassili)            8923M/20T            12k/1000k
               /project (group svassili)              0/2048k               0/500k
           /project (group def-svassili)            12G/1000G             51k/500k
           /project (group def-bcrawfor)            17G/1000G            1279/500k
~~~
{: .output}

/project (group svassili) should not have any files!

### Running globally-installed software
~~~
module spider # show all available modules
module spider octave  # show what versions are available
module spider octave/5.2.0  # show how to load octave/5.2.0
module load StdEnv/2020 octave  # load default octave
module unload octave  # Unload module
module purge # Reset to default modules
module list	  #	List loaded modules
module avail	#	List compatible with currently loaded modules
module key   #  Search modules by keyword
~~~
{: .bash}

#### Where is the installed software?
~~~
module load nixpkgs/16.09 gcc/5.4.0 openmpi/2.1.1 amber
env | grep EBROOTAMBER # this is where AMBER is installed
ls $EBROOTAMBER
~~~
{: .bash}


### Transferring files in/out and between clusters

~~~
cd
scp -r data-shell svassili@cedar.computecanada.ca:scratch/ # many small files, slow!
ssh cedar "rm -r scratch/data-shell"        # delete data-shell from cedar
tar -cfz data-shell-test.tar data-shell     # make compressed archive
scp data-shell-test.tar svassili@cedar.computecanada.ca:scratch # send archive
scp -r cedar.computecanada.ca:scratch/data-shell-test.tar \
beluga.computecanada.ca:scratch/  # Copy from cedar to beluga
ssh cedar.computecanada.ca "cd scratch; \
tar -xf data-shell-test.tar"   # unpack archive
~~~
{: .bash}
- Username can be omitted if it is the same on both systems
- Passwords are not necessary if ssh keys are installed

### Setting up passwordless access.
#### Create ssh key pair.
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

#### Copy your public key to the remote computer
~~~
ssh-copy-id -i ~/.ssh/id_rsa someuser@siku.ace-net.ca:
~~~
{: .bash}

Permissions of the file authorized_keys are important! Passwordless access will only work if the file authorized_keys is accessible only for the owner.

MobaXterm users can follow [these instructions](https://docs.computecanada.ca/wiki/Generating_SSH_keys_in_Windows/en) for installations of ssh keys.


{% include links.md %}
