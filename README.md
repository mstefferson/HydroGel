### Run  Instructions ###
1) If initParams is not in working dir, run copy parameters: cpParams

2) Edit parameters in initParams. And save

3) Run the code: runHydroGel

4) Outputs placed in a directory in ./Outputs

## WD Function Description ##

initParams: (parameter file) Set parameters for runHydroGel and fluxPlusPDE

runHydroGel: (executeable) runs temporal evolution of PDE. 

fluxODE: (executeable) finds the flux at steady state using and ODE solver

fluxPlusPDE: (executeable) finds flux at steady state, slope dj/dt at half max flux, and time
  till half max slope by solving PDE.

cmprSteadySolvers: (executeable) compares steady state solutions of various methods, ODE
  solvers, PDE solvers, linear vs non-linear, etc

cpParams: (executeable) copies master parameter file to initParams in WD

cleanme: (executeable) destroys all txt, fig, jpg, avi files in WD

