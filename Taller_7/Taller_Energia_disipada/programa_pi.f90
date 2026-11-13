! ============================================================
! Programa:  programa_pi
! Propósito: calcular pi = integral de 4/(1+x^2) en [0, 1] con
!            la integración de Romberg (modulo_romberg sin cambios).
! Salida:    resultado_pi.dat
! ============================================================
program programa_pi
  use modulo_romberg, only: dp, pi, ID_PI, romberg
  implicit none
  real(dp), parameter :: tol = 1.0e-5_dp
  integer, parameter :: kmax = 20
  real(dp), allocatable :: S(:,:)
  real(dp) :: valor, error
  integer :: k_final, n_eval, u

  call romberg(ID_PI, 0.0_dp, 1.0_dp, tol, kmax, S, k_final, n_eval)
  valor = S(k_final, k_final)
  error = abs(valor - pi)

  open(newunit=u, file='resultado_pi.dat', status='replace')
  write(u, '(i4,1x,i6,2(1x,es24.15e3))') k_final, n_eval, valor, error
  close(u)

  print '(a,i3,a,i5)', 'k_final = ', k_final, '   evaluaciones = ', n_eval
  print '(a,f16.12)', 'pi (Romberg) = ', valor
  print '(a,es10.2)', 'error        = ', error
end program programa_pi
