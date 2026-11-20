# Taller 8: la radiación de cuerpo negro

Física Computacional (106018C) · Diego Fernando Marín Martínez

Constante de Wien, constante de Stefan-Boltzmann y máximo del espectro solar a partir de la ley de Planck, con Fortran y Python en doble precisión.

## Contenido

```
Taller_8/
├── TALLER_8.ipynb          Notebook con el código, las respuestas y la celda de verificación (5 de 5 PASS)
├── INFORME_TALLER8.pdf     Reporte de una página
└── taller_cuerpo_negro/
    ├── modulo_ceros.f90        Función de Wien, derivada, bisección, Newton y secante
    ├── programa_wien.f90       Calcula x5, x3 y la constante de Wien
    ├── modulo_romberg.f90      Romberg del Taller 7 con el integrando de cuerpo negro
    ├── programa_sigma.f90      Constante de Stefan-Boltzmann
    ├── maximo_espectro.py      Máximo del espectro solar en cuatro mallas
    ├── resultado_wien.dat
    ├── iteraciones_wien.dat
    ├── constante_wien.dat
    ├── resultado_sigma.dat
    ├── maximo_espectro.dat
    └── espectro_solar.png
```

## Cómo ejecutar

Desde la carpeta `taller_cuerpo_negro`:

```bash
# Parte B: constante de Wien
gfortran -fcheck=bounds -o programa_wien modulo_ceros.f90 programa_wien.f90 && ./programa_wien

# Parte C: constante de Stefan-Boltzmann
gfortran -fcheck=bounds -o programa_sigma modulo_romberg.f90 programa_sigma.f90 && ./programa_sigma

# Parte D: espectro solar (requiere numpy, scipy y matplotlib)
python maximo_espectro.py
```

La Parte D lee `constante_wien.dat`, por lo que se ejecuta después de la Parte B.

## Resultados principales

| Cantidad | Valor obtenido | Referencia |
|---|---|---|
| Raíz $x_5$ (Newton, 4 iteraciones) | 4.965114231744 | 4.965114231744 |
| Raíz $x_3$ (Newton, 5 iteraciones) | 2.821439372122 | 2.821439372122 |
| Constante de Wien $b$ | 2.897771955 × 10⁻³ m K | 2.897771955 × 10⁻³ m K |
| Constante de Stefan-Boltzmann $\sigma$ | 5.670374419 × 10⁻⁸ W m⁻² K⁻⁴ | 5.670374419 × 10⁻⁸ W m⁻² K⁻⁴ |
| $\lambda_{\max}$ del Sol ($T$ = 5772 K) | 502.04 nm | 502.04 nm |

Iteraciones con $n = 5$: bisección 37, Newton 4, secante 5.

## Notas

- Newton desde $x_0 = 0.5$ converge a la raíz trivial $x = 0$.
- Romberg en $[0, 100]$ sin cambio de variable se detiene en el nivel 1 con un valor erróneo (≈ 1.6 × 10⁻¹⁵ en lugar de 6.494). Con el cambio $x = t/(1-t)$ la integral converge con error de 2.7 × 10⁻¹³.
- El máximo del espectro en frecuencia cae en 883 nm, distinto del máximo en longitud de onda (502 nm).
