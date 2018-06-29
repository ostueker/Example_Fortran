Refactoring Fortran For Sphinx
==============================

Primer
------

In the previous Chapter we have installed and configured Sphinx and 
Sphinx-Fortran for our project.  At this stage Sphinx-Fortran already 
extracts information on all *programs*, *modules*, *types*, *functions*
and *subroutines* and the names of their parameters from the source-code,
together with where the entity is used and which functions/routines it calls,
and lists them on a page.

What is missing is some context: What is the meaning of parameter ``d``
and what's the unit in which ``pot`` is given?

Sphinx reads and interprets header-comments (comments directly after a 
declaring the *program*, *module*, *subroutine*, etc.) which can contain
reStructuredText markup.  They are included in the generated documentation
and should be used to explain the behavior of the item, just like Doc-Strings
in Python.

.. tip::
    A good documentation for a module, function or subroutine should
    give a good idea of it's *behavior* (what it does) and **not** delve
    into the *implementation* (how it does it).
    
    A good way to achieve this is by starting with a short one-line summary,
    followed by an extended description and then one or more examples.
    These parts (summary, description, examples) should be separated by 
    blank lines.
    
    Documentation that delves into details of implementation quickly 
    gets out of date because it is not updated along with the code when
    the implementation changes.  This can then mislead the reader.
    
    A few well chosen examples on the other hand can help the reader (and
    potential user of the function) to get a correct understanding of 
    what result to expect for a particular invocation of the code.

Inline comments after variable declarations, which are passed as parameters
to a subroutine/function, are also processed and should be used to supply
a human-readable description of the variable. 

.. important:: Declare each of the parameters on an individual line!

Generic Examples are given in the `Sphinx-Fortran <http://sphinx-fortran.readthedocs.io/en/latest/user.autodoc.html#optimize-the-process>`_ documentation.



Example 1: `subroutine calc_distance`
-------------------------------------

.. highlight:: fortran

Before:: 

    subroutine calc_distance (np, nd, pos, i, j, rij, d, d2)
        !
        !  Calculate Distance vector, scalar distance and trucated distance
        !    between atoms i and j.
        ! 
        !  Parameters:
        !    Input,  integer ( kind = 4 ) NP, the number of particles.
        !    Input,  integer ( kind = 4 ) ND, the number of spatial dimensions.
        !    Input,  real ( kind = 8 )    POS(ND,NP), the positions.
        !    Input,  integer ( kind = 4 ) I,  index of particle I.
        !    Input,  integer ( kind = 4 ) J,  index of particle J.
        !
        !    Output, real ( kind = 8 )    Rij(nd), distance vector
        !    Output, real ( kind = 8 )    D,  distance.
        !    Output, real ( kind = 8 )    D2, trucated distance.
        implicit none
        integer ( kind = 4 ) np
        integer ( kind = 4 ) nd

        real ( kind = 8 ) d
        real ( kind = 8 ) d2
        integer ( kind = 4 ) i
        integer ( kind = 4 ) j
        real ( kind = 8 ), parameter :: PI2 = 3.141592653589793D+00 / 2.0D+00
        real ( kind = 8 ) pos(nd,np)
        real ( kind = 8 ) rij(nd)

        rij(1:nd) = pos(1:nd,i) - pos(1:nd,j)

        d = sqrt ( sum ( rij(1:nd)**2 ) )
        !
        !  Truncate the distance.
        !
        d2 = min ( d, PI2 )
    end subroutine calc_distance
