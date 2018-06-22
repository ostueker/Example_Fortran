# Fortran Example Project

This project is an example for:

* Using Sphinx to document the code
* writing Unit-tests
* Running CI with GitLab
* ...



## Preparing a Python environment

As Sphinx-Fortran at this point doesn't support Python 3,
we start off with a Python-2 based conda environment:

```console
$ conda create -n sphinx_fortran python=2 
Fetching package metadata ...........
[...]
# To activate this environment, use:
# > source activate sphinx_fortran
#
# To deactivate an active environment, use:
# > source deactivate

$ source activate sphinx_fortran
(sphinx_fortran)$ conda install sphinx sphinx_rtd_theme

# The latest release of sphinx-fortran on PyPi does not work with 
# Sphinx 1.6b1 or newer.
# (sphinx_fortran)$ pip install sphinx-fortran
# Install master from GitHub instead:
(sphinx_fortran)$ git clone https://github.com/VACUMM/sphinx-fortran.git
(sphinx_fortran)$ cd sphinx-fortran
(sphinx_fortran)$ python setup.py install
```

## Generating the initial Project
```console
$ mkdir Example_Fortran
$ cd Example_Fortran
$ mkdir src
$ wget https://acenet-arc.github.io/ACENET_Summer_School_General/code/profiling/md_gprof.f90
$ mv  md_gprof.f90  src/
```

## Generating the initial Sphinx Documentaton
```console
(sphinx_fortran) Example_Fortran $ echo '**/_build/'  >> .gitignore
(sphinx_fortran) Example_Fortran $ mkdir docs
(sphinx_fortran) Example_Fortran $ cd docs
(sphinx_fortran) docs $ sphinx-quickstart
# leaving all values at their default except for:
> Project name: Example Fortran Project
> Author name(s): John Doe

(sphinx_fortran) docs $ make html
(sphinx_fortran) docs $ firefox _build/html/index.html
```

## Activate Sphinx-Fortran in conf.py
1. Un-comment the following lines under "Path Setup":
```python
import os
import sys
```

2. Add `sphinxfortran.fortran_domain` and `sphinxfortran.fortran_autodoc`
   to the extensions:
```python
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.todo',
    'sphinx.ext.coverage',
    'sphinx.ext.imgmath',
    'sphinx.ext.ifconfig',
    'sphinx.ext.intersphinx',
    'sphinxfortran.fortran_domain',
    'sphinxfortran.fortran_autodoc',
]
```
3. Add the following configurations for sphinx-fortran e.g. to the end:
```python
## FORTRAN AUTODOC
# List of possible extensions in the case of a directory listing
fortran_ext = ['f90', 'F90', 'f95', 'F95']

# This variable must be set with file pattern, like "*.f90", or a list of them. 
# It is also possible to specify a directory name; in this case, all files than 
# have an extension matching those define by the config variable `fortran_ext` 
# are used.
fortran_src = os.path.abspath('../src/')

# Indentation string or length (default 4). If it is an integer, 
# indicates the number of spaces.
fortran_indent = 4
```
