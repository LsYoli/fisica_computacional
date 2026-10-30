! Taller 5 -- pi por acierto y error con el LCG (57, 1, 256) en lugar de random_number.
! Salida: lcg.dat (N, pi_est).
program taller5_lcg
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer, parameter :: a_lcg = 57, c_lcg = 1, M_lcg = 256
  integer :: k, r, u_dat
  integer(8) :: i, n_total, n_aciertos
  real(dp) :: x, y, pi_est

  open(newunit=u_dat,file='lcg.dat',status='replace')
  do k = 2, 7                                   ! N = 10^2, ..., 10^7
     n_total = 10_8**k
     r = 10                                     ! semilla del LCG, la misma para cada N
     pi_est = -1.0_dp                           ! valor provisional

     ! TODO C1: obtenga pi_est con n_total puntos cuyas coordenadas salen del LCG (sección 5).
     ! Cada punto usa dos números consecutivos del LCG: el primero da x y el segundo da y.
     ! r/M_lcg normaliza el estado a [0,1) y luego se pasa a [-1,1) como en la sección 2.
     n_aciertos = 0                             ! el contador se reinicia para cada N
     do i = 1, n_total
        r = mod(a_lcg*r + c_lcg, M_lcg)         ! primer número del par
        x = 2.0_dp*real(r, dp)/M_lcg - 1.0_dp
        r = mod(a_lcg*r + c_lcg, M_lcg)         ! segundo número del par
        y = 2.0_dp*real(r, dp)/M_lcg - 1.0_dp
        if (x*x + y*y < 1.0_dp) n_aciertos = n_aciertos + 1
     end do
     ! real(...,dp) evita la división entera; el círculo ocupa pi/4 del cuadrado.
     pi_est = 4.0_dp*real(n_aciertos, dp)/real(n_total, dp)

     write(u_dat,'(i10,es25.16e3)') n_total,pi_est
     print '(i10,f12.6)', n_total,pi_est
  end do
  close(u_dat)
end program taller5_lcg
