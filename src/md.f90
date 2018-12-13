program main
! The main program for MD.
!
!  Discussion:
!    MD implements a simple molecular dynamics simulation.
!    The velocity Verlet time integration scheme is used. 
!    The particles interact with a central pair potential.
!
!    Based on a FORTRAN90 program by Bill Magro.
!
!    Calculating distances, forces, potential- and kinetic-
!    energies have been broken out into subroutines to make this
!    a more interesting example to analyze with a profiler.
!    2018-05-25 Oliver Stueker
!
!  Usage:
!    md nd np step_num dt
!
!    where:
!
!    * nd is the spatial dimension (2 or 3);
!    * np is the number of particles (500, for instance);
!    * step_num is the number of time steps (500, for instance).
!    * dt is the time step (0.1 for instance )
!
!  Licensing:
!    This code is distributed under the GNU LGPL license.
!
!  Modified:
!    25 May 2018 by Oliver Stueker
!
!  Author:
!    John Burkardt
!
  implicit none

  real ( kind = 8 ), allocatable :: acc(:,:)
  integer ( kind = 4 ) arg_num
  real ( kind = 8 ) ctime
  real ( kind = 8 ) ctime1
  real ( kind = 8 ) ctime2
  real ( kind = 8 ) dt
  real ( kind = 8 ) e0
  real ( kind = 8 ), allocatable :: force(:,:)
  integer ( kind = 4 ) iarg
  integer ( kind = 4 ) id
  integer ( kind = 4 ) ierror
  real ( kind = 8 ) kinetic
  integer ( kind = 4 ) last
  real ( kind = 8 ), parameter :: mass = 1.0D+00
  integer ( kind = 4 ) nd
  integer ( kind = 4 ) np
  real ( kind = 8 ), allocatable :: pos(:,:)
  real ( kind = 8 ) potential
  real ( kind = 8 ) rel
  integer ( kind = 4 ) step
  integer ( kind = 4 ) step_num
  integer ( kind = 4 ) step_print
  integer ( kind = 4 ) step_print_index
  integer ( kind = 4 ) step_print_num
  character ( len = 255 ) string
  real ( kind = 8 ), allocatable :: vel(:,:)
  real ( kind = 8 ) wtime

  call timestamp ( )

  write ( *, '(a)' ) ' '
  write ( *, '(a)' ) 'MD'
  write ( *, '(a)' ) '  FORTRAN90 version'
  write ( *, '(a)' ) '  A molecular dynamics program.'
!
!  Get the number of command line arguments.
!
  arg_num = iargc ( )
!
!  Get ND, the number of spatial dimensions.
!
  if ( 1 <= arg_num ) then
    iarg = 1
    call getarg ( iarg, string )
    call s_to_i4 ( string, nd, ierror, last )
  else
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) '  Enter ND, the spatial dimension (2 or 3 ):'
    read ( *, * ) nd
  end if
!
!  Get NP, the number of particles.
!
  if ( 2 <= arg_num ) then
    iarg = 2
    call getarg ( iarg, string )
    call s_to_i4 ( string, np, ierror, last )
  else
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) &
      '  Enter NP, the number of particles (500, for instance):'
    read ( *, * ) np
  end if
!
!  Get STEP_NUM, the number of time steps.
!
  if ( 3 <= arg_num ) then
    iarg = 3
    call getarg ( iarg, string )
    call s_to_i4 ( string, step_num, ierror, last )
  else
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) &
      '  Enter STEP_NUM, the number of time steps (500, for instance):'
    read ( *, * ) step_num
  end if
!
!  Get DT, the time step.
!
  if ( 4 <= arg_num ) then
    iarg = 4
    call getarg ( iarg, string )
    call s_to_r8 ( string, dt  )
  else
    write ( *, '(a)' ) ' '
    write ( *, '(a)' ) &
      '  Enter DT, the time step size (0.1, for instance):'
    read ( *, * ) dt
  end if
