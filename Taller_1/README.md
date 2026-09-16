# Cálculo de Trayectoria de un Proyectil

Programa desarrollado en **Fortran** para calcular la **altura máxima alcanzada por un proyectil** y verificar el resultado mediante casos de prueba conocidos.

## Descripción

El programa permite realizar dos operaciones:

1. **Ejecutar el cálculo:** el usuario ingresa el ángulo de lanzamiento y la velocidad inicial del proyectil. El programa calcula la altura máxima alcanzada.
2. **Realizar una verificación:** se ejecutan tres casos de prueba con resultados esperados y se compara el resultado calculado con el valor esperado utilizando una tolerancia numérica.

El programa utiliza la ecuación:

$$
h_{\max} = \frac{v_0^2\sin^2(\theta)}{2g}
$$

donde:

* \(h_{\max}\) = altura máxima del proyectil, en metros (m).
* \(v_0\) = velocidad inicial, en metros por segundo (m/s).
* \(\theta\) = ángulo de lanzamiento.
* \(g\) = aceleración debido a la gravedad, \(9.8\ m/s^2\).

Como las funciones trigonométricas de Fortran trabajan con **radianes**, el programa convierte el ángulo ingresado en grados mediante:

$$
\theta_{rad} = \theta_{grados}\frac{\pi}{180}
$$

---

## Requisitos

Para compilar el programa se necesita:

* **GNU Fortran (`gfortran`)**
* Una terminal compatible con el sistema operativo.

En Ubuntu, se puede instalar mediante:

```bash
sudo apt install gfortran
```

Para comprobar la instalación:

```bash
gfortran --version
```

---

## Ejecución en Google Colab

El programa también puede ejecutarse utilizando Google Colab.

1. Crear un notebook

Ingresa a Google Colab y crea un nuevo notebook.

2. Instalar GNU Fortran

En una celda de Colab ejecuta:

!apt-get update -qq
!apt-get install -y gfortran

Puedes comprobar que la instalación fue correcta mediante:

!gfortran --version
3. Subir el archivo Fortran

Sube el archivo:

Proyectil.f90

al entorno de Google Colab.

También puedes comprobar que el archivo se encuentra disponible mediante:

!ls
4. Compilar el programa

Una vez que el archivo se encuentre en el entorno de Colab, compílalo mediante:

!gfortran Proyectil.f90 -o proyectil

Este comando toma el código fuente Proyectil.f90 y genera el ejecutable:

proyectil
5. Ejecutar el programa

Para ejecutar el programa:

!./proyectil

El programa mostrará el menú:

Seleccione el número de la opción:
1. Ejecutar el programa
2. Realizar verificación

A partir de ese momento se puede interactuar con el programa normalmente.

## Ejecución en Linux

Si se trabaja directamente desde una terminal de Linux, primero se debe compilar el programa:

gfortran Proyectil.f90 -o proyectil

Después se ejecuta mediante:

./proyectil

El programa mostrará un menú:

Seleccione el número de la opción:
1. Ejecutar el programa
2. Realizar verificación

A partir de ese momento se puede interactuar con el programa normalmente.