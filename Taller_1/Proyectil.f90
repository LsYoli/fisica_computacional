program calcular_trayectoria_proyectil
    implicit none
    
    real :: v0 !(velocidad inicial en m/s)
    real :: angulo_grados !(ángulo de lanzamiento en grados)
    real :: angulo_rad !(ángulo de lanzamiento en radianes)
    real :: h_max !(altura máxima en m)
    real, parameter :: g = 9.8 !(aceleración debido a la gravedad en m/s^2)

    print *, "Ingrese la rapidez inicial del proyectil (m/s)"
    read *, v0

    print *, "ingrese el ángulo de lanzamiento del proyectil (grados)"
    read *, angulo_grados

    ! Convertir el ángulo de grados a radianes
    angulo_rad = angulo_grados * (3.14159 / 180.0)

    print *, "Su ángulo en radianes es: ", angulo_rad

    ! Calcular la altura máxima
    h_max = (v0**2 * sin(angulo_rad)**2.0) / (2*g)

    print *, "La altura máxima del proyectil es: ", h_max, " m"

end program calcular_trayectoria_proyectil
