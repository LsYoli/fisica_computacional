program ajuste_pendulo
  use iso_fortran_env, only: real64, iostat_end                               !Precision y fin del archivo
  implicit none                                                               !Evita variables implícitas

  integer :: unidad, unidad_salida, estado, id, n, n_osc                      !Control del archivo y contador
  real(real64) :: longitud_cm, angulo_deg, tiempo_s, periodo_s                !Datos leídos del archivo
  real(real64) :: x, y, y_media, y_ajustada                                   !Variables del ajuste: x = L, y = T^2
  real(real64) :: sx, sy, sxx, sxy, den, a, b, r2, g, ss_res, ss_tot          !Sumas y parámetros
  real(real64), parameter :: pi = 3.14159265358979323846264338327950288_real64  !constante pi
  real(real64), parameter :: tol = 1.0e-12_real64                             !Tolerancia para detectar valores nulos

  ! Lectura del archivo
  open(newunit=unidad, file='pendulo_limpio.dat', status='old', &
       action='read', iostat=estado)
  if (estado /= 0) then                                                       !el archivo no existe o no se pudo abrir
    print *, 'ERROR: no se pudo abrir pendulo_limpio.dat (iostat =', estado, ')'
    stop 1
  end if
  print *, 'Archivo pendulo_limpio.dat abierto correctamente.'

  ! Inicializa el contador y los acumuladores antes de leer
  n   = 0
  sx  = 0.0_real64
  sy  = 0.0_real64
  sxx = 0.0_real64
  sxy = 0.0_real64

  do
    read(unidad, *, iostat=estado) id, longitud_cm, angulo_deg, n_osc, tiempo_s

    if (estado == iostat_end) exit                                            !fin normal del archivo
    if (estado /= 0) then                                                     !fila con formato incorrecto
      print *, 'ERROR: fila ilegible en la lectura (iostat =', estado, ')'
      close(unidad)
      stop 2
    end if
    if (n_osc <= 0) then                                                      !evita dividir entre cero
      print *, 'ERROR: numero de oscilaciones no valido en la medicion', id
      close(unidad)
      stop 2
    end if

    x = longitud_cm / 100.0_real64                                            ! longitud en metros
    periodo_s = tiempo_s / real(n_osc, real64)                                ! Período de una oscilación
    y = periodo_s*periodo_s                                                   ! Período al cuadrado
    n = n + 1                                                                 ! Cuenta la fila aceptada

    sx  = sx  + x                                 ! Acumula longitud_m
    sy  = sy  + y                                 ! Acumula periodo_s^2
    sxx = sxx + x*x                               ! Acumula longitud_m^2
    sxy = sxy + x*y                               ! Acumula longitud_m*periodo_s^2
  end do

  ! Validaciones: menos de dos datos y denominador nulo
  if (n < 2) then
    print *, 'ERROR: se necesitan al menos 2 datos; se leyeron', n
    close(unidad)
    stop 3
  end if

  den = real(n, real64)*sxx - sx*sx
  if (abs(den) < tol) then
    print *, 'ERROR: denominador nulo (todas las longitudes son iguales)'
    close(unidad)
    stop 4
  end if

  ! Usa las sumas para calcular la recta  T^2 = a*L + b  (a pendiente, b intercepto)
  a = (real(n, real64)*sxy - sx*sy) / den
  b = (sy - a*sx) / real(n, real64)

  ! T = 2*pi*sqrt(L/g)  ->  T^2 = (4*pi^2/g)*L  ->  a = 4*pi^2/g
  if (abs(a) < tol) then
    print *, 'ERROR: pendiente nula, no se puede estimar g'
    close(unidad)
    stop 5
  end if
  g = 4.0_real64*pi**2 / a

  ! Segunda lectura del archivo para calcular R^2 (correlación)
  ! R^2 = 1 - SSres/SStot
  rewind(unidad)                                                              !vuelve al inicio del archivo
  y_media = sy / real(n, real64)                                              !promedio de T^2
  ss_res = 0.0_real64                                                         !suma de residuos al cuadrado
  ss_tot = 0.0_real64                                                         !variación total de T^2
  do
    read(unidad, *, iostat=estado) id, longitud_cm, angulo_deg, n_osc, tiempo_s
    if (estado /= 0) exit                                                     !fin del archivo
    x = longitud_cm / 100.0_real64
    periodo_s = tiempo_s / real(n_osc, real64)
    y = periodo_s*periodo_s
    y_ajustada = a*x + b                                                      !T^2 según la recta
    ss_res = ss_res + (y - y_ajustada)**2
    ss_tot = ss_tot + (y - y_media)**2
  end do
  close(unidad)

  if (ss_tot < tol) then
    print *, 'ERROR: T^2 no varia; R^2 no esta definido'
    stop 6
  end if
  r2 = 1.0_real64 - ss_res/ss_tot

  print '(A,I0)',          ' N  = ', n
  print '(A,F12.8,A)',    ' a  = ', a,  ' s^2/m   (pendiente)'
  print '(A,F12.8,A)',    ' b  = ', b,  ' s^2     (intercepto)'
  print '(A,F12.8,A)',     ' R2 = ', r2, '         (calidad del ajuste)'
  print '(A,F12.6,A)',     ' g  = ', g,  ' m/s^2'


  open(newunit=unidad_salida, file='resultados_ajuste.dat', &
       status='replace', action='write')
  write(unidad_salida, *) n, a, b, r2, g
  close(unidad_salida)

end program ajuste_pendulo
