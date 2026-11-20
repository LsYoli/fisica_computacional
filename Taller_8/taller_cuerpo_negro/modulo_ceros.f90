! ==============================================================
! modulo_ceros.f90
!
! Ecuación de Wien en forma adimensional:  g(x) = x - n (1 - e^-x) = 0
! El módulo reúne la función, su derivada y tres buscadores de
! raíces. Todos comparten la misma firma de salida:
!    cero       raíz aproximada
!    pasos      iteraciones realizadas
!    convergio  .true. si se cumplió el criterio de parada
! Si unidad_reg es distinta de 0, cada iteración se anota en esa
! unidad con el formato  (método, iteración, valor).
! ==============================================================
module modulo_ceros
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  integer, parameter :: ITER_MAX = 100                    ! tope común a los tres métodos
  integer, parameter :: M_BISECCION = 1, M_NEWTON = 2, M_SECANTE = 3

contains

  ! g(x): su cero positivo es la raíz de Wien; x = 0 también es raíz.
  real(dp) function funcion_wien(x, n_wien)
    real(dp), intent(in) :: x
    integer,  intent(in) :: n_wien      ! 5 para B_lambda, 3 para B_nu
    funcion_wien = x - real(n_wien, dp)*(1.0_dp - exp(-x))
  end function funcion_wien

  ! g'(x) = 1 - n e^-x. Newton la necesita; se escribe a mano para no
  ! derivar numéricamente.
  real(dp) function derivada_wien(x, n_wien)
    real(dp), intent(in) :: x
    integer,  intent(in) :: n_wien
    derivada_wien = 1.0_dp - real(n_wien, dp)*exp(-x)
  end function derivada_wien

  ! --------------------------------------------------------------
  ! Bisección sobre [izq0, der0]. Se detiene cuando la distancia del
  ! punto medio al extremo derecho es <= tolerancia: ese valor es la
  ! cota del error, así que el número de pasos se puede predecir
  ! con log2((der0 - izq0)/tolerancia).
  ! --------------------------------------------------------------
  subroutine metodo_biseccion(n_wien, izq0, der0, tolerancia, cero, pasos, convergio, unidad_reg)
    integer,  intent(in)  :: n_wien, unidad_reg
    real(dp), intent(in)  :: izq0, der0, tolerancia
    real(dp), intent(out) :: cero
    integer,  intent(out) :: pasos
    logical,  intent(out) :: convergio
    real(dp) :: izq, der, medio, g_izq

    izq = izq0
    der = der0
    cero = izq
    pasos = 0
    convergio = .false.

    ! Sin cambio de signo no hay garantía de raíz dentro del intervalo.
    g_izq = funcion_wien(izq, n_wien)
    if (g_izq*funcion_wien(der, n_wien) >= 0.0_dp) then
       print '(a)', 'Bisección: el intervalo no encierra un cambio de signo.'
       return
    end if

    do while (pasos < ITER_MAX)
       pasos = pasos + 1
       medio = 0.5_dp*(izq + der)
       if (unidad_reg /= 0) write(unidad_reg, '(i2,1x,i4,1x,es24.16)') M_BISECCION, pasos, medio
       cero = medio
       if (der - medio <= tolerancia) then
          convergio = .true.
          return
       end if
       ! Se conserva la mitad donde g cambia de signo.
       if (g_izq*funcion_wien(medio, n_wien) <= 0.0_dp) then
          der = medio
       else
          izq = medio
          g_izq = funcion_wien(izq, n_wien)
       end if
    end do
    print '(a,i0,a)', 'Bisección: sin convergencia tras ', ITER_MAX, ' iteraciones.'
  end subroutine metodo_biseccion

  ! --------------------------------------------------------------
  ! Newton-Raphson desde x_ini. El error de la iteración anterior se
  ! estima con el tamaño del paso, por eso se compara |dx| con la
  ! tolerancia.
  ! --------------------------------------------------------------
  subroutine metodo_newton(n_wien, x_ini, tolerancia, cero, pasos, convergio, unidad_reg)
    integer,  intent(in)  :: n_wien, unidad_reg
    real(dp), intent(in)  :: x_ini, tolerancia
    real(dp), intent(out) :: cero
    integer,  intent(out) :: pasos
    logical,  intent(out) :: convergio
    real(dp) :: x_actual, pendiente, dx

    x_actual = x_ini
    cero = x_actual
    pasos = 0
    convergio = .false.

    do while (pasos < ITER_MAX)
       pasos = pasos + 1
       pendiente = derivada_wien(x_actual, n_wien)
       if (pendiente == 0.0_dp) then          ! tangente horizontal: no corta el eje
          print '(a)', 'Newton: derivada nula, se detiene el método.'
          return
       end if
       dx = -funcion_wien(x_actual, n_wien)/pendiente
       x_actual = x_actual + dx
       cero = x_actual
       if (unidad_reg /= 0) write(unidad_reg, '(i2,1x,i4,1x,es24.16)') M_NEWTON, pasos, x_actual
       if (abs(dx) < tolerancia) then
          convergio = .true.
          return
       end if
    end do
    print '(a,i0,a)', 'Newton: sin convergencia tras ', ITER_MAX, ' iteraciones.'
  end subroutine metodo_newton

  ! --------------------------------------------------------------
  ! Secante con dos puntos de arranque. Reemplaza la derivada de
  ! Newton por la pendiente de la recta que une los dos últimos
  ! puntos; cuesta una evaluación de g por paso en lugar de dos.
  ! --------------------------------------------------------------
  subroutine metodo_secante(n_wien, x_prev0, x_act0, tolerancia, cero, pasos, convergio, unidad_reg)
    integer,  intent(in)  :: n_wien, unidad_reg
    real(dp), intent(in)  :: x_prev0, x_act0, tolerancia
    real(dp), intent(out) :: cero
    integer,  intent(out) :: pasos
    logical,  intent(out) :: convergio
    real(dp) :: x_prev, x_act, g_prev, g_act, dx

    x_prev = x_prev0
    x_act = x_act0
    cero = x_act
    pasos = 0
    convergio = .false.
    g_prev = funcion_wien(x_prev, n_wien)

    do while (pasos < ITER_MAX)
       pasos = pasos + 1
       g_act = funcion_wien(x_act, n_wien)
       if (g_act == g_prev) then              ! recta secante horizontal
          print '(a)', 'Secante: denominador nulo, se detiene el método.'
          return
       end if
       dx = -g_act*(x_act - x_prev)/(g_act - g_prev)
       x_prev = x_act
       g_prev = g_act
       x_act = x_act + dx
       cero = x_act
       if (unidad_reg /= 0) write(unidad_reg, '(i2,1x,i4,1x,es24.16)') M_SECANTE, pasos, x_act
       if (abs(dx) < tolerancia) then
          convergio = .true.
          return
       end if
    end do
    print '(a,i0,a)', 'Secante: sin convergencia tras ', ITER_MAX, ' iteraciones.'
  end subroutine metodo_secante

end module modulo_ceros
