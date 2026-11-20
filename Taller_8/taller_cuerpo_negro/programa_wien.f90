! ==============================================================
! programa_wien.f90
!
! Calcula las raíces positivas x5 (espectro por longitud de onda)
! y x3 (por frecuencia) con los tres métodos del módulo, y con x5
! obtiene la constante de Wien  b = h c / (k_B x5).
!
! Archivos que escribe:
!    resultado_wien.dat    n, método, raíz, iteraciones (7 filas)
!    iteraciones_wien.dat  historial de los tres métodos para n = 5
!    constante_wien.dat    x5, x3, b
! ==============================================================
program programa_wien
  use modulo_ceros
  implicit none

  real(dp), parameter :: TOL = 1.0e-10_dp
  real(dp), parameter :: H_PLANCK = 6.62607015e-34_dp      ! [J s]
  real(dp), parameter :: C_LUZ = 299792458.0_dp            ! [m/s]
  real(dp), parameter :: K_BOLTZMANN = 1.380649e-23_dp     ! [J/K]
  integer,  parameter :: ordenes(2) = [5, 3]

  real(dp) :: cero, x5, x3, b_wien
  integer  :: caso, n_wien, pasos
  integer  :: f_resultado, f_historial, f_constante, reg
  logical  :: convergio
  character(len=*), parameter :: FMT_RES = '(i3,1x,i3,1x,es24.16,1x,i4)'

  open(newunit=f_resultado, file='resultado_wien.dat',   status='replace', action='write')
  open(newunit=f_historial, file='iteraciones_wien.dat', status='replace', action='write')
  open(newunit=f_constante, file='constante_wien.dat',   status='replace', action='write')

  do caso = 1, size(ordenes)
     n_wien = ordenes(caso)

     ! El historial pedido es solo el de n = 5; con reg = 0 los métodos no escriben.
     reg = 0
     if (n_wien == 5) reg = f_historial

     call metodo_biseccion(n_wien, 1.0_dp, 10.0_dp, TOL, cero, pasos, convergio, reg)
     write(f_resultado, FMT_RES) n_wien, M_BISECCION, cero, pasos
     print '(a,i2,a,f18.12,i5)', 'n =', n_wien, '  bisección ', cero, pasos

     call metodo_newton(n_wien, 10.0_dp, TOL, cero, pasos, convergio, reg)
     write(f_resultado, FMT_RES) n_wien, M_NEWTON, cero, pasos
     print '(a,i2,a,f18.12,i5)', 'n =', n_wien, '  Newton    ', cero, pasos
     ! La raíz de Newton es la que se usa para x5 y x3.
     if (n_wien == 5) x5 = cero
     if (n_wien == 3) x3 = cero

     call metodo_secante(n_wien, 10.0_dp, 9.0_dp, TOL, cero, pasos, convergio, reg)
     write(f_resultado, FMT_RES) n_wien, M_SECANTE, cero, pasos
     print '(a,i2,a,f18.12,i5)', 'n =', n_wien, '  secante   ', cero, pasos
  end do

  ! Fila 7: Newton desde x0 = 0.5, que cae en la raíz trivial x = 0.
  call metodo_newton(5, 0.5_dp, TOL, cero, pasos, convergio, 0)
  write(f_resultado, FMT_RES) 5, 4, cero, pasos
  print '(a,es12.4,i5)', 'n = 5  Newton x0=0.5: ', cero, pasos

  b_wien = H_PLANCK*C_LUZ/(K_BOLTZMANN*x5)
  write(f_constante, '(3(es24.16,1x))') x5, x3, b_wien
  print '(a,es22.14)', 'b [m K] = ', b_wien

  close(f_resultado)
  close(f_historial)
  close(f_constante)
end program programa_wien
