Using Sphinx Fortran
====================

Configure Sphinx
----------------

1)  use Python 2.7.x
#)  install sphinx 
#)  install sphinx-fortran v1.0.1
#)  optional: install sphinx_rtd_theme
#)  Create directory ``${MY_FORTRAN_PROJECT}/doc`` and change into it.
#)  Run ``sphinx-quickstart``

Configure Sphinx-Fortran
------------------------

#)  Add ``sphinxfortran.fortran_domain`` and ``sphinxfortran.fortran_autodoc`` 
    to the list of extensions in ``conf.py``:

    ..  code-block:: python
        :emphasize-lines: 3,4

        extensions = [
            # [...]
            'sphinxfortran.fortran_domain',
            'sphinxfortran.fortran_autodoc',
        ]

#)  Set the ``html_theme`` to something nicer than the default, e.g. 
    ``bizstyle``, ``classic`` or ``sphinxdoc`` or ``sphinx_rtd_theme`` :

    .. literalinclude:: conf.py
       :language: python
       :lines: 119

#)  Add the following configuration to the end of ``conf.py``:

    .. literalinclude:: conf.py
       :language: python
       :lines: 300-


Create API section
------------------

#)  Add the following lines to the ``index.rst`` file:

    ..  code-block:: rest

        API
        ===
        .. toctree::
           :maxdepth: 1
        
           md_gprof_all

    The entry ``md_gprof_all`` adds a link to the file ``md_gprof_all.rst`` to the 
    API index.  

#)  Create ``md_gprof_all.rst`` with the following content:

    .. literalinclude:: md_gprof_all.rst
       :language: rest
       :linenos:

    This file contains the following directives:

    * The reference label ``.. _md_program:`` can be used
      to link to the section header by using ``:ref:`md_program``` in 
      a .rst file. E.g. see :ref:`md_program`.
    * The lines:

        * ``.. f:autosrcfile:: tree_sort.f90`` and 
        * ``.. f:autosrcfile:: tree_sort_module.f90``

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
