"""Taller 6 -- Módulo de análisis de los resultados de Fortran."""
import numpy as np
import matplotlib
matplotlib.use("Agg")                      # guarda la imagen sin abrir ventana
import matplotlib.pyplot as plt

# Datos experimentales: (símbolo, Z, A, B/A [MeV]) -- AME2020
EXPERIMENTALES = [
    ("He-4",    2,   4, 7.0739),
    ("C-12",    6,  12, 7.6801),
    ("O-16",    8,  16, 7.9762),
    ("Ca-40",  20,  40, 8.5513),
    ("Fe-56",  26,  56, 8.7903),
    ("Ni-62",  28,  62, 8.7945),
    ("Sn-120", 50, 120, 8.5045),
    ("Pb-208", 82, 208, 7.8675),
    ("U-235",  92, 235, 7.5909),
    ("U-238",  92, 238, 7.5701),
]

def leer_valle(archivo):
    """Lee valle.dat.

    Entrada: nombre del archivo
    Salida:  tupla (A, Z, E_B), cada una una columna (arreglo de NumPy)
    """
    datos = np.loadtxt(archivo)
    return datos[:, 0], datos[:, 1], datos[:, 2]

def nucleo_mas_ligado(A, Z, E_B):
    """Núcleo con menor E_B (mayor enlace por nucleón), con ciclo y condicional.

    Entradas: columnas A, Z, E_B
    Salida:   tupla (A_mejor, Z_mejor, E_mejor)
    """
    A_mejor, Z_mejor, E_mejor = A[0], Z[0], E_B[0]
    for a, z, e in zip(A, Z, E_B):
        if e < E_mejor:
            A_mejor, Z_mejor, E_mejor = a, z, e
    return A_mejor, Z_mejor, E_mejor

def escribir_maximo(archivo, A_mejor, Z_mejor, E_mejor):
    """Escribe el núcleo más ligado con el mismo formato de maximo.dat.

    Entradas: nombre del archivo y los tres valores
    Salida:   ninguna (escribe el archivo)
    """
    with open(archivo, "w") as f:
        f.write(f"{int(A_mejor):6d}{int(Z_mejor):6d}{E_mejor:18.10f}\n")

def graficar_curva(A, E_B, experimentales, archivo):
    """Grafica B/A = -E_B contra A, con los puntos experimentales.

    Entradas: columnas A y E_B, lista de experimentales, nombre de la imagen
    Salida:   ninguna (guarda el PNG)
    """
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.plot(A, -E_B, "-", color="#162A54", label="Modelo (máximo enlace)")
    A_exp = [fila[2] for fila in experimentales]
    BA_exp = [fila[3] for fila in experimentales]
    ax.plot(A_exp, BA_exp, "o", color="#C9972C", label="Experimental (AME2020)")
    ax.set_xlabel("Número de nucleones $A$")
    ax.set_ylabel("Energía de enlace por nucleón $B/A$ [MeV]")
    ax.set_title("Curva de máximo enlace: modelo de la gota líquida")
    ax.legend()
    ax.grid(alpha=0.3)
    fig.tight_layout()
    fig.savefig(archivo, dpi=150)
    plt.close(fig)
