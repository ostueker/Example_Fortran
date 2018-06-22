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
