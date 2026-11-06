# Taller 6: Fórmula semiempírica de masa atómica

Física Computacional (106018C), Semana 6.
Autor: Diego Fernando Marín Martínez.

## Descripción

Cálculo de la energía de enlace por nucleón $E_B(Z,A)$ y de la masa atómica aproximada $M(Z,A)$ con el modelo de la gota líquida (Bethe–Weizsäcker), con cuatro términos: volumen, superficie, Coulomb y asimetría.

El cálculo se hace en Fortran (módulo, funciones y una subrutina) y el análisis, en Python (lectura de resultados, búsqueda del núcleo más ligado y gráfica).

## Contenido de la carpeta

| Archivo o carpeta | Descripción |
|---|---|
| `taller6.ipynb` | Notebook del taller, ejecutado de principio a fin, con el pseudocódigo marco (B.1), las respuestas de la sección E y la verificación (4/4 PASS). |
| `informe_taller6.pdf` | Reporte de una página. |
| `diagramaFlujo_programaPrincipal.png` | Diagrama de flujo del programa principal. |
| `diagramaFlujo_subrutinaZestable.png` | Diagrama de flujo de la subrutina `Z_estable`. |
| `taller_nucleo_atomico/` | Código fuente y resultados (detalle abajo). |

### Carpeta `taller_nucleo_atomico/`

| Archivo | Descripción |
|---|---|
| `modulo_nucleo.f90` | Módulo con las constantes (`parameter`), las funciones de los cuatro términos, `energia_enlace`, `masa_atomica` y la subrutina `Z_estable`. |
| `programa_nucleo.f90` | Programa principal: escribe `nucleos.dat`, `valle.dat` y `maximo.dat`. |
| `analisis_nucleo.py` | Módulo de Python: lee `valle.dat`, encuentra el núcleo más ligado, escribe `maximo_python.dat` y grafica la curva. |
| `nucleos.dat` | Ocho núclidos: Z, A, cuatro términos, E_B y M. |
| `valle.dat` | Para cada A = 4, ..., 260: A, Z de máximo enlace y su E_B. |
| `maximo.dat` | Núcleo más ligado según Fortran. |
| `maximo_python.dat` | Núcleo más ligado según Python (mismo formato que `maximo.dat`). |
| `curva_enlace.png` | Gráfica de B/A = −E_B contra A, con los diez puntos experimentales (AME2020). |

## Cómo ejecutarlo

Desde la carpeta `taller_nucleo_atomico/`, el módulo se compila antes que el programa que lo usa:

```bash
gfortran -Wall -Wextra modulo_nucleo.f90 programa_nucleo.f90 -o programa_nucleo
./programa_nucleo
```

Después, el análisis en Python se ejecuta desde el notebook (celdas C.3 y C.4), que importa `analisis_nucleo.py`.

La forma más simple es abrir `taller6.ipynb` en Google Colab y ejecutar todas las celdas en orden (reiniciar sesión y ejecutar todo).

## Resultado principal

El núcleo de mayor enlace por nucleón del modelo es el de **A = 65, Z = 29**, con **E_B = −8.69506906 MeV**. Fortran y Python entregan el mismo resultado.

Convención de signos: E_B < 0 indica núcleo ligado, y B/A = −E_B es el valor positivo de las tablas experimentales.

## Notas de diseño

- Cada término del modelo es una función; `energia_enlace` usa las cuatro, y `masa_atomica` usa `energia_enlace`.
- `Z_estable` es una subrutina porque entrega dos resultados (Z y E_B), según la regla de diseño de la sección 3.3 del notebook.
- Todos los argumentos llevan `intent` y todos los reales son `real(dp)`.
- Las potencias A^(−1/3) y A^(−4/3) se calculan con exponentes reales y conversión explícita de A y Z, para evitar la división entera.

## Referencia

O. Zubairi y F. Weber, *Introduction to Computational Physics for Undergraduates*, 2.ª ed., IOP, 2024, problema 7.2.
