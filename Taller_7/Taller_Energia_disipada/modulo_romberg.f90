! ============================================================
! Módulo:    modulo_romberg
! Propósito: integración de Romberg con conteo de evaluaciones
!            e integrandos del Taller 7.
! ============================================================
module modulo_romberg
  implicit none
  integer, parameter :: dp = kind(1.0d0)
  real(dp), parameter :: pi = 4*atan(1.0_dp)
  real(dp), parameter :: gamma = 0.5_dp          ! amortiguamiento [1/s]
  real(dp), parameter :: omega = 2*pi            ! frecuencia angular [rad/s]
  real(dp), parameter :: omega0_2 = omega**2 + gamma**2
  integer, parameter :: ID_ENERGIA = 1           ! integrando 2*gamma*v(t)^2
  integer, parameter :: ID_PI = 2                ! integrando 4/(1+x^2)
contains

  ! ----------------------------------------------------------
  ! posicion: x(t) = exp(-gamma t) cos(omega t)
  ! ----------------------------------------------------------
  real(dp) function posicion(t)
    real(dp), intent(in) :: t
    posicion = exp(-gamma*t)*cos(omega*t)
  end function posicion

  ! ----------------------------------------------------------
  ! velocidad: v(t) exacta del oscilador amortiguado
  ! ----------------------------------------------------------
  real(dp) function velocidad(t)
    real(dp), intent(in) :: t
    velocidad = -exp(-gamma*t)*(gamma*cos(omega*t) + omega*sin(omega*t))
  end function velocidad

  ! ----------------------------------------------------------
  ! energia: E(t) = v^2/2 + omega0^2 x^2/2   [J/kg]
  ! ----------------------------------------------------------
  real(dp) function energia(t)
    real(dp), intent(in) :: t
    energia = 0.5_dp*velocidad(t)**2 + 0.5_dp*omega0_2*posicion(t)**2
  end function energia

  ! ----------------------------------------------------------
  ! integrando: elige el integrando según id
  ! Entradas: id (ID_ENERGIA o ID_PI), x
  ! ----------------------------------------------------------
  real(dp) function integrando(id, x)
    integer, intent(in)  :: id
    real(dp), intent(in) :: x
    select case (id)
    case (ID_ENERGIA)
      integrando = 2*gamma*velocidad(x)**2
    case (ID_PI)
      integrando = 4.0_dp/(1.0_dp + x*x)
    case default
      error stop 'integrando: id desconocido'
    end select
  end function integrando

  ! ----------------------------------------------------------
  ! romberg: integración de Romberg de f(id, x) en [a, b]
  ! Entradas: id, a, b, tol, kmax
  ! Salidas:  S(0:kmax,0:kmax) tabla (solo el triángulo 0..k_final),
  !           k_final nivel alcanzado, n_eval evaluaciones de f
  ! ----------------------------------------------------------
  subroutine romberg(id, a, b, tol, kmax, S, k_final, n_eval)
    integer, intent(in)  :: id, kmax
    real(dp), intent(in) :: a, b, tol
    real(dp), allocatable, intent(out) :: S(:,:)
    integer, intent(out) :: k_final, n_eval
    real(dp) :: h, suma
    integer :: k, j, i

    allocate(S(0:kmax, 0:kmax))
    S = 0.0_dp
    h = b - a
    S(0,0) = 0.5_dp*h*(integrando(id, a) + integrando(id, b))
    n_eval = 2
    k_final = 0
    do k = 1, kmax
       h = h/2
       ! puntos nuevos del nivel k: a + (2i-1)h, i = 1..2^(k-1)
       suma = 0.0_dp
       do i = 1, 2**(k-1)
          suma = suma + integrando(id, a + (2*i - 1)*h)
       end do
       n_eval = n_eval + 2**(k-1)
       S(k,0) = 0.5_dp*S(k-1,0) + h*suma
       do j = 1, k
          S(k,j) = (4.0_dp**j*S(k,j-1) - S(k-1,j-1))/(4.0_dp**j - 1.0_dp)
       end do
       k_final = k
       if (abs(S(k,k) - S(k-1,k-1)) < tol) exit
    end do
  end subroutine romberg

end module modulo_romberg
