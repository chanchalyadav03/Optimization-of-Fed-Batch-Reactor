# Optimization of a Fed-Batch Bioreactor with Biomass Constraint

## Introduction

This project focuses on the **optimization of a fed-batch bioreactor**, where the substrate feed rate is controlled to maximize the final product concentration while maintaining biomass constraints.

A **fed-batch bioreactor** allows substrates to be added continuously over time without removing the culture medium. This method provides precise control over microbial growth and product formation and is widely used in pharmaceutical, biofuel, and fermentation industries.

The system is modeled using coupled nonlinear ODEs that describe **biomass growth**, **substrate consumption**, **product formation**, and **volume variation**. Optimization is performed using both **iterative** and **fmincon (nonlinear constrained)** approaches in MATLAB.

---

## Project Members

- Chanchal Yadav   
- Pradeep Kumar Meena 

**Supervisor:** Prof. Nitin Padhiyar  
Department of Chemical Engineering, IIT Gandhinagar

---

## Project Objectives

The main objective is to **maximize the final product concentration (P(tf))** by optimizing the substrate feed rate `u(t)` under the constraint \( X(t) ≤ X_max
) to prevent oxygen depletion and ensure stable bioprocess operation.

### Specific Goals
- Model the fed-batch bioreactor dynamics
- Compare iterative and `fmincon` optimization methods
- Apply biomass concentration constraint \(X(t) ≤ X_max
)
- Implement **hourly feed optimization**
- Combine **initial condition and feed optimization** for improved performance

---

## Model Overview

| Variable | Description |
|:--|:--|
| S | Substrate concentration (g/L) |
| X | Biomass concentration (g/L) |
| P | Product concentration (g/L) |
| V | Volume of culture (L) |
| u | Feed rate (L/h) |

| Parameter | Meaning | Value |
|:--|:--|:--|
| μm | Maximum specific growth rate | 0.53 h⁻¹ |
| Km | Monod constant | 1.2 g/L |
| Ki | Inhibition constant | 22 g/L |
| Yx | Biomass yield | 0.4 |
| Yp | Product yield | 1 |
| ν | Product formation rate | 0.5 h⁻¹ |
| Sin | Inlet substrate concentration | 20 g/L |
| Xmax | Maximum biomass concentration | 3 g/L |
| umin–umax | Feed bounds | 0–1 L/h |

---

## Files in Repository

| File Name | Description |
|:--|:--|
| `CL399_Poster_22110055.pdf` | Poster presentation summarizing project results |
| `CL399_Project_Presentation_Final.pdf` | Final project PowerPoint presentation |
| `IterativeOptimization.m` | MATLAB code for optimization using iterative method |
| `fminconOPtimization.m` | MATLAB code for optimization using fmincon with constraints |
| `fminconinitialvalueopt.m` | MATLAB code for optimization of initial conditions |
| `optimalValuesofUforEachHour.m` | MATLAB code for hourly feed-rate optimization |
| `ModellingFermentor.m` | MATLAB script for modeling the fed-batch bioreactor ODE system |


---

## How to Run the MATLAB Codes

1. Open MATLAB and navigate to the folder containing these files.  
2. Run each file separately by typing its name (without `.m`) in the MATLAB Command Window.  
3. Ensure that the Optimization Toolbox is installed for the `fmincon` codes.  
4. View the output in MATLAB Command Window and plots generated automatically.  



## Methodology

### 1️⃣ Iterative Optimization ([IterativeOptimization.m](./IterativeOptimization.m))
- Tests multiple constant feed rates `u ∈ [0, 1]`
- Solves the system of ODEs for each `u`
- Selects the `u` value that gives the maximum final product concentration `P(tf)`

### 2️⃣ fmincon Optimization ([fminconOPtimization.m](./fminconOPtimization.m))
- Uses MATLAB’s `fmincon` function to determine the optimal feed rate `u`
- Applies nonlinear constraint \( X(t) \leq 3 \) to prevent oxygen depletion
- Provides efficient and accurate optimization under physical limits

### 3️⃣ Initial Condition Optimization ([fminconinitialvalueopt.m](./fminconinitialvalueopt.m))
- Optimizes starting conditions (biomass `X₀`, substrate `S₀`, and volume `V₀`)
- Enhances product yield even for fixed feed rates

### 4️⃣ Hourly Feed Optimization ([optimalValuesofUforEachHour.m](./optimalValuesofUforEachHour.m))
- Divides the total process duration into 8 hourly intervals
- Determines optimal feed rates \( u₁, u₂, …, u₈ \) for each hour
- Improves process performance and product yield

### 5️⃣ Modeling the Reactor ([ModellingFermentor.m](./ModellingFermentor.m))
- Defines and solves the system of ODEs representing the fed-batch bioreactor
- Simulates biomass, substrate, and product concentration profiles
- Reusable module for integration with optimization scripts

---

## Summary of Results

| Case | Optimization Type | X₀ (g/L) | S₀ (g/L) | V₀ (L) | u (L/h) | t (h) | P(tf) (g/L) |
|:--|:--|:--|:--|:--|:--|:--|:--|
| 1 | Fixed Feed Rate (Iterative) | 1 | 0 | 2 | 0.4284 | 8 | 6.6778 |
| 2 | fmincon (With Constraint) | 1 | 0 | 2 | 0.3173 | 8 | 6.4633 |
| 3 | Hourly Feed | 1 | 0 | 2 | {u₁...u₈} | 8 | 7.4124 |
| 4 | Optimized Initial + Feed | 2 | 0 | 2.78 | 0.4569 | 8 | 8.0671 |
| 5 | Hourly Feed + Initial Opt. | 1 | 0 | 2 | {u₁...u₈} | 8 | **8.7371** |

### Key Insights
- The **fmincon method** achieved stable and precise optimization under constraints.  
- **Hourly control** of feed rate significantly improved the yield compared to constant feed.  
- **Combined optimization** of initial conditions and feed rate produced the **highest product concentration (8.7371 g/L)**.  
- Maintaining the **biomass constraint** \( X(t) \leq 3 \) was essential to prevent oxygen depletion and ensure reactor stability.

---

## Acknowledgements

We sincerely thank **Prof. Nitin Padhiyar**,  
Department of Chemical Engineering, IIT Gandhinagar,  
for his valuable guidance, insights, and continuous support throughout this project.

---

## References

1. P.F. Stanbury, A. Whitaker, and S.J. Hall, *Principles of Fermentation Technology*, Pergamon, 2017.  
2. L. Bastiaens and J. F. Van Impe, *Bioreactor Dynamics and Control*, Springer, 2015.  
3. [MathWorks fmincon Documentation](https://www.mathworks.com/help/optim/ug/fmincon.html)  
4. F. Garcia-Ochoa et al., “Oxygen uptake rate in microbial processes: an overview,” *Biochemical Engineering Journal*, 49(3):289–307, 2010.

