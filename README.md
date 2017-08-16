### Run  Instructions ###
1) If initParams is not in working dir, run copy parameters: cpParams

2) Edit parameters in initParams. And save

3) Run the code: runHydrogel

4) Outputs placed in a directory in ./runfiles

## WD Function Description ##

initParams: (parameter file) Set parameters for runHydroGel and fluxPlusPDE

runHydrogel: (executeable) runs temporal evolution of PDE. 

fluxODE: (function) finds the flux at steady state using and ODE solver. Uses initParams.

fluxPlusPDE: (function) finds flux at steady state, slope dj/dt at half max flux, and time
  till half max slope by solving PDE. Uses initParams.

cmprSteadySolvers: (executeable) compares steady state solutions of various methods, ODE
  solvers, PDE solvers, linear vs non-linear, etc

cpParams: (executeable) copies master parameter file to initParams in WD

cleanme: (executeable) destroys all txt, fig, jpg, avi files in WD

nonDimParamCalc: (function) calculate scaled parameters from physical parameters

## Pando runs ##

To run runHydrogel on pando (currently using Torque)

For get mail:
qsub -N jobname hgMailPando.pbs

For no mail:
qsub -N jobname hgPando.pbs

