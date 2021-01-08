---
title: "Starting VMD, Loading Structure Files and Interacting with Molecules"
teaching: 0
exercises: 0
questions:
- "Key question (FIXME)"
objectives:
- "First learning objective. (FIXME)"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

### Installation
[Download VMD](https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD) and run the installer.

If you see a warning about running or installing software from an unknown publisher, you can click the **'More'** item, and use the **'Run Anyway'** button to allow the VMD installer to continue.

### Starting VMD
Double click on VMD icon. Three windows will open: **'VMD OpenGL Display**', **'VMD Main'**, and **'VMD'** command window. Do not close any of them.

### Using VMD on Compute Canada systems
To use VMD on CC systems you need to establish graphical connenction. Currently thare are 2 options: VNC and JupyterHub

#### Visualization nodes on Graham
Graham has dedicated visualization node **gra-vdi.computecanada.ca**. To start using it you need to install TigerVNC Viewer. RealVNC or any other client will not work.
- Direct connection from your laptop with TigerVNC Viewer.
- Visualization node is shared between all logged in users, may be lagging depending on the workload.

#### WSL
https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10

#### JupyterHub on Beluga.
[Beluga-JupyterHub](https://jupyterhub.beluga.calculcanada.ca/hub/login)
1. Login with your CC credentials
2. Spin up a server
3. Choose **'Desktop'** in JupyterLab Launcher

#### Connecting to a compute node.
It is also possible to connect to a remote VNC desktop running on any compute node. For this you need to start VNC server on a compute node and establish ssh tunnel from your local computer to the node.

Exercise

- On Cedar submit interactive job

~~~
[svassili@cedar5 scratch]$ salloc --mem-per-cpu=1000 --time=3:0:0 --account=def-somePI
~~~
{: .source}
- Once allocation is granted start VNC server

~~~
[svassili@cdr774 scratch]$ vncserver

New 'cdr774.int.cedar.computecanada.ca:1 (svassili)' desktop is cdr774.int.cedar.computecanada.ca:1
~~~
{: .source}
Note the name of compute node (cdr774) and number of VNC session (:1). The base port number of VNC server is 5900. Port number to connect to vnc session is 5900 + session number = 5901 in this example. Do not close this terminal.
- Open ssh tunnel from your local computer to cdr774 (this command is executed on your LOCAL computer)

~~~
darkstar:~$ ssh cedar -L 5901:cdr774:5901
~~~
{: .source}

It will link port 5901 on cdr774 with port 5901 on your laptop.  Format of the command is LocalPort:RemoteHost:RemotePort. Once connection is established you can connect VNC viewer on your local computer to localhost:5901.


### Opening PDB files
We will be using X-ray crystallographic structure of human hemoglobin, PDB ID 1SI4.

####  Downloading files from Protein Data Bank using PDB Tool
VMD can directly query PDB database.

On the **'VMD Main'** window menu select **'File' > 'Data' > 'PDB Database Query'**. This will open the **'VMD PDB Tool'**.

Enter PDB ID (1SI4) and click **'Load into new molecule in VMD'**.

#### Opening a PDB file saved in your computer.
On the **'VMD Main'** window menu select **'File' > 'New Molecule'**. This will
open the **'Molecule File Browser'**. Choose a molecule file.

The molecule will be loaded in VMD and displayed in the OpenGL window with lines.

### Interacting with molecules

#### Obtaining good views for molecules

| Action     | Hot keys  | MAC touch pad | Windows touch pad |
------------:|:---------:|:-------------:|---------:
| Rotate     |     R     |   click, hold and move | click and hold |
| Zoom       |     S     |   click, hold and move left/right |  |
| Translate  |     T     | click, hold and move |
| Reset View |     =     | |
| Set Center |     c     | |

### Loading separate parameter and structure files.

#### References
[VMD Introductory tutorial](https://doi.org/10.1002/0471250953.bi0507s24)

{% include links.md %}
