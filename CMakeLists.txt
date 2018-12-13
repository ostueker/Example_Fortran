CMAKE_MINIMUM_REQUIRED(VERSION 3.2)

PROJECT(md VERSION 0.1 LANGUAGES Fortran)

SET (CMAKE_Fortran_FLAGS_RELEASE " -O4 -finit-local-zero -ffpe-trap=invalid,zero,overflow -g ")
SET (CMAKE_Fortran_FLAGS_DEBUG " -O0 -g ")

SET( MD_SRC
  src/md.f90
  src/sub_calc_distance.f90
  src/sub_helper.f90
 )

ADD_EXECUTABLE(md   ${MD_SRC})
