# Semi-Active LQR Suspension & Braking Co-Simulation (2-DOF Half-Car Model)

This repository contains the MATLAB/Simulink modeling framework and simulation scripts for evaluating a semi-active LQR-controlled suspension system during transient braking maneuvers. Developed as part of a Master's research project in collaboration with Öhlins.

---

## 🚗 Project Overview & Objectives
The primary objective of this simulation framework is to demonstrate the performance superiority of a **semi-active suspension controller** over a passive baseline configuration during harsh braking events—specifically focusing on:
* Suppression of Transient Pitch/Heave: Mitigating brake dive and body oscillations ($1\text{--}3\text{ Hz}$).
* Tire Friction Saturation Management: Preventing premature tire force clipping and contact-patch degradation under low-friction road conditions ($\mu = 0.4$).
* Actuator Constraint Realization: Factoring in real-world Öhlins solenoid valve limitations (damping coefficient bounds, passivity/dissipativity guards, and slew-rate bandwidth limits).

---

## 📐 System Architecture & Modeling Tiers

1. Plant Dynamics (2-DOF Half-Car State-Space):
   * Captures sprung mass vertical bounce (heave, z) and pitch angle (theta).
   * Inputs include front and rear damping forces (F_{df}, F_{dr}) and longitudinal braking-induced pitch moments.

2. Öhlins Actuator Realization Subsystem:
   * Damping Coefficient Saturation: Bounded between c_{\min} = 500\text{ N}\cdot\text{s/m}$ and $c_{\max} = 4000\text{ N}\cdot\text{s/m}.
   * Passivity Constraint: Enforced via velocity-guard logic (F_d \cdot \dot{x}_{\text{rel}} \le 0) to ensure the damper remains strictly dissipative.
   * Valve Bandwidth Limits: Modeled using a rate-limiter to simulate solenoid response lag.

3. Tier 2 Non-Linear Tire Friction Saturation:
   * Dynamically calculates front and rear normal loads ($F_{zf}, F_{zr}$) accounting for static weight distribution, suspension spring/damper deflections, and longitudinal load transfer ($\Delta F_z = \frac{m h a_x}{L}$).
   * Enforces the friction limit ceiling ($F_{x,\max} = \mu F_z$) to evaluate how semi-active load stabilization prevents deceleration degradation.

---

## 📁 Repository Structure
```text
├── tire_brake_deceleration.slx  # Main 2-DOF Simulink braking & suspension co-simulation model
├── init_parameters.m            # MATLAB auto-initialization script (State-space matrices & LQR gains)
├── Post_processing.m            # Post-processing script for generating performance plots & metrics
├── /subsystems                  # Custom damper and Tier 2 normal load calculation blocks
├── /results                     # Simulation scope outputs and performance comparison plots
└── README.md                    # Project documentation
