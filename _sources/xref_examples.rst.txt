Cross-Referencing Examples
==========================

General
-------

In this example the reference consists of the following parts:

    * The ``:py:mod:``-role indicates that the target is a Python module.
      When the target however is addressed by a reference name, the
      ``:ref:`` role needs to be used.  In this way one can cross-reference
      arbitrary locations. See: :ref:`sphinx:xref-syntax`
    * The role is followed by the reference enclosed in back-ticks (`````).
      The reference consists of either:

      * just the reference-label for a local reference,
        e.g. ``local_intersphinx_label``, or
      * the reference-label prefixed by the relevant key from the 
        ``intersphinx_mapping`` dict, e.g. ``sphinx:xref-syntax``
      * The reference can also be preceded by a link text and then enclosed
        in ``<`` and ``>``.

    One can use e.g. the following to search a site's inventory file for the
    correct name:

    ..  code-block:: console

        $ python -msphinx.ext.intersphinx http://www.sphinx-doc.org/en/stable/objects.inv | grep -i intersphinx
        sphinx.ext.intersphinx                   ext/intersphinx.html#module-sphinx.ext.intersphinx
        sphinx-quickstart.--ext-intersphinx      man/sphinx-quickstart.html#cmdoption-sphinx-quickstart-ext-intersphinx
        intersphinx_cache_limit                  ext/intersphinx.html#confval-intersphinx_cache_limit
        intersphinx_mapping                      ext/intersphinx.html#confval-intersphinx_mapping
        intersphinx_timeout                      ext/intersphinx.html#confval-intersphinx_timeout


Examples for local references:
------------------------------

    * Local ref w/o link text:   ``:ref:`local_intersphinx_label```  
      becomes:                     :ref:`local_intersphinx_label` 
    * Local ref with link text:  ``:ref:`Local Intersphinx<local_intersphinx_label>```  
      becomes:                     :ref:`Local Intersphinx<local_intersphinx_label>`

Examples for Intersphinx references:
------------------------------------

    * Intersphinx ref w/o text:  ``:ref:`sphinx:xref-syntax```
      becomes:                     :ref:`sphinx:xref-syntax`
    * Intersphinx ref with text: ``:ref:`X-Ref syntax<sphinx:xref-syntax>```
      becomes:                     :ref:`X-Ref syntax<sphinx:xref-syntax>`
    * Intersphinx mod w/o text:  ``:mod:`python:math```
      becomes:                     :mod:`python:math`
    * Intersphinx mod with text: ``:mod:`Python Math module<python:math>```
      becomes:                     :mod:`Python Math module<python:math>`

.. Comment
  * Fortran Program:                ``:f:prog:`Main Function<main>```  
    is rendered as:                   :f:prog:`Main Function<main>`
  * Fortran Function or Subroutine: ``:f:func:`Update Function<update>```  
    is rendered as:                   :f:func:`Update Function<update>` 
