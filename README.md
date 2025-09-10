# Fed-Batch Bioreactor Simulation and Optimization

This repository contains MATLAB codes for simulating and optimizing a **fed-batch bioreactor** system.  
The work is based on classical bioprocess modeling using **Monod kinetics with substrate inhibition**, and includes both **dynamic simulation** and **optimal control** of the feed strategy.

---

## 📌 Project Overview

- **System modeled:** Fed-batch bioreactor with biomass (X), substrate (S), product (P), and reactor volume (V).
- **Kinetics:** Monod model with substrate inhibition term.
- **Objective:** Maximize final product formation by optimizing the feed rate profile `u(t)`.
- **Approach:**
  - Set up coupled ODEs describing mass balances.
  - Simulate process behavior with `ode45`.
  - Use `fmincon` to optimize time-varying feed strategy under process constraints.

---

## 🧮 Model Equations

The system of equations solved is:

\[
\frac{dX}{dt} = \mu(S)X - \frac{u}{V}X
\]

\[
\frac{dS}{dt} = -\frac{1}{Y_x}\mu(S)X - \frac{\nu}{Y_p}X + \frac{u}{V}(S_{in} - S)
\]

\[
\frac{dP}{dt} = \nu X - \frac{u}{V}P
\]

\[
\frac{dV}{dt} = u
\]

with:

\[
\mu(S) = \frac{\mu_m S}{K_m + S + S^2/K_i}
\]

---

## 📂 Repository Structure

---

## 🚀 Features

- Simulation of fed-batch reactor dynamics (`ode45`).
- Parameter sweeps over feed rates.
- Optimal control of feed rate profile using **fmincon**.
- Process constraints (e.g., biomass concentration `X ≤ 3`).
- Visualization of:
  - Biomass, substrate, product, volume vs time.
  - Final product vs feed rate.
  - Optimized feed profile.

---

## 📊 Example Outputs

### Final Product vs Flow Rate
(Generated from parameter sweep)

![Product vs Feed Rate](plots/final_product_vs_feed.png)

### Optimized Feed Strategy
(Generated from optimal control with `fmincon`)

![Optimized Feed](plots/optimized_feed_profile.png)

---

## 🛠️ Requirements

- MATLAB R2022a or newer
- Optimization Toolbox (for `fmincon`)

---

## 📖 Skills Demonstrated

- **Process Modeling:** Bioprocess mass balances with inhibition kinetics.
- **Numerical Methods:** Solving ODEs with MATLAB (`ode45`).
- **Optimization:** Nonlinear programming (`fmincon`) with constraints.
- **Data Visualization:** Plotting reactor profiles and optimization results.
- **Chemical Engineering Applications:** Reactor design and bioprocess optimization.

---

## ✍️ Author

**Chanchal Yadav**  
B.Tech Chemical Engineering  
*(Prepared as part of academic + placement portfolio)*

---

## 📌 Note

This repository is intended for learning and demonstration purposes.  
The models and parameters are simplified representations and not from industrial datasets.

