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

