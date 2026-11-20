"""Parte D del Taller 8: máximo del espectro solar.

El Sol se modela como cuerpo negro a 5772 K. Se muestrea la radiancia
espectral en mallas uniformes de 100 a 3000 nm y, para cada paso, se
localiza el máximo con tres estrategias de costo creciente:

    A. el mayor valor del arreglo (limitado por el paso de la malla),
    B. el cero de un spline ajustado a la derivada central,
    C. el cero de la derivada de un spline ajustado al espectro.

Cada resultado se compara con lambda_max = b/T, con b leído del
archivo que escribió la Parte B.
Salidas: maximo_espectro.dat y espectro_solar.png.
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")                      # sin ventana: solo se guarda la figura
import matplotlib.pyplot as plt
from scipy.interpolate import CubicSpline

# Constantes del SI (valores exactos)
H_PLANCK = 6.62607015e-34       # [J s]
C_LUZ = 299792458.0             # [m/s]
K_BOLTZMANN = 1.380649e-23      # [J/K]

T_SOL = 5772.0                  # [K]
LAMBDA_MIN, LAMBDA_MAX = 100.0, 3000.0          # [nm]
PASOS_NM = (100.0, 50.0, 25.0, 12.5)            # orden exigido en el .dat
PASO_FIGURA = 25.0


def radiancia_espectral(lam_nm):
    """Ley de Planck B_lambda(lambda, T_SOL) en W m^-2 sr^-1 m^-1.

    Se usa expm1 (e^y - 1) porque conserva precisión cuando el
    exponente es pequeño, es decir, para longitudes de onda largas.
    """
    lam = lam_nm*1e-9                                   # nm -> m
    exponente = H_PLANCK*C_LUZ/(lam*K_BOLTZMANN*T_SOL)
    return 2*H_PLANCK*C_LUZ**2/lam**5/np.expm1(exponente)


def diferencia_central(valores, paso):
    """Derivada central en los puntos interiores: (y[i+1] - y[i-1])/(2 paso).

    Devuelve dos elementos menos que la entrada, porque los extremos
    de la malla no tienen vecino a ambos lados.
    """
    return (valores[2:] - valores[:-2])/(2*paso)


def maximo_del_spline(spline_derivada, lam_arreglo):
    """Elige el máximo de entre los ceros de una derivada ya ajustada.

    Un máximo tiene segunda derivada negativa. Si una malla gruesa hace
    oscilar el spline y deja varios, se toma el más cercano al máximo
    del arreglo (lam_arreglo), que ya está cerca del correcto.
    """
    ceros = spline_derivada.roots(extrapolate=False)
    ceros = ceros[np.isfinite(ceros)]
    ceros = ceros[spline_derivada(ceros, 1) < 0]
    if ceros.size == 0:
        raise ValueError("el spline no tiene ningún máximo")
    return ceros[np.argmin(np.abs(ceros - lam_arreglo))]


def estimar_maximos(paso):
    """Construye la malla de un paso dado y devuelve (lam, B, A, B_, C)."""
    lam = np.arange(LAMBDA_MIN, LAMBDA_MAX + paso/2, paso)
    B = radiancia_espectral(lam)

    est_a = lam[np.argmax(B)]

    derivada = diferencia_central(B, paso)
    est_b = maximo_del_spline(CubicSpline(lam[1:-1], derivada), est_a)

    est_c = maximo_del_spline(CubicSpline(lam, B).derivative(), est_a)
    return lam, B, est_a, est_b, est_c


def graficar(lam, B, lam_wien, lam_frec, ruta):
    """Espectro de la malla elegida con los dos máximos marcados."""
    fig, ax = plt.subplots(figsize=(7.5, 4.2))
    ax.fill_between(lam, B*1e-12, color="#C9D3E8", alpha=0.6)
    ax.plot(lam, B*1e-12, color="#162A54", lw=1.6,
            label=f"$B_\\lambda$ (malla de {PASO_FIGURA:g} nm)")
    ax.axvline(lam_wien, color="#B02A20", lw=1.4,
               label=f"máximo en $\\lambda$: {lam_wien:.0f} nm")
    ax.axvline(lam_frec, color="#2E7D32", lw=1.4, ls="--",
               label=f"máximo en frecuencia: {lam_frec:.0f} nm")
    ax.set_xlim(LAMBDA_MIN, LAMBDA_MAX)
    ax.set_ylim(bottom=0)
    ax.set_xlabel("longitud de onda $\\lambda$ [nm]")
    ax.set_ylabel("$B_\\lambda$  [$10^{12}$ W m$^{-2}$ sr$^{-1}$ m$^{-1}$]")
    ax.set_title(f"Radiación de cuerpo negro del Sol, $T = {T_SOL:.0f}$ K")
    ax.legend(loc="upper right")
    fig.tight_layout()
    fig.savefig(ruta, dpi=150)
    plt.close(fig)


def main():
    # Parte B: x5, x3 y b [m K]
    _, x3, b_wien = np.loadtxt("constante_wien.dat")
    lam_ref = b_wien/T_SOL*1e9                         # lambda_max de referencia [nm]
    lam_frec = H_PLANCK*C_LUZ/(K_BOLTZMANN*T_SOL*x3)*1e9   # máximo de B_nu, en nm

    errores = np.zeros((len(PASOS_NM), 4))
    for i, paso in enumerate(PASOS_NM):
        _, _, est_a, est_b, est_c = estimar_maximos(paso)
        errores[i] = [paso, abs(est_a - lam_ref), abs(est_b - lam_ref), abs(est_c - lam_ref)]

    np.savetxt("maximo_espectro.dat", errores, fmt="%24.16E")

    print(f"lambda_max de referencia (b/T) = {lam_ref:.4f} nm")
    print(f"lambda del máximo en frecuencia = {lam_frec:.2f} nm")
    print("  paso [nm]   error A     error B     error C   [nm]")
    for paso, ea, eb, ec in errores:
        print(f"{paso:9.1f}{ea:12.3e}{eb:12.3e}{ec:12.3e}")
    razones = errores[:-1, 2:]/errores[1:, 2:]
    print("razón de errores al reducir el paso a la mitad (columnas B y C):")
    print(np.round(razones, 2))

    lam, B, *_ = estimar_maximos(PASO_FIGURA)
    graficar(lam, B, lam_ref, lam_frec, "espectro_solar.png")


if __name__ == "__main__":
    main()
