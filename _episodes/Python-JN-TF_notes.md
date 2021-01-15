### Running globally-installed software
We keep software separated from OS. Our compute nodes have only operating system environment nesessary for their function in a cluster. Software stack is installed and managed centrally. Software modules are installed in user environment dynamically when they are needed.
Modules may depend on other modules, so to load some software a combination of several modules mush be loaded.

Management of the modules is performed using the `module` command. The `module` command has three modes.

~~~
module spider # shows all available modules
module spider octave  # shows what versions of a program are available
module spider octave/5.2.0  # show how to load octave/5.2.0
module load StdEnv/2020 octave  # load default octave
module unload octave  # Unload module
module purge # Reset to default modules
module list	  #	List loaded modules
module avail	#	List compatible with currently loaded modules
module key   #  Search modules by keyword
~~~
{: .bash}
