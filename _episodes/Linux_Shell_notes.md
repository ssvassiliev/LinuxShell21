
### SETUP
#### Installing command line tools
Windows:

The best option is to install WSL.
1. Enable the "Windows Subsystem for Linux".
- Type "turn windows features on or off" on the search bar.
- Check "Windows Subsystem for Linux".
- Reboot.
2. Install [Ubuntu](https://www.microsoft.com/en-ca/p/ubuntu-2004-lts/9n6svws3rx71?rtc=1&activetab=pivot:overviewtab)
3. Install [Windows Terminal](https://www.microsoft.com/en-ca/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) (optional, but highly recommended).  This terminal app is designed to give the best possible experience with command line.

If you have an older Windows and WSL installation does not work for you, install [MobaXterm](https://mobaxterm.mobatek.net/)
#### Setting up graphical connection

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

#### Useful links
Compute Canada [VNC documentation](https://docs.computecanada.ca/wiki/VNC)

Before we start I want to make sure if all of Windows users have some version of command line shell installed (WSL or MobaXterm).  And I would like to know what platform most of you are using. So please check yes if you are using Windows/WSL.

## Introduction
The most obvious reason to learn Unix shell is because it is used on HPC systems including CC. But this is not the only reason. There are other important reasons for learning the command line.

Most of the applications you use on a computer these days have a graphical user interface. When GUI is used the application runs in one or more windows on the screen, and there are controls such as menus and buttons that you can manipulate with a mouse.

The nice thing about gui is that it provides visual representations of available functions, you do not need to know or understand how these functions work. You simply select a button or an icon to make a program do something.  Thus, GUI is easy to use because you interact with compouter via an intuitive interface and receiving immediate visual feedback. However, only a limited set of functions can be included in a GUI without making it cluttered, sluggich and hard to navigate.

Many very useful applications don't have a graphical interface. Instead, you run them from a text-based interface called a command shell. Working on a command line interface is often more elegant, fast and what is most important is that you know exactly what you are executing.

The learning curve on Linux shell if you're coming from a complete Windows background is steep and at first glance, working with CLI might seem difficult and old fashioned to you.  But you get something out of it if you do learn it.

When I was learning to use scripting I would always try to estimate time that I would need to do some job in a traditional manual way (word copy/paste, moving files and creating directories,  .. etc) and compare it to the time of writing a script to automate this task. And what turned out to be is that in most cases script writing did not take longer than the manual job. However the fact that that I don't need to think or learn by doing a job in traditional way often made me to chose this way, I gueess it's in our nature to chose the way of a least resistance. But very often I would make a mistake or need to change something. And in this case the whole thing would need to be redone from scratch and then I wished I would not even try to do the task manually because it was obvious that writing a script would save me alot of time. And even more importantly I would have learned something new and useful and next time I would solve a simlar problem faster.

### What is a shell?
A Shell is an interface to the Unix system. It is a simple interactive computer programming environment a.k.a REPL. REPL states for Read Evaluate Print Loop. It reads input from you and executes programs based on that input. When a program finishes executing, it displays that program's output and comletes the loop by returning to the state waiting for another input.

When shell is ready and waiting for your commands you are presented with a prompt.

The shell typically uses $ as the prompt, but may use a different symbol.

Let's try the first command:

`date`

If you make a typo and the command you typed does not exist shell will respond with "command not found" message:

`data`

## Connecting to CC clusters

At some point of your work all of you will be using CC, or at least are thinking of exploring this possibilty.  Let's connect to one on the Compute Canada clusters and start using it.

With Compute Canada account you can connect to any of the following systems:
- beluga.computecanada.ca
- cedar.computecanada.ca
- graham.computecanada.ca
- siku.ace-net.ca
- nova-v.ace-net.training

If you are using Mac, Linux or WSL open a terminal window and type:

`ssh your_username@siku.ace-net.ca`

If you use MobaXterm, create a new SSH session.

### Login nodes vs compute nodes
When you open ssh session you will be logged in to one of the LOGIN nodes.

How do you know if you are on a login node?
System|Login node prompt |Compute node prompt|
|------|-----------|-------|
graham|gra-login[1-3] |gra#
cedar|cedar[1-5]| cdr#
beluga|beluga[1-5]| blg#
siku |login[1-2] |cl#

All clusters have dedicated login nodes intended to be used as gateways and for such tasks as batch job submission, code editing and compillation, running short test jobs. Users can connect to the systems and submit jobs only from the login nodes.  We will talk about job submission later in the second session. For now, I only want to inform you that running computationally intensive programs on a login node will negatively impact all logged in users and users who are trying to connect and be careful about with testing multithreaded prorams on login nodes. Such programs may use all available CPUs unless you specify the number of CPUs to use. When login nodes are overloaded all users will have delays connecting to a cluster and/or submitting jobs. If you want to run a progam that will use more than 4-8 CPUs or more than 4 GB of RAM please allocate these resources first.

Compute nodes are managed. You can not simply login to a compute node. You need to reserve resources first by allocating an interactive session or submitting a batch job to the queue. Resource manager (scheduler) will allocate resources (a whole node or a certain number of CPUs with associated memory) based on your request and then access to the allocated compute node will be granted. Sometimes it is useful to ssh to a node running your job, for example it you want to find out how efficiently your code is using GPU. We will learn more about job scheduling on Friday.

## How to navigate the filesystem

The file system controls how data is stored and retrieved. Without a file system, data placed in a storage medium would be one large body of data with no way to tell where one piece of data stops and the next begins.

Filesystem organizes all data into files and dirs and manages them. Directories are also known as folders because they can be thought of as folders in which files are kept in a sort of physical desktop analogy.

Shell has commands to:

- inspect
- create
- rename
- delete files and directories

**Where are we?**

So you are logged in to one of the clusters. The first thing you want to do is to find out where in the filesystem are you.

When you log in to a system you are placed in the home directory. Where is the home directory in the filesystem?

[svassili@gra-login3 ~]$ pwd
Print path to the current directory

`/home/svassili`

Variations of the home:

OS | home
|---|---
Win |C:\Documents and Settings\someuser
WSL |
Linux|/home/someuser
OsX|/Users/someuser

Note that the path starts with /. '/' is a special symbol, it means the top level of the filesystem. We call it "root directory".

Why root?
In some non-Linux PC operating systems, if there are multiple physical hard drives or multiple partitions, each disk or partition is assigned a drive letter. It is necessary to know on which hard drive a file or program is located, such as C: or D:. Then you issue the drive letter as a command, D:, for example, to change to the D: drive, and then you use the cd command to change to the correct directory to locate the desired file. Each hard drive has its own separate and complete directory tree.

The Linux filesystem unifies all physical hard drives and partitions into a single hierarchical (or tree-like) directory structure. It all starts at the top – the root (/) directory. All other directories and their subdirectories are located under the single Linux root directory. This means that there is only one single directory tree in which to search for files and programs.

Let's have a look at the directory structure of one of CC systems, cedar. To see tree-like filesystem structure we can use the command 'tree'. It is a recursive directory listing program that produces a depth indented listing of files.

In Ubuntu Linux provided in WSL the tree command is not installed by default, but when you try to use it the system will understand that you are trying to use the command available in standard repository and prompt you how to install it.

`tree -L 1 /`

Immediately below the root level directory there are are several subdirectories, most of them contain system files.

*/home*  directory contains home directories of all users
*/mnt*   a temporary mountpoint for regular filesystems  (not removable media)
*/media* is intended for mounting removable media devices inserted into the computer
*/cvmfs* is the directory where all software is installed on CC clusters
*/bin*   is the directory that contains executables of the essential commands

**Inspecting contents**
Let's recap.
- By default a new shell opens in your home directory.
- To verfy where you are in the filesystem you can use the command pwd.

- To return to the home directory use cd "change directory" w/o arguments

`cd`
`pwd`

### Let's get some data from outside:

To download file from internet you can copy the link to the file you want to download from a webpage and use it as an agument for wget command:

`wget https://github.com/ssvassiliev/LinuxShell21/raw/gh-pages/data/data-shell.tar.gz`


.tar.gz is a standard Unix compressed archive format. You can unpack it with the "tar" command:

`tar -xf data-shell.tar.gz`

Next, we will use the ls command (short for list) to get information about files and directories.

The syntax of the ls command is

ls [OPTIONS] [FILE1 FILE2 ...]

- Square brackets indicate optional arguments.

When no files are given ls will list the contents of the directory you are currently in.

`ls`
`ls -F`

will classify contents into
* - executables
/ - directories
@ - links
and add decorations.

## General syntax of a shell command:

Thus you can controls what a command does with
options and arguments.

This syntax model applies to all shell commands
**[command options arguments]**

Arguments usually come after options. A common example of an argument is a (list of) files or directories for the command to work on.

How commands determine what text on a command line is an option and what is argument?

Options are preceded by a single - or double -- minus characters.
The convention is that a character that follows a single - represents an option. Command can take more than one option:

`ls -F -a`
or even shorter
`ls -Fa`
also acceptable

Double -- used to indicate a whole word option:

`ls -F`  or
`ls --classify`

Contents of the root directory:

`ls /`

Contents of the current working directory:

`ls`

Unix commands are very flexible, their behaviour can be tuned for your needs by turning on/off different options.

### How do you get information about available options?

There are 2 ways to get help:

`man ls`
or
`ls --help`

man states for manual, manuals need to be installed for this command to work. in some environments they may not be installed. if you don't have manual try --help option.

When a command is used with --help option, it will print a short version of the manual and exit.

How to navigate manuals?

`man ls`

B - page up
space - page down
/ - search; try /-F
gg - go to the first page
q -quit


#### Contents of a different directory:
You can see contents of a different directory without changing into it:

`ls -F /bin`

See the familiar ls and pwd files? This is the place in the filesystem where commands are located. Commands are just executable files.

### Changing location
For changing location there is the `cd`, change directory command

As all commands do, `cd` has its default arguments. What happens if we type `cd`?

`cd`

*Without an argument "cd" returns to the home directory*

Now let's look what is inside the data-shell:

`ls`
`ls -F data-shell`

#### Moving down the directory tree
Move into the ~/data-shell/data:

`ls`
`cd data-shell`
`cd data`

We are now in ~/data-shell/data

`pwd`
`ls -F`

How to move back, up the tree into data-shell?

`cd data-shell` ?

We don't see it `ls` can only see subdirectories

#### Moving up
`cd ..`

* .. is the parent directory*

`pwd`

".." directory does not show up when we use `ls -F`

*All files and folders starting with "." are by default hidden*

To show hidden files add -a option:

`ls -F -a` or `ls -Fa`

When used as a command argument "." means “the current working directory”

*Files and directorues starting with "." usually contain configuration settings for different programs*

At some point you may need to customize your working environment. For example initialize applications, add some directories to the executable search PATH or LIBRARY search PATH.

Personal initialization files for configuring the user shell environment can be found in your home directory in 2 files:

.bashrc
.bash_profle

Why 2 files?
Commands from .bash_profile are executed once when you log in to system while from .bashrc are executed every time when a new shell is started.

Let's make sure we are in the home drectory:

`cd`
`pwd`

and go from the home directory to the data in one step:

`cd data-shell/data`

In this command we used the relative path.
*The relative path*, is the path from the current location.

*The absolute path*, is the entire path from the root directory, it is the path that is printed by the pwd command.

`/home/svassili/data-shell/data`

The absolute path is valid from any point of a filesystem.

*Two more shortcuts:*

"~" and "-"
"~" - the home directory
"-" - the previous directory
`cd /usr/bin`
`cd -`

### Shell auto completion.

Let's see what is inside the north-pacific-gyre. Perhaps you have noticed that I'm not typing the whole directory names. To descend into the north-pacific-gyre directory you don't have to type the whole directory name. Start typing ' ls nor' and press 'tab'

`ls nor`

the shell will autonmatically complete the directory name since this is the only possible completion.

Press tab again and the bash will add 2012-07-03/ to the command, since it’s the only possible completion again.

# How to Work With Files and Directories

## Creating directories
Let's go back to our data-shell directory

`cd ~/data-shell`

Start with checking where you are

`pwd`

and what you already have

`ls -F`

### Create a directory
`mkdir thesis`

### Good names for files and directories
- Don't begin the name with '-' because bash will treat all characters after '-' as options
`mkdir -work`
- Avoid spaces. Spaces separate command line options and arguments.
`mkdir my thesis`
`mkdir "my thesis"`

- It is safe to use numbers, ".", "_" and "-".

### Create a text file
What is in the directory thesis?
`ls -F thesis`

It is empty

Let's create a file in it:
`cd thesis`
ls
`nano draft.txt`

Type a few lines into it.

So many books,
so little time

Save it.
Exit editor.

Other way to create an empty file:
If for whatever reason you need to create an empty file. Some programs may need such empty files to exist so that they can write output into them. You can use the command

`touch newfile`

Touch is normally used to update access time of a file, when the file does not exist it will create an empty file.

Files can be also created by any text editor. Other common editors for Linux command line: emacs, vi.

Filename extensions - 3 character part of a filename that comes after . Extensions in Linux are used ONLY for convenience so that you could see what type of data is in a file. Most programs don't care about filename extensions.

## Moving files and directories
Let's return to the data-shell directory

`cd ~/data-shell/`

In the `thesis` directory we have the file `draft.txt`

 let’s change the file’s name to quotes.txt

`mv thesis/draft.txt thesis/quotes.txt`

The first arg tells the `mv` command what we are moving, the second where it has to go

`ls thesis`

`draft.txt` is gone, and there is a new file `quotes.txt`

- Be careful not to overwrite something important! mv will not ask for confirmation!
- You can use "mv -i", then mv  will ask you for confirmation before overwriting.
- You can move also directories

Let’s move `quotes.txt` into the current working directory

`mv thesis/quotes.txt .`

`ls thesis`

`ls quotes.txt`

*Exercise: Moving Files to a new folder*

## Copying files and directories
`cd ~/data-shell/`

Copy file:
`cp quotes.txt thesis/quotations.txt`

Copy works like mv, but the original file will not be deleted after creation of a copy.

`ls quotes.txt thesis/quotations.txt`

We can copy a directory using -r option:

`cp -r thesis thesis_backup`

`ls thesis thesis_backup`

## Removing files and directories
`cd ~/data-shell/`

`rm quotes.txt`

`ls quotes.txt`

Deleting is permanent, consider "rm -i"

Deleting Directories

`rm thesis`
`rm -r thesis`

## Operations with multiple files and directories
`cd ~/data-shell/data`
Someties we need to copy or move several files or directories. This can be done in one command by providing a list of individual filenames, or specifying a naming pattern using wildcards.

### Copy with Multiple Filenames
- When multiple filenames are given, the last argument should be a directory

`mkdir backup`

`cp amino-acids.txt animals.txt backup/`

### Using wildcards for accessing multiple files at once
\* is a wildcard, which matches zero or more characters

`ls pdb/*.pdb`

`ls pdb/p*.pdb`

? is a wildcard matching exactly one character

`ls pdb/?ethane.pdb`

`ls pdb/*ethane.pdb`

wildcards can be combined

`ls pdb/???ane.pdb`

Shell expands the wildcard to create a list of matching filenames before running the command

### What is inside files?

`cat`  file print file content on screen
`head` file   print the first n lines of a file
`tail` file   print the last n lines of a file
`less` file   scroll through file, one screen at a time

### How can we combine existing commands to do new things?

Now that we know a few basic commands, we can finally look at the shell’s most powerful feature: the ease with which it lets us combine existing programs in new ways. We’ll start with a directory called molecules

`cd ~/data-shell/molecules`

Imagine that you need to extract the first 3 atoms from a pdb file:

`less ethane.pdb`

The first 2 lines are header lines, so you need lines 3-5. One way to do it is first to print out the first 5 lines with the command `head`:

`head -n 5 ethane.pdb`

And then print 3 last lines from the output of this command.

By default head and other commands print output on the standard output device which is terminal, but we could redirect the output into a file:

`head -n 5 ethane.pdb > ethane_lines_1-5.pdb`

and then use this file as an input to `tail`:

`tail -n 3 ethane_lines_1-5.pdb`

But there is a better way. Most Linux commands can take output of another command as an input. This means that we can send the output of the command `head` into the command `tail` and skip creation of an intermediary file:

`head -n 5 ethane.pdb | tail -n 3`

This idea of linking programs together is why Unix has been so successful. Instead of creating complex programs that try to do many different things, Unix programmers focus on creating lots of simple tools that each do one job well, and that work well with each other.

This programming model is called “pipes and filters”. We’ve already seen pipes; a filter is a program like head or tail that transforms a stream of input into a stream of output.

Almost all of the standard Unix tools can work this way: unless told to do otherwise, they read from standard input, do something with what they’ve read, and write to standard output.


### Loops

Loops allow us to repeat a command or set of commands for each item in a list. As such they are key to productivity improvements through automation.

We will use pdb files with molecular structures to construct a loop. The goal is to process a set of molecules with a program numol to compute energy. (This is not a real comp chem program, it is a script that counts a number of atom lines in standard input and prints it out as a negative nuber). The example usage of the program is:

`./numol < methane.pdb`
`./numol < methane.pdb > methane.out`

Let's begin writing a simple loop

`for mol in cubane.pdb  ethane.pdb  methane.pdb`
`do`
  `echo $mol`
`done`

Using history - press up arrow to retrieve the last command:

A better way to construct a list of files:

`for mol in *.pdb; do echo $mol; done`

Now add a command that will do something useful.

`for mol in *.pdb; do ./numol < $mol; done`

The `numol` prints output on screen, we want to save the output for each of the processed molecules in a separate file. To do this we need to construct the appropriate filename at each iterration of the loop. One way to it is simply to append `.out` to a filename:

 `for mol in *.pdb; do ./numol < $mol > $mol.out; done`

Now we have output saved in the files named `methane.pdb.out` etc
This works, but the output filenames could be better, we could replace `.pdb` with `.out` instead of simply adding `.out`. We can do it with the command `basename`:

We want to shell to execute the command `basename ethane.pdb .pdb` to strip .pdb from the filename and then print the output of this command on screen.

How do we do this?

`echo basename ethane.pdb .pdb`

Will not work, it will print `basename ethane.pdb .pdb` instead of running the `basename` command first!

To achieve our goal we can use the shell construct `$(command)`. This syntax means `the result of a command`. In other words the shell will expand the `$(command)` construct to the value returned by a `command`. In our case the command is `basename ethane.pdb .pdb`, so we write

`echo $(basename ethane.pdb .pdb)`

Now all we need to do is to append the suffix `.out` to the filename:

`echo $(basename ethane.pdb .pdb).out`

Let's plug this command into our loop:

`for mol in *.pdb; do ./numol < $mol > $(basename $mol .pdb).out ; done`

`rm *.out`

and repeat.

So we got our processing loop working the way we want it to work. Our fake computational chemistry program completes in no time, but the real one could run for many hours. We can take advantage of the available computer clusters and process each of the molecules on a separate CPU in parallel. This can be done by a simple modulfication of the loop to submit processing jobs to a scheduler instead of running `numol` directly. We will learn how to do it in the next session on Friday.

### Finding things in files

Let's start processing the results of our `numol` calculations. Our goal is to make a table of the molecular energies sorted in the ascending order.

Let's have a look at one of the output files:

`cat methane.out`

The value of the energy is printer inthe line `The energy is -5.00`
First we need to find this line in an output file. We can find things in files using the `grep` "general regular expression print".

Grep is a very powerful and widely used Unix utility. Similar to the term "Googling" programmer say "Grepping".

`grep "The energy is" methane.out`

Find the line containing the string "The energy is" in the file methane.out and print it on stdout.

*Regular expressions* are sequences of character that define search patterns. Regular expressions are used in search engines, search and replace dialogs of word processors and text editors, in text processing utilities such as sed and AWK ,etc. Many programming languages provide regex capabilities. Learning regular expressions is very useful! .. But that's outside the scope of this lesson.

Find energy in all output files:
`grep "The energy is" *.out`

Sort energies in the ascending order:

`grep energy *.out | sort`

By defaults sorts alphabetically. We want to sort numerically by the value in the 4th column:

 `grep energy *.out | sort -n -k4`

 Still not happy, we don't want `.out:The energy is` in the output. NP, apply another filter, stream editor `sed`

 `grep energy *.out | sort -n -k4 | sed s/".out:The energy is"//g`

What command do I need to add to the line to save the results in the file results.txt?

#### Finding files
~~~
cd ~/data-shell
find . -name *.out
find . -name *.dat
find . -name me*.pdb
find . -name *.pdb -maxdepth 2
find . -type d
~~~

### Transferring data in and out of the CC systems

scp
rsync
globus

winscp, bit

### Shell Environment Variables

HOME
PATH
SECONDS
USER
SCRATCH

##### Variables set by loading modules.

EBROOT

##### Variables set by SLURM.

SLURM VARIABLES

SLURM_JOB_NUM_NODES
SLURM_TASKS_PER_NODE
SLURM_JOB_CPUS_PER_NODE
SLURM_NODELIST
SLURM_TMPDIR

### Filesystems and quota

|Filesystem| Quota| Intended usage |
|----------|------|----------|
home|user|source code, small parameter files and job scripts|
projects|group| research data|
scratch|user |	temporary files, intensive i/o operations
nearline|user|	tape storage for backups and large files

`home` and `projects` directories are backed up daily.

`scratch` is purged every month (data older than 60 days is deleted).


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

MobaXterm users can follow [these instructions](https://docs.computecanada.ca/wiki/Generating_SSH_keys_in_Windows/en) for installations of ssh keys.




### We Keep software separated from OS.

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



#### Connecting graphically to a compute node.

#### No direct acces to compute nodes. SSH tunneling is tthe way to go. It is used for graphical connections as well as for connecting to jupyter notebook and tensorboard.


It is also possible to connect to a remote VNC desktop running on any compute node. For this you need to start VNC server on a compute node and establish ssh tunnel from your local computer to the node.

Let's first complete X-server setup for WSL:
1. Configure X-sever application.
- run the application. the default settings are fine.
- when prompted save configuration settings
- to start service automatically copy the configuration file into the "Startup" folder. It can be accessed by pressing Windows + r and then typing "shell:startup".
2. Add the following lines into the file ~/.bashrc

~~~
DISPLAY=:0.
~~~
{: .file-content}

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

You can use the script Launch_VNC.sh located in data-shell directory to connect to a compute node via VNC.

Example plot matlab
~~~
tx = ty = linspace (-8, 8, 41)';
[xx, yy] = meshgrid (tx, ty);
r = sqrt (xx .^ 2 + yy .^ 2) + eps;
tz = sin (r) ./ r;
mesh (tx, ty, tz);
~~~
{: .matlab}

### Tensorflow
Check what tensorflow versions are available

~~~
avail_wheels tensorflow* --all-pythons --all-versions
~~~
{: .bash}

Create a virtual environment and install tensorflow-gpu:

~~~
module load StdEnv/2020 python
virtualenv ~/env382-tf
source ~/env382-tf/bin/activate
pip install tensorflow-gpu
~~~
{: .bash}

Allocate GPU, load modules and activate the environment

~~~
salloc -c2 --mem-per-cpu=4000 --gres=gpu:1
module load StdEnv/2020 python cudacore/.11.0.2 cudnn
source ~/env382-tf/bin/activate
python
~~~
{: .bash}

TF cuda test

~~~
import tensorflow as tf
node1 = tf.constant(3.0)
node2 = tf.constant(4.0)
print(node1, node2)
print(node1 + node2)
~~~
{: .python}

TF/Keras test:

~~~
import tensorflow as tf
mnist = tf.keras.datasets.mnist
(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0

model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(28, 28)),
  tf.keras.layers.Dense(128, activation='relu'),
  tf.keras.layers.Dropout(0.2),
  tf.keras.layers.Dense(10)
])
predictions = model(x_train[:1]).numpy()
print(predictions)
loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
print(loss_fn(y_train[:1], predictions).numpy())
model.compile(optimizer='adam',
              loss=loss_fn,
              metrics=['accuracy'])
model.fit(x_train, y_train, epochs=5)
model.evaluate(x_test,  y_test, verbose=2)
~~~
{: .python}

Submission script:
~~~
#!/bin/bash
#SBATCH -c1 --mem-per-cpu=4000 --gres=gpu:1 --time=1:0:0

module load StdEnv/2020 python cudacore/.11.0.2 cudnn
source ~/env382-tf/bin/activate
SECONDS=0
python tfTest.py
echo Elapsed $SECONDS seconds
~~~
{: .file-content}

[Machine learning tutorial](
https://docs.computecanada.ca/wiki/Tutoriel_Apprentissage_machine/en)


{% include links.md %}
