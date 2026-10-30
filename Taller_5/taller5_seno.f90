! Taller 5 -- Integral de sin(x) en [0,pi/2) por valor medio y acierto y error.
! Salida: seno.dat (media_vm, desv_vm, media_ae, desv_ae).
program taller5_seno
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer, parameter :: N = 1000, R = 1000      ! muestras por corrida y repeticiones
  real(dp), parameter :: a = 0.0_dp, b = 2.0_dp*atan(1.0_dp), H = 1.0_dp
  integer :: rep, i, n_bajo, n_sem, u_dat
  integer, allocatable :: semilla(:)
  real(dp) :: u, v, x, y, suma_f, I_vm, I_ae
  real(dp) :: s_vm, s2_vm, s_ae, s2_ae, media_vm, desv_vm, media_ae, desv_ae

  ! El tamaño del arreglo de semilla depende de la implementación.
  call random_seed(size=n_sem)
  allocate(semilla(n_sem))
  semilla = 314
  call random_seed(put=semilla)                ! se fija una vez, antes de las R corridas

  s_vm = 0.0_dp; s2_vm = 0.0_dp; s_ae = 0.0_dp; s2_ae = 0.0_dp
  do rep = 1, R
     ! Valores provisionales: reemplácelos dentro de los bloques TODO.
     I_vm = -1.0_dp
     I_ae = -1.0_dp

     ! TODO B1: obtenga I_vm por valor medio usando N puntos (sección 4).
     ! Se promedia sin(x) sobre N puntos uniformes en [a,b) y se multiplica
     ! por el ancho del intervalo: I = (b-a) * <f>.
     suma_f = 0.0_dp                            ! se reinicia en cada repetición
     do i = 1, N
        call random_number(u)
        x = a + (b - a)*u                       ! cambio de intervalo [0,1) -> [a,b)
        suma_f = suma_f + sin(x)
     end do
     I_vm = (b - a)*suma_f/real(N, dp)          ! real() evita la división entera

     ! TODO B2: obtenga I_ae por acierto y error en [a,b) x [0,H) (sección 4).
     ! Se lanzan puntos en el rectángulo y se cuentan los que caen bajo la curva;
     ! la fracción de aciertos estima (área bajo la curva)/(área del rectángulo).
     n_bajo = 0                                 ! el contador se reinicia en cada repetición
     do i = 1, N
        call random_number(u)
        call random_number(v)
        x = a + (b - a)*u                       ! x uniforme en [a,b)
        y = H*v                                 ! y uniforme en [0,H); H=1 acota a sin(x)
        if (y < sin(x)) n_bajo = n_bajo + 1
     end do
     I_ae = (b - a)*H*real(n_bajo, dp)/real(N, dp)

     ! TODO B3: acumule las dos integrales y sus cuadrados para las R corridas.
     ! Con la suma y la suma de cuadrados se calculan después la media y la
     ! desviación sin guardar las R estimaciones.
     s_vm  = s_vm  + I_vm
     s2_vm = s2_vm + I_vm*I_vm
     s_ae  = s_ae  + I_ae
     s2_ae = s2_ae + I_ae*I_ae
  end do

  ! Los valores -1 indican que aún no se calcularon las estadísticas.
  media_vm = -1.0_dp; desv_vm = -1.0_dp
  media_ae = -1.0_dp; desv_ae = -1.0_dp
  ! TODO B4: calcule media y desviación estándar muestral para cada método.
  ! El factor R/(R-1) (corrección de Bessel) compensa que la media se estimó con
  ! los mismos datos; max(...,0) evita la raíz de un negativo diminuto por redondeo.
  media_vm = s_vm/real(R, dp)
  desv_vm  = sqrt(max(real(R, dp)/real(R-1, dp)*(s2_vm/real(R, dp) - media_vm*media_vm), 0.0_dp))
  media_ae = s_ae/real(R, dp)
  desv_ae  = sqrt(max(real(R, dp)/real(R-1, dp)*(s2_ae/real(R, dp) - media_ae*media_ae), 0.0_dp))

  ! Cuatro números sin encabezado para la lectura automática.
  open(newunit=u_dat,file='seno.dat',status='replace')
  write(u_dat,'(4es25.16e3)') media_vm,desv_vm,media_ae,desv_ae
  close(u_dat)
  print '(a,2f10.5)', 'Valor medio (media, desviacion): ',media_vm,desv_vm
  print '(a,2f10.5)', 'Acierto y error (media, desviacion): ',media_ae,desv_ae
end program taller5_seno
