subroutine calc_distance (np, nd, pos, i, j, rij, d, d2)
!
!  Calculate Distance vector, scalar distance and trucated distance
!  between atoms i and j.
!
!  The distance is truncated at pi/2
!
    implicit none
    integer(kind=4), intent(in) :: np         ! the number of particles
    integer(kind=4), intent(in) :: nd         ! the number of spatial dimensions
    real(kind=8),    intent(in) :: pos(nd,np) ! the positions
    integer(kind=4), intent(in) :: i          ! index of particle I
    integer(kind=4), intent(in) :: j          ! index of particle J
    real(kind=8),   intent(out) :: rij(nd)    ! distance vector
    real(kind=8),   intent(out) :: d          ! distance
    real(kind=8),   intent(out) :: d2         ! trucated distance


    real ( kind = 8 ), parameter :: PI2 = 3.141592653589793D+00 / 2.0D+00

    rij(1:nd) = pos(1:nd,i) - pos(1:nd,j)

    d = sqrt ( sum ( rij(1:nd)**2 ) )
    !
    !  Truncate the distance.
    !
    d2 = min ( d, PI2 )
end subroutine calc_distance




!    :param: integer(kind=4) NP[in]: the number of particles.
!    :param: integer(kind=4) ND[in]: the number of spatial dimensions.
!    :param: real(kind=8)    POS(ND,NP)[in]: the positions.
!    :param: integer(kind=4) I[in]:  index of particle I.
!    :param: integer(kind=4) J[in]:  index of particle J.


!  Parameters:
!    :p  integer(kind=4) NP[in]: the number of particles.
!    :p  integer(kind=4) ND[in]: the number of spatial dimensions.
!    :p  real(kind=8)    POS(ND,NP)[in]: the positions.
!    :p  integer(kind=4) I[in]:  index of particle I.
!    :p  integer(kind=4) J[in]:  index of particle J.
!
!    Output, real ( kind = 8 )    Rij(nd), distance vector
!    Output, real ( kind = 8 )    D,  distance.
!    Output, real ( kind = 8 )    D2, trucated distance.
