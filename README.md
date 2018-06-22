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
(sphinx_fortran)$ pip install sphinx-fortran

```
