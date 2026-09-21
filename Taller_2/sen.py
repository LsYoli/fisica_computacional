import math
from time import time

def suma_seno(x, tol=1e-8, max_iter=200):            # Define una función para aproximar sin(x) mediante su serie de Taylor.
    term = x                                         # Inicializa el primer término de la serie: t_0 = x.
    total = x                                        # Inicializa la suma parcial con el primer término.
    n = 0                                            # Inicializa el índice usado para construir los términos siguientes.

    inicio = time()                            # Marca el tiempo de inicio para medir la duración de la ejecución.

    for i in range(max_iter):                        # Repite como máximo max_iter veces para evitar un ciclo infinito.
        n += 1                                       # Incrementa n antes de calcular el siguiente término de la serie.
        term = -term * (( x**2 )/(( 2 * n ) * (2 * n + 1)))                                 # COMPLETAR: usa la relación recursiva para calcular el nuevo término a partir del anterior.
        total = total + term                         # Añade el nuevo término a la suma parcial.

        if abs(term) < tol * max(1,abs(total)):     # COMPLETAR: escribe el criterio de parada mixto basado en term, tol y total.
            break                                    # Sale del ciclo cuando el último término ya es suficientemente pequeño.

    fin = time()                               # Marca el tiempo de finalización para medir la duración de la ejecución.
    tiempo_ejecucion = fin - inicio  

    return total, i + 1, tiempo_ejecucion  # Devuelve la aproximación calculada y el número de iteraciones realizadas.


def suma_seno_reducida(x, tol=1e-8, max_iter=200):  # Define una versión que primero reduce el argumento antes de evaluar la serie.
    x_reducido = math.remainder(x, 2 * math.pi)  # Reduce x módulo 2*pi a un intervalo centrado aproximadamente en [-pi, pi].
    return suma_seno(x_reducido, tol, max_iter)  # Evalúa la serie usando el argumento reducido y devuelve el resultado.


#===================================================================================

#===================================================================================
print("\n\n-----------------------PUNTO 2-----------------------")

print(f"{'x':>6} {'imax':>6} {'suma':>16} {'error relativo':>16}")  # Imprime el encabezado de una tabla con columnas alineadas.
for x in [0.5, 1.1, 7.2, 9.4, 10.2, 11.1]:  # Recorre varios valores de x para probar el algoritmo.
    approx, iters, tiempo = suma_seno(x)  # Calcula la aproximación de sin(x) y guarda también las iteraciones utilizadas.
    exacto = math.sin(x)  # Calcula el valor de referencia usando la implementación de math.sin.
    error_relativo = abs(approx - exacto) / abs(exacto)  # Calcula el error relativo de la aproximación respecto al valor de referencia.
    print(f"{x:6.2f} {iters:6d} {approx:16.10f} {error_relativo:16.2e}")  # Imprime una fila de la tabla con formato numérico.


#===================================================================================

#===================================================================================
#PUNTO 3
#Sí. Todos los valores de la tabla cumplen con la tolerancia.
#x=9.40 es el caso más ajustado,donde el error relativo (9.10×10−9)
#está muy cerca del límite (10−8), pero aún así lo cumple.
#Esto se debe a la cancelación catastrófica. Para ese valor de x,
#la suma total es muy pequeña (0.0247) en comparación con la magnitud 
#de los términos individuales que se suman. 
#Esto hace que el error relativo se amplifique, aunque el error absoluto 
#siga siendo diminuto. cuando total​ es pequeño, el criterio se vuelve 
#más estricto (usa tol⋅1), lo que ayuda a detectar estos casos.

#===================================================================================

#===================================================================================
print("\n\n------------------------PUNTO 4-----------------------")
approx, iters , tiempo = suma_seno(100.0)  # Aplica directamente la serie de Taylor a un argumento grande, x = 100.
exacto = math.sin(100.0)  # Calcula el seno de referencia con math.sin para poder comparar.
print(f"x=100:  aproximado={approx}   exacto={exacto}   iteraciones={iters}")  # Muestra la aproximación, el valor de referencia y el costo en iteraciones.

#Al evaluar la serie de Taylor para x=100, los términos individuales crecen
#hasta magnitudes enormes (del orden de 10⁴²) antes de decrecer, 
#lo que provoca una pérdida masiva de precisión por redondeo al sumarlos 
#y restarlos. Como el resultado exacto es pequeño (≈−0.5), esos errores 
#absolutos gigantes se amplifican en el resultado final, 
#dando un valor basura de −1.4×10²⁶ en lugar de la respuesta correcta.

