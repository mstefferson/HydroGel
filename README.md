# Run  Instructions 
I will use ':>' to denote running a (bash) script from terminal and '>>' to denote running a matlab program (in matlab command line). Here are the steps:
## Executing a single run (time depenents PDE)
1) If initParams is not in working dir, run copy parameters: cpParams. Parameters can be in physical or scaled units, but be consistent!
``` 
    >> cpParams
```
or
``` 
    :> ./cpParams
```
2) Edit parameters in initParams. And save

3) Run the code: 
  * Run it in MATLAB
```
>> runHydrogel
```
  *  Or submit a local job 
``` 
:> ./submitHgLocal
```
  *  Or submit a job to a cluster (slurm). This may need to be edited as mine is currently set-up to run on CU biogrontiers cluster fiji
``` 
:> sbatch --jobname=a_job_name fijiSlurmRunHydrogel.pbs
```

4) Outputs placed in a directory in ./runfiles

## Calculating selectivity (PDE/ODE)

Example runs are included in the comments of fluxODE, fluxPDE, fluxParamIn

## Calculating paper results 

There are two wrappers that generate the data (calls fluxODE/fluxPDE/fluxODEParamIn) and make the plots (calls plot routines) for the paper. Each result has it's own paramInput file located in ./paperInits. Both functions require a vector input denotating which results/plots to want to generate and make.  See the comments for more info. To make the results with key value 1, 2, 3:
```
>> paperResultsMaker([1:3])
```
Then to make the corresponding plots
```
>> paperPlotMaker([1:3])
```
### On fiji
Make sure there is a file called 'initPaperResults' that has a variable with the runs you want. This file will not be tracked.
```
:> sbatch --jobname=a_job_name fijiSlurmPaerResults.sh
```

# WD Function Description #

initParams.m: (parameter file) Set parameters for runHydrogel, fluxPDE, fluxODE

runHydrogel.m: (executeable) runs temporal evolution of PDE. 

fluxODE.m: (function) finds the flux at steady state using and ODE solver. Uses initParams.

fluxPDE.m: (function) finds flux at steady state, slope dj/dt at half max flux, and time
  till half max slope by solving PDE. Uses initParams.

fluxODEParamIN.m: (function) finds the flux at steady state using and ODE solver. Uses initParams and parameter inputs

cpParams.m: (executeable) copies master parameter file to initParams in WD

cleanme.m: (executeable) destroys all txt, fig, jpg, avi files in WD

nonDimParamCalc.m: (function) calculate scaled parameters from physical parameters

paperPlotMaker.m: (function) generate figures for the paper

paperResultsMaker.m: (function) generate figures for the paper

fijiSlurmPaperResults.sh: SLURM job submission script for paperResultsMaker

fijiSlurmRunHydrogel.sh: SLURM job submission script for runHydrogel

submitHydrogel: (executeable) wrapper for runHydrogel

submitPaperResults: (executeable) wrapper to paperResultsMaker

# Branch info

## master
Up-to-date with all paper plot routines for inital paper submission.

## paper_figs
Feature branch for making the paper figures

## submit_paper
Just a copy of paper_figs for the inital and final paper submission (makes it easy to quickly find important copies. Currently, it just has the initial submisssion as we are waiting for referee replies.

# Directory info
* src/: src code
* runfiles/: Where runHydrogel output files go

* steadyfiles/: Where fluxODE/fluxPDE output files go

* paperData/: Where paperResultsMaker output files go

* paperInits/: Initparam files for paperResultsMaker

* paperParamInput/: Initparam files for paperResultsMaker

* paperFigs/: Where paperPlotMaker output files go