!
!  Report.
!
  write ( *, '(a)' ) ' '
  write ( *, '(a,i8)' ) '  ND, the spatial dimension, is ', nd
  write ( *, '(a,i8)' ) &
    '  NP, the number of particles in the simulation is ', np
  write ( *, '(a,i8)' ) '  STEP_NUM, the number of time steps, is ', step_num
  write ( *, '(a,g14.6)' ) '  DT, the size of each time step, is ', dt
!
!  Allocate memory.
!
  allocate ( acc(nd,np) )
  allocate ( force(nd,np) )
  allocate ( pos(nd,np) )
  allocate ( vel(nd,np) )

  write ( *, '(a)' ) ' '
  write ( *, '(a)' ) &
    '  At each step, we report the potential and kinetic energies.'
  write ( *, '(a)' ) '  The sum of these energies should be a constant.'
  write ( *, '(a)' ) '  As an accuracy check, we also print the relative error'
  write ( *, '(a)' ) '  in the total energy.'
  write ( *, '(a)' ) ' '
  write ( *, '(a)' ) &
    '      Step      Potential       Kinetic        (P+K-E0)/E0'
  write ( *, '(a)' ) &
    '                Energy P        Energy K       Relative Energy Error'
  write ( *, '(a)' ) ' '
!
!  This is the main time stepping loop:
!    Initialize or update positions, velocities, accelerations.
!    Compute forces and energies,
!
  step_print = 0
  step_print_index = 0
  step_print_num = 10

  call cpu_time ( ctime1 )

  do step = 0, step_num

    if ( step == 0 ) then
      call initialize ( np, nd, pos, vel, acc )
    else
      call update ( np, nd, pos, vel, force, acc, mass, dt )
    end if

    call compute ( np, nd, pos, vel, mass, force, potential, kinetic )

    if ( step == 0 ) then
      e0 = potential + kinetic
    end if

    if ( step == step_print ) then
      rel = ( potential + kinetic - e0 ) / e0
      write ( *, '(2x,i8,2x,g14.6,2x,g14.6,2x,g14.6)' ) &
        step, potential, kinetic, rel 
      step_print_index = step_print_index + 1
      step_print = ( step_print_index * step_num ) / step_print_num
    end if

  end do
!
!  Report time.
!
  call cpu_time ( ctime2 )
  ctime = ctime2 - ctime1
  write ( *, '(a)' ) ' '
  write ( *, '(a)' ) '  Elapsed cpu time for main computation:'
  write ( *, '(2x,g14.6,a)' ) ctime, ' seconds'
!
!  Free memory.
!
  deallocate ( acc )
  deallocate ( force )
  deallocate ( pos )
  deallocate ( vel )
!
!  Terminate.
!
  write ( *, '(a)' ) ' '
  write ( *, '(a)' ) 'MD:'
  write ( *, '(a)' ) '  Normal end of execution.'
  write ( *, '(a)' ) ' '
  call timestamp ( )

  stop
end

