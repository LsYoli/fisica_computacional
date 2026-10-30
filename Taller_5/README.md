# Taller 5 — Cálculo de π y convergencia (Monte Carlo en Fortran)

**Curso:** Física Computacional (106018C)
**Estudiante:** Diego Fernando Marín Martínez
**Lenguaje:** Fortran 2008 (gfortran), con gráficas y verificación en Python

## Descripción

Se estima π por el método de acierto y error y se mide cómo disminuye el error estadístico al aumentar el número de puntos N. Además, se compara el cálculo de la integral de sin(x) en [0, π/2] (valor exacto = 1) por dos métodos, y se analiza el efecto de un generador de números aleatorios deficiente (LCG 57, 1, 256) sobre la estimación de π.

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `TALLER5.ipynb` | Notebook de Colab con todo el taller: los tres programas en Fortran, sus resultados, la gráfica de convergencia, la interpretación y la verificación PASS/FAIL |
| `informe.pdf` | Informe de una página |
| `diagrama_flujo.png` | Diagrama de flujo de la Parte C (LCG) |

Los programas en Fortran no están como archivos separados: se escriben desde el notebook con `%%writefile` y se compilan en la propia sesión de Colab. Los archivos de datos (`.dat`) y la gráfica (`convergencia_pi.png`) se generan al ejecutar el notebook.

## Métodos

- **Acierto y error:** se lanzan N puntos uniformes en [-1, 1)²; la fracción que cae dentro del círculo unitario vale π/4, así que π ≈ 4·N_dentro/N.
- **Valor medio:** I ≈ (b − a)/N · Σ f(xᵢ), con xᵢ uniformes en [a, b).
- **Error estadístico:** σ ≈ 1.642/√N para π; la desviación se mide repitiendo el cálculo con semillas distintas.
- **LCG:** r(i+1) = (57·r(i) + 1) mod 256, con semilla r = 10; cada punto usa dos números consecutivos.

## Resultados

| Caso | Valor obtenido | Referencia |
|---|---|---|
| π, `random_number` (N = 10⁷, media de 20 corridas) | 3.141530 | 3.141593 |
| Pendiente de log10(s) vs log10(N) | −0.5079 | −0.5 |
| ∫ sin x dx, valor medio (s = 0.0153) | 0.99973 | 1 |
| ∫ sin x dx, acierto y error (s = 0.0246) | 1.00009 | 1 |
| π, LCG (N = 10⁷) | 3.093750 | 3.141593 |

## Cómo ejecutar

1. Abrir `TALLER5.ipynb` en Google Colab.
2. Ejecutar las celdas en orden: cada programa tiene una celda `%%writefile` (guarda el `.f90`) y una celda de compilación y ejecución con `gfortran -std=f2008 -O2 -fcheck=all`.
3. Ejecutar la celda final de verificación PASS/FAIL.

El caso N = 10⁷ de la Parte A tarda unos segundos.