def suma_seno_factorial(x, tol=1e-8, max_iter=200):            # Define una función para aproximar sin(x) mediante su serie de Taylor.
    inicio = time()                            # Marca el tiempo de inicio para medir la duración de la ejecución.                                     
    total = x                                        # Inicializa la suma parcial con el primer término.
    n = 1                                           # Inicializa el índice usado para construir los términos siguientes.

    for i in range(max_iter):                                               # Repite como máximo max_iter veces para evitar un ciclo infinito.                                      # Incrementa n antes de calcular el siguiente término de la serie.
        term = (-1) ** n * ((x ** (2 * n +1 )/math.factorial(2 * n + 1)))   # usa la relación factorial para calcular el nuevo término sin necesidad del anterior.
        total = total + term                                                # Añade el nuevo término a la suma parcial.
        n += 1                                                              # Aumenta el indice

        if abs(term) < tol * max(1,abs(total)):     # escribe el criterio de parada mixto basado en term, tol y total.
            break                                    # Sale del ciclo cuando el último término ya es suficientemente pequeño.

    fin = time()                               # Marca el tiempo de finalización para medir la duración de la ejecución.
    tiempo_ejecucion = fin - inicio   
                   # Calcula la duración total de la ejecución en segundos.
    return total, i + 1, tiempo_ejecucion  # Devuelve la aproximación calculada y el número de iteraciones realizadas.


#===================================================================================

#===================================================================================

print("\n\n-----------------------PUNTO 5-----------------------")
print(f"{'x':>6} {'imax iterativo':>16} {'imax factorial':>16} {'suma iterativa':>20} {'suma factorial':>20} {'error rel it':>16} {'error rel fact':>16} {'tiempo it':>12} {'tiempo fact':>12}")  # Imprime el encabezado de una tabla con columnas alineadas.
for x in [0.5, 1.1, 7.2, 9.4, 10.2, 11.1]:  # Recorre varios valores de x para probar el algoritmo.
    approx_ite, iters_ite, tiempo_ite = suma_seno(x)  # Calcula la aproximación de sin(x) y guarda también las iteraciones utilizadas.
    approx_fact, iters_fact, tiempo_fact = suma_seno_factorial(x)  # Calcula la aproximación de sin(x) y guarda también las iteraciones utilizadas.
    exacto = math.sin(x)  # Calcula el valor de referencia usando la implementación de math.sin.
    error_relativo_ite = abs(approx_ite - exacto) / abs(exacto)  # Calcula el error relativo de la aproximación respecto al valor de referencia.
    error_relativo_fact = abs(approx_fact - exacto) / abs(exacto)  # Calcula el error relativo de la aproximación respecto al valor de referencia.
    print(f"{x:>6.2f} {iters_ite:>16d} {iters_fact:>16d} {approx_ite:>20.10f} {approx_fact:>20.10f} {error_relativo_ite:>16.2e} {error_relativo_fact:>16.2e} {tiempo_ite:>12.6f} {tiempo_fact:>12.6f}")# Imprime una fila de la tabla con formato numérico.

print("\n\n-----------------CELDAS DE VERIFICACION-----------------------")
casos_a = [                                        # Lista de (x, valor_esperado, tolerancia) para probar la Parte A.
    (0.5, math.sin(0.5), 1e-8),                    # Caso dentro del rango normal de convergencia rápida.
    (100.0, math.sin(100.0), 1e-6),                # Caso con x grande: solo debe pasar si se usó reducción de argumento.
    (-237.0, math.sin(-237.0), 1e-6),              # Caso con x grande y negativo.
]

for x, esperado, tol in casos_a:                   # Recorre cada caso de prueba uno por uno.
    obtenido, _, tiempo = suma_seno_reducida(x)             # Calcula sin(x) con la función que el estudiante debe haber completado.
    ok = abs(obtenido - esperado) < tol             # Compara contra el valor de referencia dentro de la tolerancia.
    estado = "PASS" if ok else "FAIL"               # Traduce el resultado booleano a texto legible.
    print(f"{estado}  x={x:>8.1f}   obtenido={obtenido: .10f}   esperado={esperado: .10f}")  # Imprime el veredicto de este caso.