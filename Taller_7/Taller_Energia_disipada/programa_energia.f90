! ============================================================
! Programa:  programa_energia
! Propósito: energía disipada por un oscilador amortiguado en
!            [0, 3] s con Romberg, y comparación con E(0) - E(T).
! Salida:    tabla_energia.dat, resultado_energia.dat
! ============================================================
program programa_energia
  use modulo_romberg, only: dp, ID_ENERGIA, romberg, energia
  implicit none
  real(dp), parameter :: T = 3.0_dp, tol = 1.0e-6_dp
  integer, parameter :: kmax = 20
  real(dp), allocatable :: S(:,:)
  real(dp) :: e_dis, e_ref
  integer :: k, k_final, n_eval, u

  call romberg(ID_ENERGIA, 0.0_dp, T, tol, kmax, S, k_final, n_eval)
  e_dis = S(k_final, k_final)
  e_ref = energia(0.0_dp) - energia(T)

  open(newunit=u, file='tabla_energia.dat', status='replace')
  do k = 0, k_final
     write(u, '(*(es24.15e3,1x))') S(k, 0:k)
  end do
  close(u)

  open(newunit=u, file='resultado_energia.dat', status='replace')
  write(u, '(i4,1x,i6,3(1x,es24.15e3))') k_final, n_eval, e_dis, e_ref, abs(e_dis - e_ref)
  close(u)

  print '(a,i3,a,i5)', 'k_final = ', k_final, '   evaluaciones = ', n_eval
  print '(a,f16.10)', 'E_dis (Romberg) = ', e_dis
  print '(a,f16.10)', 'E(0) - E(T)     = ', e_ref
  print '(a,es10.2)', '|diferencia|    = ', abs(e_dis - e_ref)
end program programa_energia
