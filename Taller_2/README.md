# Física Computacional (106018C) — Talleres en Python

Este README documenta dos scripts independientes: el de **decaimiento radiactivo** (vectorizado con NumPy) y el de **aproximación de sin(x) con series de Taylor**.

## Requisitos

- Python 3.x
- `numpy`
- `matplotlib`
- `math` y `time` (incluidos en la librería estándar)

Instalación de dependencias externas:
```bash
pip install numpy matplotlib
```

---

## 1. Decaimiento radiactivo (`decadimientoRad.py`)

Modela el decaimiento de una muestra de $N_0 = 10\,000$ núcleos con vida media $t_{1/2}=5$ años, usando $N(t) = N_0 e^{-\lambda t}$, con $\lambda = \ln(2)/t_{1/2}$.

### Funciones

| Función | Descripción |
|---|---|
| `decadimiento_rad(t, N0, lambda_)` | Calcula $N(t)$ para un tiempo o arreglo de tiempos. |
| `calcular_fraccion(f, lambda_)` | Devuelve el tiempo necesario para que quede una fracción `f` de la muestra (invierte la exponencial). |

### Qué hace al ejecutarse

1. Calcula el tiempo en que queda el 50 %, 25 % y 10 % de la muestra.
2. Corre una celda de verificación (PASS/FAIL) comparando la fracción remanente en $t=0,5,10$ años contra los valores esperados (1.00, 0.50, 0.25).
3. Genera un arreglo de tiempos de 0 a 30 años con `numpy.linspace` y calcula $N(t)$ de forma **vectorizada** (sin ciclo `for`).
4. Grafica $N(t)$ vs. tiempo con título, etiquetas de ejes y cuadrícula, y marca en rojo los puntos correspondientes a una, dos y tres vidas medias.

### Ejecución
```bash
python decadimientoRad.py
```
Muestra los resultados en consola y abre una ventana con la gráfica.

---

## 2. Aproximación de sin(x) por series de Taylor (`sen.py`)

Compara distintas formas de aproximar $\sin(x)$ mediante la serie de Taylor, evaluando precisión, número de iteraciones y tiempo de ejecución.

### Funciones

| Función | Descripción |
|---|---|
| `suma_seno(x, tol, max_iter)` | Aproxima $\sin(x)$ acumulando términos de la serie mediante la **relación recursiva** $t_n = -t_{n-1}\cdot \dfrac{x^2}{2n(2n+1)}$. Se detiene cuando `abs(term) < tol * max(1, abs(total))` (criterio de parada mixto: absoluto para sumas pequeñas, relativo para sumas grandes). |
| `suma_seno_reducida(x, tol, max_iter)` | Reduce primero `x` módulo $2\pi$ con `math.remainder` (a un intervalo cercano a $[-\pi,\pi]$) y luego llama a `suma_seno` sobre el argumento reducido. |
| `suma_seno_factorial(x, tol, max_iter)` | Aproxima $\sin(x)$ calculando cada término de forma **directa** con `math.factorial`, sin depender del término anterior. |

### Qué hace al ejecutarse

- **Punto 2:** Evalúa `suma_seno` para varios valores de `x` (0.5 a 11.1) y compara contra `math.sin`, imprimiendo iteraciones y error relativo.
- **Punto 3** *(análisis, en comentarios del código)*: todos los casos cumplen la tolerancia; `x=9.4` es el más ajustado por cancelación catastrófica (la suma total es pequeña frente a la magnitud de los términos individuales).
- **Punto 4:** Evalúa la serie sin reducir el argumento en `x=100`, mostrando cómo los términos crecen hasta magnitudes enormes (~$10^{42}$) y la pérdida de precisión por redondeo produce un resultado sin sentido ($\approx -1.4\times10^{26}$ en vez de $\approx -0.5$).
- **Punto 5:** Compara `suma_seno` (recursiva) vs. `suma_seno_factorial` (factorial directo) en iteraciones, error relativo y tiempo de ejecución para los mismos valores de `x`.
- **Celdas de verificación (Parte A):** Prueba `suma_seno_reducida` con `x=0.5`, `x=100.0` y `x=-237.0`, casos que solo pasan si se aplicó correctamente la reducción de argumento antes de sumar la serie.

### Ejecución
```bash
python sen.py
```
Imprime en consola las tablas de resultados de cada punto y el veredicto PASS/FAIL de la verificación.

---

## Notas generales

- Ambos scripts usan un **criterio de parada mixto** (`tol * max(1, abs(total))`) para evitar sensibilidad excesiva cuando la suma acumulada es pequeña.
- El script de la serie de Taylor ilustra el problema clásico de **cancelación catastrófica** y la importancia de la **reducción de argumento** antes de sumar series alternantes con `x` grande.
