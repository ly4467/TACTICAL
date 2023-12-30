# TACTICAL

This repository reports the code and the benchmarks for the paper "Tactical: Fault Localization of AI-Enabled Cyber-Physical Systems by Exploiting Temporal Neuron Activation".

## Abstract:

Modern cyber-physical systems (CPS) are evolving to integrate deep neural networks (DNNs) as controllers, leading to the emergence of AI-enabled CPSs. However, an inadequately trained DNN controller may produce incorrect control decisions, exposing the systems to huge safety risks. To prevent unsafe behaviors from happening, it is crucial to localize the faulty neurons in DNN controllers, thereby providing valuable references for further system re-engineering. However, since unsafe system behaviors typically arise from a sequence of control decisions, establishing a connection between faulty neurons and unsafe behaviors is extremely challenging. To tackle this problem, we propose TACTICAL that localizes the faults in AI-enabled CPS by exploiting neuron activation criteria that incorporate temporal aspects of DNN controller inferences. Based on the executions of test cases, we construct a spectrum for each neuron, which records the information including the specification satisfaction of each system execution and the activation status of the neuron in the system execution. Having the spectra of all neurons, we apply existing suspiciousness metrics to compute a suspiciousness score for each neuron, by which we select the most suspicious ones. We experimentally evaluate TACTICAL on 12 AI-enabled CPS benchmarks spanning over different domains, by injecting artificial faults into their DNN controllers. The results shows the effectiveness of TACTICAL, based on comparisons with a baseline approach and over different configurations. Moreover, we study the influence of hyperparameters to the effectiveness of TACTICAL, and thereby provide suggestions on hyperparameter selection.

<div align=center><img width="80%" height="80%" src="figs/workflow.png"></div>

***

