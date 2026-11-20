! ==============================================================
! programa_sigma.f90
!
! Constante de Stefan-Boltzmann  sigma = (2 pi k_B^4 / (h^3 c^2)) I,
! con  I = Int_0^inf x^3/(e^x - 1) dx = pi^4/15  (valor exacto).
! I se calcula con Romberg de dos maneras:
!    fila 1: cambio de variable x = t/(1-t), integral en [0, 1]
!    fila 2: directo en [0, 100], sin cambio de variable
! La fila 2 sirve para ver cómo el criterio de parada puede
! cumplirse antes de que la integral haya convergido.
!
! Salida: resultado_sigma.dat  (nivel final, evaluaciones, I, sigma)
! ==============================================================
program programa_sigma
  use modulo_romberg
  implicit none

  real(dp), parameter :: H_PLANCK = 6.62607015e-34_dp      ! [J s]
  real(dp), parameter :: C_LUZ = 299792458.0_dp            ! [m/s]
  real(dp), parameter :: K_BOLTZMANN = 1.380649e-23_dp     ! [J/K]
  real(dp), parameter :: TOL = 1.0e-8_dp
  integer,  parameter :: NIVEL_MAX = 20

  ! Prefactor de sigma; solo falta multiplicar por la integral.
  real(dp), parameter :: PREFACTOR = 2*pi*K_BOLTZMANN**4/(H_PLANCK**3*C_LUZ**2)
  real(dp), parameter :: I_EXACTA = pi**4/15

  ! Dos casos: (integrando, límite inferior, límite superior)
  integer,  parameter :: ids(2) = [ID_NEGRO_T, ID_NEGRO_X]
  real(dp), parameter :: lim_inf(2) = [0.0_dp, 0.0_dp]
  real(dp), parameter :: lim_sup(2) = [1.0_dp, 100.0_dp]

  real(dp), allocatable :: tabla(:,:)
  real(dp) :: valor_I, sigma_sb
  integer  :: fila, nivel_final, n_evaluaciones, f_salida

  open(newunit=f_salida, file='resultado_sigma.dat', status='replace', action='write')

  do fila = 1, 2
     call romberg(ids(fila), lim_inf(fila), lim_sup(fila), TOL, NIVEL_MAX, &
                  tabla, nivel_final, n_evaluaciones)

     ! La mejor estimación es el último elemento de la diagonal.
     valor_I = tabla(nivel_final, nivel_final)
     sigma_sb = PREFACTOR*valor_I

     write(f_salida, '(i3,1x,i8,1x,es24.16,1x,es24.16)') &
           nivel_final, n_evaluaciones, valor_I, sigma_sb
     print '(a,i1,a,i3,i8,es22.14,es22.14)', 'fila ', fila, ': nivel, evaluaciones, I, sigma =', &
           nivel_final, n_evaluaciones, valor_I, sigma_sb
     print '(a,es10.3)', '   |I - pi^4/15| = ', abs(valor_I - I_EXACTA)

     deallocate(tabla)      ! romberg reserva la tabla en cada llamada
  end do

  close(f_salida)
end program programa_sigma
