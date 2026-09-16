program calcular_trayectoria_proyectil

    implicit none

    real :: v0                 ! velocidad inicial en m/s
    real :: angulo_grados      ! ángulo de lanzamiento en grados
    real :: angulo_rad         ! ángulo de lanzamiento en radianes
    real :: h_max              ! altura máxima en m

    real, parameter :: g = 9.8              ! aceleración debida a la gravedad en m/s^2
    real, parameter :: pi = 3.14159265      ! valor de pi

    integer :: opcion


    print *, "Seleccione el número de la opción:"
    print *, "1. Ejecutar el programa"
    print *, "2. Realizar verificación"
    read *, opcion


    if (opcion == 1) then

        print *, "Ingrese el ángulo de lanzamiento del proyectil (grados):"
        read *, angulo_grados

        print *, "Ingrese la velocidad inicial (m/s):"
        read *, v0

        ! Convertir el ángulo de grados a radianes
        angulo_rad = angulo_grados * (pi / 180.0)

        print *, "Su ángulo en radianes es: ", angulo_rad

        ! Calcular la altura máxima
        h_max = (v0**2 * sin(angulo_rad)**2) / (2.0 * g)

        print *, "La altura máxima del proyectil es: ", h_max, " m"


    else if (opcion == 2) then

        ! ==========================================
        ! CELDA DE VERIFICACION
        ! ==========================================

        print *
        print *, "=== Verificacion ==="

        print *,"       Angulo", "     Velocidad", "        Esperado", "        Calculado", "       Resultado"
        print *, "---------------------------------------------------------------------------------------"

        call verificar(90.0, 9.8, 4.9000)
        call verificar(45.0, 20.0, 10.2041)
        call verificar(30.0, 20.0, 5.1020)


    else

        print *, "Opción no válida. Por favor, seleccione 1 o 2."

    end if


contains

   subroutine verificar(angulo_grados, v0, esperado)

        real, intent(in) :: angulo_grados
        real, intent(in) :: v0              
        real, intent(in) :: esperado         !altura máxima esperada en m

        real :: calculado  !altura máxima calculada en m
        real, parameter :: tolerancia = 0.0001


        calculado = (v0 * sin(angulo_grados * pi / 180.0))**2.0 / (2.0 * g)


        if (abs(calculado - esperado) < tolerancia) then

            print *, angulo_grados, v0, esperado, calculado, "PASS"

        else

            print *, angulo_grados, v0, esperado, calculado, "FAIL"

        end if

    end subroutine verificar


end program calcular_trayectoria_proyectil