## System requirement
- Operating system: Linux or MacOS;
- Matlab (Simulink/Stateflow) version: >= 2020a. (Matlab license needed)
- Python version: >= 3.3
- MATLAB toolboxes dependency: 
  1. [Simulink](https://www.mathworks.com/products/simulink.html)
  2. [Deep Learning Toolbox](https://www.mathworks.com/products/deep-learning.html) 

## Installation

- Install [Breach](https://github.com/decyphir/breach)
  1. start matlab, set up a C/C++ compiler using the command `mex -setup`. (Refer to [here](https://www.mathworks.com/help/matlab/matlabexternal/changing-default-compiler.html) for more details.)
  2. navigate to `breach/` in Matlab commandline, and run `InstallBreach`

## Usage

How to reproduce the experimental results

### Mutation Process
- The user-specified configuration files are stored under the directory `test/config/`. Replace the paths of `TACTICAL` in user-specified file under the line `addpath 1` with their own path. Users can also specify other configurations, such as bugset budget.
- Navigate to the directory `test/`. Run the command `python valFL.py config/[benchmark]/[configfile]`.
- Now the executable scripts have been generated under the directory `test/scripts/`.
- Users need to edit the executable scripts permission using the command `chmod -R 777 scripts/*`.
- Users need to run the script by using the command `./scripts/[scriptname]`. After mutation processed, mutation results data are stored in the `result/`.

### RQs
- After all benchmarks mutation processed, open the `src/RQ1part1.m` by using matlab. Users can change the path of data or the auto mode into manual mode, and run the analyzing progress. First, set `automode=1` in the `src/RQ1part1.m` file and run the analysis. All temporary data files are in the `result/[benchmarkdataname]/transDataProcessed`.
- After completing the previous step of analysis, open `src/RQ2.m`, set the selected metric and run it. The running results will be saved in the `result/RQ2Data_[metric name].mat` file. After reading this file, manually fill in the data in the `RQ2percentage.xlsx` file to obtain the results of RQ2 in the paper, and then select the best set of parameters for each benchmark.
- Use the parameters selected in the previous step to manually set and run in the `src/RQ1part1.m` file, set `automode=0`, and obtain the results of each benchmark in the paper RQ1.1 in `result/[benchmarkdataname]/transDataProcessed/[configs]_topkAnalyze`. Rename the `.mat` files in the directory to the same name as the benchmark and put them in one directory, e.g. `ACC_4_10_spec1.mat`. Run the `src/RQ1part2_RQ3.m` file to get the results of RQ1.2 and RQ3.

## Repository Structure

```
.
├── README.md
├── RQ2percentage.xlsx
├── benchmarks
│    ├── ACC
│    ├── AFC
│    ├── SC
│    └── WT
├── breach
├── result
├── src
│    ├── CovFL.m
│    ├── RQ1part1.m
│    ├── RQ1part2_RQ3.m
│    ├── RQ2.m
│    ├── covcriteria
│    │   ├── MDNC.m
│    │   ├── MINC.m
│    │   ├── NC.m
│    │   ├── NDNC.m
│    │   ├── PDNC.m
│    │   ├── TPKNC.m
│    │   ├── TTK.m
│    │   └── TimedNC.m
│    ├── func
│    │   ├── autoSelect.m
│    │   ├── bugGenerator.m
│    │   ├── diffTopkAnalyze.m
│    │   ├── insertWeightBug.m
│    │   ├── nnresultEval.m
│    │   ├── parallelAnalyzeDiffParam.m
│    │   ├── parsaveFLinfo.m
│    │   ├── parsaveMutInfo.m
│    │   ├── plotTopkAnalyze.m
│    │   ├── processBestData.m
│    │   ├── randFL.m
│    │   ├── readFileName.m
│    │   ├── sigMatch.m
│    │   ├── spsCalculator.m
│    │   ├── spsScoreCompute.m
│    │   ├── spstopkAnalyze.m
│    │   └── transData.m
│    └── util
│        ├── neuronPlot.m
│        └── ratePlotBar.m
└── test
    ├── FL.py
    ├── config
    │    ├── ACC
    │    │   ├── ACC_mut_3_15
    │    │   └── ACC_mut_4_10
    │    ├── AFC
    │    │   ├── AFC_mut_3_15
    │    │   └── AFC_mut_4_15
    │    ├── SC
    │    │   ├── SC_mut_4_10
    │    │   └── SC_mut_4_15
    │    └── WT
    │        ├── WT_mut_3_15
    │        └── WT_mut_3_5
    └── valFL.py
```

***


## Extended experimental results

### RQ1

According to the description in RQ3 of the paper, "We also observe that Kulczynski2 and D* exhibit the best performance, as both of them outperform other metrics in at least 50% of the cases." Due to paper space limitations, only results of the D* metric in RQs are displayed, we also want to display results of Kulczynski2，hereinafter referred to as "Ku2". The following are the RQ1 results of Ku2.

<p float="left">
<img src="figs/RQ1_ku2/ACC_1_spec1_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/ACC_1_spec1_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/ACC_2_spec1_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/ACC_2_spec2_alphaKulczynski2.jpg" width="24%"/>
</p>

<p float="left">
<img src="figs/RQ1_ku2/AFC_1_spec3_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/AFC_1_spec4_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/AFC_2_spec3_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/AFC_2_spec4_alphaKulczynski2.jpg" width="24%"/>
</p>

<p float="left">
<img src="figs/RQ1_ku2/WT_1_spec5_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/WT_2_spec5_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/SC_1_spec6_alphaKulczynski2.jpg" width="24%"/>
<img src="figs/RQ1_ku2/SC_2_spec6_alphaKulczynski2.jpg" width="24%"/>
</p>


### RQ2

The following is the result table compiled by RQ2 under Kulczynski2's metric.<br>
It can be seen from these results that the difference between D* and Ku2 is not very big, and both can help users accurately locate errors and obtain better results.

<div align=center><img width="80%" height="80%" src="figs/RQ2ku2_table.png"></div>
