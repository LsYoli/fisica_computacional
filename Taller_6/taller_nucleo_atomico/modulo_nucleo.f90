! Taller 6 -- Módulo de la fórmula semiempírica de masa
module modulo_nucleo
  implicit none

  ! --- Constantes globales (solo constantes, R3) ---
  integer, parameter  :: dp  = kind(1.0d0)
  real(dp), parameter :: a_V = 15.8_dp      ! coeficiente de volumen [MeV]
  real(dp), parameter :: a_S = 18.3_dp      ! coeficiente de superficie [MeV]
  real(dp), parameter :: a_C = 0.71_dp      ! coeficiente de Coulomb [MeV]
  real(dp), parameter :: a_A = 92.7_dp      ! coeficiente de asimetría [MeV]
  real(dp), parameter :: M_n = 939.57_dp    ! masa del neutrón [MeV]
  real(dp), parameter :: M_H = 938.78_dp    ! masa del átomo de hidrógeno [MeV]

contains

  ! ------------------------------------------------------------------
  ! termino_volumen: término de volumen, -a_V
  !   Entradas: ninguna;  Salida: término [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_volumen()
    termino_volumen = -a_V
  end function termino_volumen

  ! ------------------------------------------------------------------
  ! termino_superficie: a_S * A^(-1/3)
  !   Entrada: A (nucleones);  Salida: término [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_superficie(A)
    integer, intent(in) :: A
    termino_superficie = a_S*real(A, dp)**(-1.0_dp/3.0_dp)
  end function termino_superficie

  ! ------------------------------------------------------------------
  ! termino_coulomb: a_C * Z^2 * A^(-4/3)
  !   Entradas: Z (protones), A (nucleones);  Salida: término [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_coulomb(Z, A)
    integer, intent(in) :: Z, A
    termino_coulomb = a_C*real(Z, dp)**2*real(A, dp)**(-4.0_dp/3.0_dp)
  end function termino_coulomb

  ! ------------------------------------------------------------------
  ! termino_asimetria: a_A * (Z - A/2)^2 / A^2
  !   Entradas: Z (protones), A (nucleones);  Salida: término [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_asimetria(Z, A)
    integer, intent(in) :: Z, A
    termino_asimetria = a_A*(real(Z, dp) - real(A, dp)/2.0_dp)**2/real(A, dp)**2
  end function termino_asimetria

  ! ------------------------------------------------------------------
  ! energia_enlace: energía de enlace por nucleón E_B(Z,A)
  !   Entradas: Z, A;  Salida: E_B [MeV] (negativa si el núcleo está ligado)
  ! ------------------------------------------------------------------
  real(dp) function energia_enlace(Z, A)
    integer, intent(in) :: Z, A
    energia_enlace = termino_volumen() + termino_superficie(A) &
                   + termino_coulomb(Z, A) + termino_asimetria(Z, A)
  end function energia_enlace

  ! ------------------------------------------------------------------
  ! masa_atomica: M(Z,A) = Z*M_H + (A-Z)*M_n + A*E_B
  !   Entradas: Z, A;  Salida: masa atómica aproximada [MeV]
  ! ------------------------------------------------------------------
  real(dp) function masa_atomica(Z, A)
    integer, intent(in) :: Z, A
    masa_atomica = real(Z, dp)*M_H + real(A - Z, dp)*M_n &
                 + real(A, dp)*energia_enlace(Z, A)
  end function masa_atomica

  ! ------------------------------------------------------------------
  ! Z_estable: Z de máximo enlace (menor E_B) para un A dado
  !   Entrada: A;  Salidas: Z_max, E_max [MeV]
  !   Es subrutina porque entrega dos resultados (sección 3.3).
  ! ------------------------------------------------------------------
  subroutine Z_estable(A, Z_max, E_max)
    integer, intent(in)   :: A
    integer, intent(out)  :: Z_max
    real(dp), intent(out) :: E_max
    integer  :: Z_prueba           ! contador local
    real(dp) :: E_prueba           ! energía local

    Z_max = 1
    E_max = energia_enlace(1, A)
    do Z_prueba = 2, A
       E_prueba = energia_enlace(Z_prueba, A)
       if (E_prueba < E_max) then
          Z_max = Z_prueba
          E_max = E_prueba
       end if
    end do
  end subroutine Z_estable

end module modulo_nucleo