!*****************************************************************************80
subroutine compute ( np, nd, pos, vel, mass, f, pot, kin )
! Computes the forces and energies.
!
!  Discussion:
!    The computation of forces and energies is fully parallel.
!
!    The potential function V(X) is a harmonic well which smoothly
!    saturates to a maximum value at PI/2:
!
!      v(x) = ( sin ( min ( x, PI/2 ) ) )^2
!
!    The derivative of the potential is:
!
!      dv(x) = 2.0D+00 * sin ( min ( x, PI/2 ) ) * cos ( min ( x, PI/2 ) )
!            = sin ( 2.0 * min ( x, PI/2 ) )
!
!  Licensing:
!    This code is distributed under the GNU LGPL license.
!
!  Modified:
!    15 July 2008
!
!  Author:
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) NP, the number of particles.
!
!    Input, integer ( kind = 4 ) ND, the number of spatial dimensions.
!
!    Input, real ( kind = 8 ) POS(ND,NP), the positions.
!
!    Input, real ( kind = 8 ) VEL(ND,NP), the velocities.
!
!    Input, real ( kind = 8 ) MASS, the mass.
!
!    Output, real ( kind = 8 ) F(ND,NP), the forces.
!
!    Output, real ( kind = 8 ) POT, the total potential energy.
!
!    Output, real ( kind = 8 ) KIN, the total kinetic energy.
!
  implicit none

  integer ( kind = 4 ) np
  integer ( kind = 4 ) nd

  real ( kind = 8 ) d
  real ( kind = 8 ) d2
  real ( kind = 8 ) f(nd,np)
  integer ( kind = 4 ) i
  integer ( kind = 4 ) j
  real ( kind = 8 ) kin
  real ( kind = 8 ) mass
  real ( kind = 8 ), parameter :: PI2 = 3.141592653589793D+00 / 2.0D+00
  real ( kind = 8 ) pos(nd,np)
  real ( kind = 8 ) pot
  real ( kind = 8 ) rij(nd)
  real ( kind = 8 ) vel(nd,np)

  pot = 0.0D+00

  do i = 1, np
    !
    !  Compute the potential energy and forces.
    !
    f(1:nd,i) = 0.0D+00

    do j = 1, np

      if ( i /= j ) then

        call calc_distance (np, nd, pos, i, j, rij, d, d2)
    
        call calc_pot(d2, pot)
        
        call calc_force (np, nd, i, d, d2, rij, f)

      end if

    end do

  end do
  
  call calc_kin ( np, nd, vel, mass, kin )
  
  return
end

subroutine calc_pot (d2, pot)
!  Calculate potential energy for truncated distance D2.
!
!  Parameters:
!    Input,  real ( kind = 8 ) D2,  trucated distance.
!    In/Out, real ( kind = 8 ) POT, potential energy.
    implicit none

    real ( kind = 8 ) d2
    real ( kind = 8 ) pot

    !
    !  Attribute half of the total potential energy to particle J.
    !
    pot = pot + 0.5D+00 * sin ( d2 ) * sin ( d2 )
end subroutine calc_pot

subroutine calc_force (np, nd, i, d, d2, rij, f)
!  Add particle J's contribution to the force on particle I.
!
!  Parameters:
!    Input,  integer ( kind = 4 ) NP, the number of particles.
!    Input,  integer ( kind = 4 ) ND, the number of spatial dimensions.
!    Input,  integer ( kind = 4 ) I,  index of particle I.
!    Input,  real ( kind = 8 )    D, distance.
!    Input,  real ( kind = 8 )    D2, trucated distance.
!    Input,  real ( kind = 8 )    Rij(nd),  distance vector
!    In/Out, real ( kind = 8 )    F(ND,NP), the forces.
    implicit none

    integer ( kind = 4 ) np
    integer ( kind = 4 ) nd
    integer ( kind = 4 ) i

    real ( kind = 8 ) d
    real ( kind = 8 ) d2
    real ( kind = 8 ) rij(nd)
    real ( kind = 8 ) f(nd,np)
    !
    !  Add particle J's contribution to the force on particle I.
    !
    f(1:nd,i) = f(1:nd,i) - rij(1:nd) * sin ( 2.0D+00 * d2 ) / d
end subroutine calc_force

subroutine calc_kin ( np, nd, vel, mass, kin )
!  Compute the total kinetic energy.
!
!  Parameters:
!    Input,  integer ( kind = 4 ) NP, the number of particles.
!    Input,  integer ( kind = 4 ) ND, the number of spatial dimensions.
!    Input,  real ( kind = 8 ) VEL(ND,NP), the velocities.
!    Input,  real ( kind = 8 ) MASS, the mass.
!    Output, real ( kind = 8 ) KIN, the total kinetic energy.
    implicit none

    integer ( kind = 4 ) np
    integer ( kind = 4 ) nd
    real ( kind = 8 ) vel(nd,np)
    real ( kind = 8 ) mass
    real ( kind = 8 ) kin

    kin = 0.5D+00 * mass * sum ( vel(1:nd,1:np)**2 )

