Project: Monte Carlo Simulation to tabulate average energy values for a single atom at increasing temperature increments.
Author: Frank Jenkins

This simulation computes average energy at temperatures between 0.1 and 1.0 (0.1 increment) for 1 single atom with average energy 
E(x) = K(c)x^2, where x is the atoms coordinate and c is a constant equal to 0.1. It utilizes a Monte Carlo algorithm using the 
Metropolis criterion.

Maximum position displacement is restricted to dx = 10. We also assume a Boltzman constant equal to one. 

The deliverables for this project is a plot of avg. energy vs temperature, and table with avg. energy, temperature, and the number 
of Monte Carlo steps performed to obtain avg. energy at each temperature increment.