---
title: "Job Scheduling, using Python and Jupyter with SLURM "
teaching: 90
exercises: 0
questions:
- "How to submit jobs"
- "How to install modules in Python"
- "How to use Jupyter notebooks"
objectives:
- "Learn how to use virtual environments"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

#### JupyterHubs on Beluga and Siku
[Beluga](https://jupyterhub.beluga.calculcanada.ca/hub/login)
[Siku](https://services.siku.ace-net.ca/jupyter/hub/spawn)

#### Using Virtual Environments in JupyterHub

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
