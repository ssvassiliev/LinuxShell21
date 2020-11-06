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