end subroutine calc_kin

!*****************************************************************************80
subroutine initialize ( np, nd, pos, vel, acc )
! Initializes the positions, velocities, and accelerations.
!
!  Licensing:
!    This code is distributed under the GNU LGPL license.
!
!  Modified:
!    26 December 2014
!
!  Author:
!    John Burkardt
!
!  Parameters:
!
!    Input, integer ( kind = 4 ) NP, the number of particles.
!
!    Input, integer ( kind = 4 ) ND, the number of spatial dimensions.
!
!    Output, real ( kind = 8 ) POS(ND,NP), the positions.
!
!    Output, real ( kind = 8 ) VEL(ND,NP), the velocities.
!
!    Output, real ( kind = 8 ) ACC(ND,NP), the accelerations.
!
  implicit none

  integer ( kind = 4 ) np
  integer ( kind = 4 ) nd

  real ( kind = 8 ) acc(nd,np)
  real ( kind = 8 ) pos(nd,np)
  integer ( kind = 4 ) seed
  real ( kind = 8 ) vel(nd,np)
!
!  Set the positions.
!
  seed = 123456789
  call r8mat_uniform_ab ( nd, np, 0.0D+00, 10.0D+00, seed, pos )
!
!  Set the velocities.
!
  vel(1:nd,1:np) = 0.0D+00
!
!  Set the accelerations.
!
  acc(1:nd,1:np) = 0.0D+00

  return
end


!*****************************************************************************80
subroutine update ( np, nd, pos, vel, f, acc, mass, dt )
! Updates positions, velocities and accelerations.
!
!  Discussion:
!    The time integration is fully parallel.
!
!    A velocity Verlet algorithm is used for the updating.
!
!    x(t+dt) = x(t) + v(t) * dt + 0.5 * a(t) * dt * dt
!    v(t+dt) = v(t) + 0.5 * ( a(t) + a(t+dt) ) * dt
!    a(t+dt) = f(t) / m
!
!  Licensing:
!    This code is distributed under the GNU LGPL license.
!
!  Modified:
!    21 November 2007
!
!  Author:
!    John Burkardt
!
!  Parameters:
!    Input, integer ( kind = 4 ) NP, the number of particles.
!
!    Input, integer ( kind = 4 ) ND, the number of spatial dimensions.
!
!    Input/output, real ( kind = 8 ) POS(ND,NP), the positions.
!
!    Input/output, real ( kind = 8 ) VEL(ND,NP), the velocities.
!
!    Input, real ( kind = 8 ) F(ND,NP), the forces.
!
!    Input/output, real ( kind = 8 ) ACC(ND,NP), the accelerations.
!
!    Input, real ( kind = 8 ) MASS, the mass of each particle.
!
!    Input, real ( kind = 8 ) DT, the time step.
!
  implicit none

  integer ( kind = 4 ) np
  integer ( kind = 4 ) nd

  real ( kind = 8 ) acc(nd,np)
  real ( kind = 8 ) dt
  real ( kind = 8 ) f(nd,np)
  integer ( kind = 4 ) i
  integer ( kind = 4 ) j
  real ( kind = 8 ) mass
  real ( kind = 8 ) pos(nd,np)
  real ( kind = 8 ) rmass
  real ( kind = 8 ) vel(nd,np)

  rmass = 1.0D+00 / mass

  do j = 1, np
    do i = 1, nd
      pos(i,j) = pos(i,j) + vel(i,j) * dt + 0.5D+00 * acc(i,j) * dt * dt
      vel(i,j) = vel(i,j) + 0.5D+00 * dt * ( f(i,j) * rmass + acc(i,j) )
      acc(i,j) = f(i,j) * rmass
    end do
  end do

  return
end
