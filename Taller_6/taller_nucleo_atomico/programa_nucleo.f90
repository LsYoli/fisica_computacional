! Taller 6 -- Programa principal: escribe nucleos.dat, valle.dat y maximo.dat
program programa_nucleo
  use modulo_nucleo
  implicit none

  integer  :: A, Z, u_nuc, u_valle, u_max
  integer  :: A_mejor, Z_mejor
  real(dp) :: E_B, E_mejor

  ! Los 8 núclidos, en el orden del enunciado: Pu-244, Ge-70, Hf-179, Ar-38,
  ! Fe-56, Ca-40, U-235, U-238 (se guardan como constantes, sin arreglos)
  ! --- nucleos.dat ---
  open(newunit=u_nuc, file='nucleos.dat', status='replace')
  call escribe_fila(u_nuc, 94, 244)
  call escribe_fila(u_nuc, 32,  70)
  call escribe_fila(u_nuc, 72, 179)
  call escribe_fila(u_nuc, 18,  38)
  call escribe_fila(u_nuc, 26,  56)
  call escribe_fila(u_nuc, 20,  40)
  call escribe_fila(u_nuc, 92, 235)
  call escribe_fila(u_nuc, 92, 238)
  close(u_nuc)

  ! --- valle.dat y búsqueda del núcleo más ligado ---
  open(newunit=u_valle, file='valle.dat', status='replace')
  E_mejor = 0.0_dp                  ! todo E_B de la curva es negativo
  A_mejor = 0
  Z_mejor = 0
  do A = 4, 260
     call Z_estable(A, Z, E_B)
     write(u_valle, '(2i6, f18.10)') A, Z, E_B
     if (E_B < E_mejor) then
        A_mejor = A
        Z_mejor = Z
        E_mejor = E_B
     end if
  end do
  close(u_valle)

  ! --- maximo.dat ---
  open(newunit=u_max, file='maximo.dat', status='replace')
  write(u_max, '(2i6, f18.10)') A_mejor, Z_mejor, E_mejor
  close(u_max)

  print '(a, i4, a, i3, a, f12.8, a)', 'Núcleo más ligado: A =', A_mejor, &
        '  Z =', Z_mejor, '  E_B =', E_mejor, ' MeV'

contains

  ! ------------------------------------------------------------------
  ! escribe_fila: escribe una fila de nucleos.dat
  !   Entradas: unidad (unidad del archivo), Z_n, A_n
  !   Salida:   ninguna; escribe Z, A, los cuatro términos, E_B y M
  !   Es subrutina porque realiza una acción (escribir un archivo).
  ! ------------------------------------------------------------------
  subroutine escribe_fila(unidad, Z_n, A_n)
    integer, intent(in) :: unidad, Z_n, A_n
    write(unidad, '(2i6, 5f18.10, f18.6)') Z_n, A_n, &
          termino_volumen(), termino_superficie(A_n), &
          termino_coulomb(Z_n, A_n), termino_asimetria(Z_n, A_n), &
          energia_enlace(Z_n, A_n), masa_atomica(Z_n, A_n)
  end subroutine escribe_fila

end program programa_nucleo
