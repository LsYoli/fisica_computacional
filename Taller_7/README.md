# Taller 7 — Energía disipada y derivadas de un oscilador amortiguado

Física Computacional (106018C) · Semana 7 · Fortran y Python

Oscilador amortiguado $x(t)=e^{-\gamma t}\cos(\omega t)$ con $\gamma=0.5\ \text{s}^{-1}$ y $\omega=2\pi$ rad/s.
El taller calcula la energía disipada por la fricción con integración de Romberg, deriva las posiciones con diferencias finitas y reutiliza el mismo módulo de Romberg para estimar $\pi$.

## Archivos

| Archivo | Parte | Descripción |
|---|---|---|
| `modulo_romberg.f90` | B y D | Integración de Romberg con conteo de evaluaciones e integrandos ($2\gamma v^2$ y $4/(1+x^2)$) |
| `programa_energia.f90` | B | Energía disipada en [0, 3] s y comparación con $E(0)-E(T)$ |
| `tabla_energia.dat` | B | Tabla de Romberg, una fila por nivel $k$ |
| `resultado_energia.dat` | B | $k_{final}$, evaluaciones, $E_{dis}$, $E(0)-E(T)$, diferencia |
| `derivadas_oscilador.py` | C | Velocidad y aceleración con rebanadas (adelantada, atrasada, central y cinco puntos) |
| `derivadas_oscilador.dat` | C | $t$, $x$, $v$ y $a$ centrales con $\Delta t=0.01$ s (299 puntos interiores) |
| `errores_derivadas.dat` | C | Errores máximos de cada fórmula para $\Delta t=0.01$ y $0.005$ s |
| `derivadas_oscilador.png` | C | $v$ y $a$ numéricas frente a las exactas |
| `programa_pi.f90` | D | $\pi=\int_0^1 4/(1+x^2)\,dx$ con el mismo módulo, sin modificarlo |
| `resultado_pi.dat` | D | $k_{final}$, evaluaciones, valor de $\pi$ y error |
| `reporte_taller7.tex` | — | Reporte de una página |

## Cómo ejecutar

Desde esta carpeta:

```bash
# Parte B: energía disipada
gfortran -fcheck=bounds -o programa_energia modulo_romberg.f90 programa_energia.f90
./programa_energia

# Parte C: derivadas
python derivadas_oscilador.py

# Parte D: pi
gfortran -fcheck=bounds -o programa_pi modulo_romberg.f90 programa_pi.f90
./programa_pi
```

Requiere `gfortran`, Python 3 y NumPy/Matplotlib. No se usan funciones de biblioteca que integren o deriven.

## Resultados

| Caso | Valor obtenido | Referencia | Error |
|---|---|---|---|
| $E_{dis}$ (tol $10^{-6}$, 257 evaluaciones, $k=8$) | 18.9940046974 J/kg | $E(0)-E(T)=18.9940046969$ | $4.5\times10^{-10}$ |
| $\pi$ (tol $10^{-5}$, 17 evaluaciones, $k=4$) | 3.141592665 | 3.141592654 | $1.2\times10^{-8}$ |

Errores máximos de las derivadas y razón al reducir $\Delta t$ de 0.01 a 0.005 s:

| Fórmula | Error ($\Delta t=0.01$) | Razón | Orden |
|---|---|---|---|
| $v$ adelantada | $1.95\times10^{-1}$ | 1.99 | 1 |
| $v$ atrasada | $1.94\times10^{-1}$ | 1.99 | 1 |
| $v$ central | $3.77\times10^{-3}$ | 4.00 | 2 |
| $v$ cinco puntos | $3.03\times10^{-6}$ | 15.99 | 4 |
| $a$ central | $1.21\times10^{-2}$ | 3.94 | 2 |

## Verificación

La celda de verificación del notebook (`Arreglos_int_deriv_ESTUDIANTES_7.ipynb`) da **4 de 4 PASS**.
Cada `.dat` debe ser más reciente que el código que lo genera: si se modifica un programa, hay que volver a ejecutarlo antes de verificar.
