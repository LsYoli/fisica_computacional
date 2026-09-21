import numpy as np
import matplotlib.pyplot as plt


def decadimiento_rad(t, NO, lambda_ ):  # Define una función para modelar el decaimiento radiactivo.
    return NO * np.exp(-lambda_ * t)

def calcular_fraccion(t, lambda_):  # Define una función para calcular el tiempo dado una fracción de núcleos restantes.
    return -np.log(t)/lambda_


fracciones = [0.5, 0.25, 0.1]  # Lista de fracciones de núcleos restantes para las cuales se calculará el tiempo correspondiente.

for f in fracciones:  # Recorre cada fracción en la lista.
    tiempo = calcular_fraccion(f, np.log(2)/5)  # Calcula el tiempo necesario para que la fracción de núcleos restantes sea f.
    print(f"Tiempo para que quede {f*100:.0f}% de los núcleos: {tiempo:.2f} años")  # Imprime el resultado con formato.

print("\n-----------------CELDAS DE VERIFICACION-----------------------")

casos_b = [                                        # Lista de (t, fracción_esperada): fracción de N0 que debería quedar en cada instante.
    (0.0, 1.00),                                   # En t=0 debe quedar el 100% de la muestra.
    (5.0, 0.50),                                   # En t = t_1/2 (una vida media) debe quedar el 50%.
    (10.0, 0.25),                                  # En t = 2*t_1/2 (dos vidas medias) debe quedar el 25%.
]

for t, fraccion_esperada in casos_b:               # Recorre cada caso de prueba.
    try:                                           # Evita que un NotImplementedError detenga toda la celda de verificación.
        obtenido = decadimiento_rad(t, 10000, np.log(2)/5) / 10000        # Calcula qué fracción de N0 queda en el instante t.
        ok = abs(obtenido - fraccion_esperada) < 1e-3  # Compara contra la fracción esperada con tolerancia razonable.
        estado = "PASS" if ok else "FAIL"
        print(f"{estado}  t={t:>5.1f} años   fraccion={obtenido:.3f}   esperada={fraccion_esperada:.3f}")
    except NotImplementedError as e:               # Si aún no se ha completado la función, lo informa sin detener la celda.
        print(f"FAIL  t={t:>5.1f} años   ({e})")

N = np.linspace(0, 30, 100)         #Arreglo de tiempo de 0 a 30 

Nt = decadimiento_rad(N, 10000, np.log(2)/5)  # Calcula el número de núcleos restantes en cada instante de tiempo usando la función definida.

plt.plot(N, Nt)  # Grafica el número de núcleos restantes frente al tiempo.
plt.title("Decaimiento radiactivo")  # Añade un título al gráfico
plt.xlabel('años')          # Etiqueta eje x
plt.ylabel('Número de núcleos restantes')  # Etiqueta eje y
plt.grid(True, alpha=0.3)   
plt.plot(1, decadimiento_rad(1, 10000, np.log(2)/5), 'ro', markersize=10)
plt.plot(2, decadimiento_rad(2, 10000, np.log(2)/5), 'ro', markersize=10)
plt.plot(3, decadimiento_rad(3, 10000, np.log(2)/5), 'ro', markersize=10)


plt.show()  # Muestra el gráfico generado.
