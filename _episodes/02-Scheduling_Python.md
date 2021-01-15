---
title: "Job Scheduling, using Python and Jupyter with SLURM "
teaching: 90
exercises: 0
questions:
- "How to submit jobs"
- "How to install modules in Python"
- "How to launch Jupyter notebooks on clusters"
- "How to add virtual environment to Jupyter notebook"
objectives:
- "Learn how to install software on clusters"
- "Learn how to create an use virtual environments"
- "Learm how to launch Jupyter on clusters"
keypoints:
- "First key point. Brief Answer to questions. (FIXME)"
---

### Using Compute Canada software stack

 Software modules are installed in a user's environment dynamically when they are needed. This is done using the `module` command.

~~~
module spider # show all available modules
module spider octave  # show what versions are available
module spider octave/5.2.0  # show how to load octave/5.2.0
module load StdEnv/2020 octave  # load default octave module
module unload octave  # Unload module
module purge # Reset to default modules
module list	  #	List loaded modules
module avail	#	List compatible with currently loaded modules
module key   #  Search modules by keyword
~~~
{: .bash}

#### Where is the installed software located?
~~~
module load StdEnv/2020  gcc/9.3.0  openmpi/4.0.3 ambertools
env | grep EBROOTAMBERTOOLS # this is where the ambertools module is installed
ls $EBROOTAMBERTOOLS
~~~
{: .bash}

### Standard Environment modules
The combinations of specific compiler and MPI modules are grouped in modules named StdEnv. When you login, one of these modules will be loaded by default. Standard environments are used by our team to compile software.

Currently, there are three versions of StdEnv:
~~~
module spider StdEnv
~~~
{: .bash}

The default environments are different for different clusters.
~~~
ssh graham module list
~~~
{: .bash}

If you compile your own code, and decide to change the environment, or move the binary to a system with different you will need to recompile it preferrably using newest version of the standard environment.

### Job Scheduling

The typical cluster is a finite resource that is shared by many users.
In the process of getting work done, users compete for a cluster's nodes, cores, memory, network, etc. In order to fairly and efficiently utilize a cluster, a special software system (workload manager) is employed to manage how work is accomplished.

Workload manager, aka job scheduler evaluates, prioritize, schedule and run jobs. It also provides accounting and reporting for jobs and machine resources. We use SLURM workload manager on our clusters.

#### How to interact with SLURM

There are three job submission commands:

~~~
salloc
srun
sbatch
~~~
{: .bash}

All of these commands accept the same keywords specifying what resouces you want to allocate and for how long.

The salloc and srun commands are used to allocate resources for interactive sessions.

#### The salloc command
Let's try basic salloc comand
~~~
salloc
~~~
{: .bash}
~~~
[user29@login1 ~]$ salloc
salloc: Granted job allocation 41
salloc: Waiting for resource configuration
salloc: Nodes node10 are ready for job
[user29@node10 ~]$
~~~
{: .output}

Without any options salloc allocates 1 node, 1 task, 1 cpu per task, and 256M memory for 1 hour.

`sq`   prints the status of your jobs
`seff` prints info about efficiency of a CPU job

What is a task? Task refers to an MPI process.  The `ntasks` keyword specifies how many MPI processes is available to a program.

How to change the defaults?
~~~
salloc -c2                   # 2 cores
salloc --cpus-per-task=2     # 2 cores
salloc -c2 --nodes=2         # 2 nodes, 2 cores in each node  (4 total)
salloc -c2 --ntasks=2        # 2 MPI tasks, 2 cores for each  task (4 total)
salloc --nodes=2 --ntasks=2  # 2 tasks in nodes  (2 total)
~~~
{: .bash}

These are options for changing memory.
~~~
--mem-per-cpu=4000    # memory per core
--mem=4000            # total memory
--mem=0               # if whole node is requested, reserve all memory
~~~
{: .bash}
GPU memory can not be specified, the whole GPU memory is always reserved.
Recommended maximum `mem-per-cpu` is 4000. If you ask for 1 CPU and `mem-per-cpu=5000`, your account will be "billed" for 2 CPUs.

