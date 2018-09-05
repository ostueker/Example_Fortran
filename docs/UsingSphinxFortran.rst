Using Sphinx Fortran
====================

Installing Sphinx
-----------------

General:
''''''''

1)  use Python 2.7.x
#)  install sphinx 
#)  install sphinx-fortran
#)  optional: install sphinx_rtd_theme
#)  Create directory ``${MY_FORTRAN_PROJECT}/doc`` and change into it.
#)  Run ``sphinx-quickstart``

In an Anaconda Python Environment:
''''''''''''''''''''''''''''''''''

As Sphinx-Fortran at this point doesn't support Python 3,
we start off with a Python-2 based conda environment:

    .. code-block:: console

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



Configure Sphinx and Sphinx-Fortran
-----------------------------------

Generating the initial Project
''''''''''''''''''''''''''''''

.. code-block:: console

    $ mkdir Example_Fortran
    $ cd Example_Fortran
    $ mkdir src
    $ wget https://acenet-arc.github.io/ACENET_Summer_School_General/code/profiling/md_gprof.f90
    $ mv  md_gprof.f90  src/md.f90

Generating the initial Sphinx Documentation
'''''''''''''''''''''''''''''''''''''''''''

.. code-block:: console

    (sphinx_fortran) Example_Fortran $ echo '**/_build/'  >> .gitignore
    (sphinx_fortran) Example_Fortran $ mkdir docs
    (sphinx_fortran) Example_Fortran $ cd docs
    (sphinx_fortran) docs $ sphinx-quickstart
    # leaving all values at their default except for:
    > Project name: Example Fortran Project
    > Author name(s): John Doe
    
    (sphinx_fortran) docs $ make html
    # open the HTML documentation in Firefox:
    (sphinx_fortran) docs $ firefox _build/html/index.html

Enable Sphinx-Fortran
'''''''''''''''''''''

#)  Un-comment the following lines under "Path Setup":

    ..  code-block:: python

        import os
        import sys


#)  Add ``sphinx.ext.autodoc``, ``sphinxfortran.fortran_domain`` 
    and ``sphinxfortran.fortran_autodoc`` to the list of extensions 
    in ``conf.py``:

    ..  code-block:: python
        :emphasize-lines: 3,4,5

        extensions = [
            # [...]
            'sphinx.ext.autodoc',
            'sphinxfortran.fortran_domain',
            'sphinxfortran.fortran_autodoc',
        ]

    Some other extensions like :mod:`sphinx:sphinx.ext.imgmath` or
    :mod:`sphinx:sphinx.ext.todo` might be useful as well.


#)  Set the ``html_theme`` to something nicer than the default, e.g. 
    ``bizstyle``, ``classic`` or ``sphinxdoc`` or ``sphinx_rtd_theme`` :

    .. literalinclude:: conf.py
       :language: python
       :lines: 94

#)  Add the following configuration to the end of ``conf.py``:

    .. literalinclude:: conf.py
       :language: python
       :lines: 181-


.. _local_intersphinx_label:

Optional: Enable Inter-Sphinx
'''''''''''''''''''''''''''''

The ``intersphinx`` extension allows linking to pages of other sphinx-based
documentation. Here we enable the extension and then create references to
the documentation of the Sphinx project itself and the sphinxfortran extension.

..  code-block:: python
    :emphasize-lines: 2

    extensions = [
        'sphinx.ext.intersphinx',
        # [...]
    ]


..  code-block:: python

    ## -- Options for Inter-Sphinx---- -------------------------------------------
    intersphinx_mapping = {
       'python':         ('https://docs.python.org/3', None)
       'sphinx':         ('http://www.sphinx-doc.org/en/stable', None),
       'sphinxfortran':  ('http://sphinx-fortran.readthedocs.io/en/latest/', None),
    }

Now we can include a link to the documentation of  :py:mod:`Intersphinx<sphinx:sphinx.ext.intersphinx>`
by including ``:py:mod:`Intersphinx<sphinx:sphinx.ext.intersphinx>``` 
in this ``.rst`` file.  
Refer to :ref:`Cross-referencing syntax<sphinx:xref-syntax>` and 
:py:mod:`Intersphinx Documentaion<sphinx:sphinx.ext.intersphinx>` on how to
use it.


Create API section
------------------

#)  Add the following lines to the ``index.rst`` file:

    ..  code-block:: rest

        API
        ===
        .. toctree::
           :maxdepth: 1
        
           md_all

    The entry ``md_gprof_all`` adds a link to the file ``md_gprof_all.rst`` to the 
    API index.  

#)  Create ``md_all.rst`` with the following content:

    .. literalinclude:: md_all.rst
       :language: rest
       :linenos:

    This file contains the following directives:

    * The reference label ``.. _md_program:`` can be used
      to link to the section header by using ``:ref:`md_program``` in 
      a .rst file. E.g. see :ref:`md_program`.
    * The line:

        * ``.. f:autosrcfile:: md.f90``

      will include the `autodoc`_ for these Fortran files in this document.
      If appropriate `header-comments`_ and `inline-comments`_ have been added
      to the Fortran code, these will be added to the API description of the 
      elements included in those files.

#)  Create more API pages with Autodocs. For projects consisting of many source 
    files, it good to organize them a bit. 
    Pages can also be organized hierarchically by adding a ``.. toctree::`` to 
    a page and define sub-pages. 
    See the :ref:`TOC tree<toctree-directive>` reference in the Sphinx docs.

.. _autodoc: http://sphinx-fortran.readthedocs.io/en/latest/user.autodoc.html
.. _header-comments: http://sphinx-fortran.readthedocs.io/en/latest/user.autodoc.html#header-comments
.. _inline-comments: http://sphinx-fortran.readthedocs.io/en/latest/user.autodoc.html#inline-comments


Create Pages For User Manual
----------------------------

#)  Apart from API documentation, User-Manual pages can be written and added
    to the ``toctree`` in ``index.rst`` (Just as this page).

#)  These pages can be organized hierarchically as well, by adding a 
    ``.. toctree::`` to a page and define sub-pages. 
    See the :ref:`TOC tree<toctree-directive>` reference in the Sphinx docs.
