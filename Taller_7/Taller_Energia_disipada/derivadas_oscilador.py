# ============================================================
# Programa:  derivadas_oscilador.py
# Propósito: velocidad y aceleración de un oscilador amortiguado
#            a partir de las posiciones, con diferencias finitas
#            (rebanadas, sin ciclos sobre los puntos).
# Salida:    derivadas_oscilador.dat, errores_derivadas.dat,
#            derivadas_oscilador.png
# ============================================================
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

AZUL, DORADO, ROJO, VERDE, GRIS = "#162A54", "#C9972C", "#B02A20", "#2E7D32", "#7F7F7F"

G, W = 0.5, 2*np.pi          # gamma [1/s], omega [rad/s]
T = 3.0                      # tiempo final [s]

def x_ex(t): return np.exp(-G*t)*np.cos(W*t)
def v_ex(t): return -np.exp(-G*t)*(G*np.cos(W*t) + W*np.sin(W*t))
def a_ex(t): return np.exp(-G*t)*((G*G - W*W)*np.cos(W*t) + 2*G*W*np.sin(W*t))

def derivar(dt):
    """Devuelve la malla, las posiciones y cada derivada con sus tiempos.
    Entrada: paso dt.  Cada fórmula se evalúa solo donde está definida."""
    n = round(T/dt) + 1
    t = np.linspace(0.0, T, n)
    x = x_ex(t)
    v_adel = (x[1:] - x[:-1])/dt                                      # t[:-1]
    v_atra = (x[1:] - x[:-1])/dt                                      # t[1:]
    v_cent = (x[2:] - x[:-2])/(2*dt)                                  # t[1:-1]
    v_cinco = (-x[4:] + 8*x[3:-1] - 8*x[1:-3] + x[:-4])/(12*dt)       # t[2:-2]
    a_cent = (x[2:] - 2*x[1:-1] + x[:-2])/dt**2                       # t[1:-1]
    return t, x, v_adel, v_atra, v_cent, v_cinco, a_cent

def errores(dt):
    """Error máximo de cada fórmula frente a la derivada exacta."""
    t, x, v_adel, v_atra, v_cent, v_cinco, a_cent = derivar(dt)
    return [dt,
            np.max(np.abs(v_adel - v_ex(t[:-1]))),
            np.max(np.abs(v_atra - v_ex(t[1:]))),
            np.max(np.abs(v_cent - v_ex(t[1:-1]))),
            np.max(np.abs(v_cinco - v_ex(t[2:-2]))),
            np.max(np.abs(a_cent - a_ex(t[1:-1])))]

# --- dt = 0.01: datos en los puntos interiores y figura
dt = 0.01
t, x, v_adel, v_atra, v_cent, v_cinco, a_cent = derivar(dt)
ti = t[1:-1]
np.savetxt("derivadas_oscilador.dat",
           np.column_stack([ti, x[1:-1], v_cent, a_cent]),
           header="t x v_central a_central", fmt="%.16e")

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6), sharex=True)
tf = np.linspace(0, T, 1000)
ax1.plot(tf, v_ex(tf), color=GRIS, lw=2.5, label="exacta")
ax1.plot(ti, v_cent, "--", color=AZUL, lw=1.2, label="central numérica")
ax1.set_ylabel("$v$ [m/s]"); ax1.legend()
ax2.plot(tf, a_ex(tf), color=GRIS, lw=2.5, label="exacta")
ax2.plot(ti, a_cent, "--", color=ROJO, lw=1.2, label="central numérica")
ax2.set_ylabel("$a$ [m/s$^2$]"); ax2.set_xlabel("$t$ [s]"); ax2.legend()
ax1.set_title(r"Oscilador amortiguado: derivadas numéricas ($\Delta t = 0.01$ s)")
for ax in (ax1, ax2): ax.grid(alpha=0.3)
plt.tight_layout()
plt.savefig("derivadas_oscilador.png", dpi=150)

# --- errores máximos para dt = 0.01 y 0.005
E = np.array([errores(0.01), errores(0.005)])
np.savetxt("errores_derivadas.dat", E,
           header="dt err_adelantada err_atrasada err_central err_cinco_puntos err_a_central",
           fmt="%.16e")

nombres = ["adelantada", "atrasada", "central", "cinco puntos", "a central"]
razones = E[0, 1:]/E[1, 1:]
print("Errores máximos (dt = 0.01 | dt = 0.005 | razón)")
for nom, e1, e2, r in zip(nombres, E[0, 1:], E[1, 1:], razones):
    print(f"{nom:>13}: {e1:.3e} | {e2:.3e} | {r:5.2f}")