Job time:
~~~
--time=d-h:m:s
  --time=h:m:s
    --time=m:s
    --time=m
~~~
{: .bash}

GPUs
~~~
--gres=gpu:1  # 1 GPU
--gres=gpu:v100:1 --partition=all_gpus # 1 GPU on Siku
~~~
{: .bash}

There are slightly different ways to request a specific type of GPUs on different clusters.

#### The srun command
The srun allocates resources, runs a command and exits. It does not open an interactive shell.

Srun can be used inside of submission scripts, or in the interactive shell opened with `salloc`. In this case it does not allocate resources, but inherits the resources allocated by `sbatch` or `salloc`. When used this way `srun` takes care of running MPI tasks on already allocated resources.

Try:
~~~
srun hostname
srun --ntasks=10 hostname
~~~
{: .bash}

Allocate 4 tasks and then run `srun`:
~~~
salloc --ntasks=4
...
srun hostname
~~~
{: .bash}

If used with serial program srun will run it on each of the allocated CPUs.


#### Submitting batch jobs
File submit.sh
~~~
#!/bin/bash
#SBATCH --ntasks=4
srun hostname
~~~
{: .bash}


### Installing Jupyter

#### Install a virtual environment
~~~
module load StdEnv/2020 python
virtualenv env-382-jn
~~~

#### Install a kernel for Jupyter
~~~
module load StdEnv/2020 python
source env-382-jn/bin/activate
pip install jupyter ipykernel
python -m ipykernel install --user --name=env-382-jn
~~~
{: .bash}

#### Launch Jupyter notebook server

- Allocate resources:

~~~
salloc --mem-per-cpu=2000 --time=1:0:0
~~~
{: .bash}
~~~
salloc: Granted job allocation 28
salloc: Waiting for resource configuration
salloc: Nodes node10 are ready for job
[user29@node10 ~]$
~~~
{:.output}
 Note the node where notebook server will be running (node10 in this example).

- Start notebook server

~~~
module load StdEnv/2020 python
source ~/env-382-jn/bin/activate
unset XDG_RUNTIME_DIR
jupyter notebook --ip $(hostname -f) --no-browser
~~~
{: .bash}

~~~
...
To access the notebook, open this file in a browser:
    file:///home/user29/.local/share/jupyter/runtime/nbserver-6838-open.html
Or copy and paste one of these URLs:
    http://node10.int.nova.ace-net.training:8888/?token=316765c68b0dc57ac07301ee1d7dcd1d15622db0d4a53aed
 or http://127.0.0.1:8888/?token=316765c68b0dc57ac07301ee1d7dcd1d15622db0d4a53aed
~~~
{: .output}


#### Connecting to notebook server

The message in the example above informs that notebook server is listening at node10, port 8888. Compute nodes cannot be accessed directly from the Internet, but we can connect to the login node, and the login node can connect to node10. Thus, connection to a compute node should be also possible. How do we connect to node10 at port 8888? We can instruct ssh client program to map port 8888 of node10 to our local computer. This type of connection is called "ssh tunneling" or "ssh port forwarding". Ssh tunneling allows transporting networking data between computers over an encrypted SSH connection.

Open ANOTHER terminal tab or window and run the command:
~~~
ssh user29@nova.ace-net.training -L localhost:8888:node10:8888
~~~
{: .bash}
~~~
darkstar:~ svassili$ ssh user29@nova.ace-net.training -L localhost:8888:node10:8888
Last login: Wed Jan 13 22:50:55 2021 from fctnnbsc38w-99-192-118-218.dhcp-dynamic.fibreop.nb.bellaliant.ne
[user29@login1 ~]$
~~~
{: .output}
This SSH session created tunnel from your computer to node10. The tunnel will be active only while the session is running. Do not close this window and do not logout, this will close the tunnel.

Now in the browser you can type localhost:8888, and enter the token when prompted.

Open new notebook. Ensure that you are creating notebook with the kernel matching the activated environment, or it will fail to start!

#### Uninstalling virtual environment from Jupyter:
~~~
jupyter kernelspec list
jupyter kernelspec uninstall env-382
~~~
{: .bash}

### Using JupyterHubs
JupyterHub servers are available on
- [Beluga](https://jupyterhub.beluga.calculcanada.ca/hub/login)
- [Siku](https://services.siku.ace-net.ca/jupyter/hub/spawn)
- [Nova](https://jupyter.nova.ace-net.training)

#### Installing Virtual Environments in JupyterHub

We can skip this step as we have already installed the environment env-382-jn, so we can use it in JupyterHub as well as in Jupyter notebook.

Install and activate a virtual environment, install the new kernel for Jupyter.
~~~
module load StdEnv/2020 python/3.8.2
virtualenv env-382
source env-382/bin/activate
pip install ipykernel
python -m ipykernel install --user --name=env-382
~~~
{: .bash}

The new kernel will be available in JupyterHub.

#### Shutting down servers:

- Beluga, Siku:
File -> Hub Control Panel -> Stop My Server -> My Server
- Nova: cancel job


### Using Tensorflow
Check what tensorflow versions are available
~~~
avail_wheels tensorflow* --all-pythons --all-versions
~~~
{: .bash}

We can install tensorflow into the environment that we have already created, env-382-jn
~~~
module load StdEnv/2020 python
source ~/env-382-jn/bin/activate
pip install tensorflow-gpu
~~~
{: .bash}

Allocate GPU, load modules and activate the environment
~~~
salloc -c2 --mem-per-cpu=4000 --gres=gpu:1
module load StdEnv/2020 python cudacore/.11.0.2 cudnn
source ~/env-382-jn/bin/activate
python
~~~
{: .bash}

#### Simple tensorflow GPU test
~~~
import tensorflow as tf
print("Num GPUs Available: ", len(tf.config.experimental.list_physical_devices('GPU')))
node1 = tf.constant(3.0)
node2 = tf.constant(4.0)
print(node1, node2)
print(node1 + node2)
~~~
{: .python}

#### MNIST tensorflow test
File mnist.py
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

#### Submitting tensorflow jobs
File submit.sh
~~~
#!/bin/bash
#SBATCH -c1 --mem-per-cpu=4000 --gres=gpu:1 --time=1:0:0

module load StdEnv/2020 python cudacore/.11.0.2 cudnn
source ~/env-382-jn/bin/activate
SECONDS=0
python mnist.py
echo Elapsed $SECONDS seconds
~~~
{: .file-content}

### Monitoring GPU usage
~~~
nvidia-smi --query-gpu=utilization.gpu,utilization.memory, --format=csv -l 1
~~~
{: .bash}

#### Multi-GPU jobs

##### Which devices your operations and tensors are assigned to?
~~~
tf.debugging.set_log_device_placement(True)

# Create some tensors
a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
c = tf.matmul(a, b)

print(c)module
~~~
{: .bash}

##### Place operation on a device of your choice:
~~~
tf.debugging.set_log_device_placement(True)

# Place tensors on the CPU
with tf.device('/CPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])

# Run on the GPU0
with tf.device('/GPU:0'):
  c = tf.matmul(a, b)

print(c)
~~~
{: .bash}

##### Nova has only single GPU nodes, but we can allocate 2 GPUs on Siku and use them from tensorflow:
~~~
salloc -c2 --mem-per-cpu=4000 --gres=gpu:v100:2 --partition=all_gpus
module load StdEnv/2020 python cudacore/.11.0.2 cudnn
source ~/env382-tf/bin/activate
python
~~~
{: .bash}

~~~
import tensorflow as tf
print("Num GPUs: ", len(tf.config.experimental.list_physical_devices('GPU')))
tf.debugging.set_log_device_placement(True)

# Place tensors on the CPU
with tf.device('/CPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])

# Run on the GPU1
with tf.device('/GPU:1'):
  c = tf.matmul(a, b)

print(c)
~~~
{: .python}


{% include links.md %}
