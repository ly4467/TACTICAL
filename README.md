# TACTICAL

This repository reports the code and the benchmarks for the paper "Tactical: Fault Localization of AI-Enabled Cyber-Physical Systems by Exploiting Temporal Neuron Activation".

## Abstract:

Modern cyber-physical systems (CPS) are evolving to integrate deep neural networks (DNNs) as controllers, leading to the emergence of AI-enabled CPSs. However, an inadequately trained DNN controller may produce incorrect control decisions, exposing the systems to huge safety risks. To prevent unsafe behaviors from happening, it is crucial to localize the faulty neurons in DNN controllers, thereby providing valuable references for further system re-engineering. However, since unsafe system behaviors typically arise from a sequence of control decisions, establishing a connection between faulty neurons and unsafe behaviors is extremely challenging. To tackle this problem, we propose TACTICAL that localizes the faults in AI-enabled CPS by exploiting neuron activation criteria that incorporate temporal aspects of DNN controller inferences. Based on the executions of test cases, we construct a spectrum for each neuron, which records the information including the specification satisfaction of each system execution and the activation status of the neuron in the system execution. Having the spectra of all neurons, we apply existing suspiciousness metrics to compute a suspiciousness score for each neuron, by which we select the most suspicious ones. We experimentally evaluate TACTICAL on 12 AI-enabled CPS benchmarks spanning over different domains, by injecting artificial faults into their DNN controllers. The results shows the effectiveness of TACTICAL, based on comparisons with a baseline approach and over different configurations. Moreover, we study the influence of hyperparameters to the effectiveness of TACTICAL, and thereby provide suggestions on hyperparameter selection.

<div align=center><img width="80%" height="80%" src="figs/workflow.png"></div>

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


## Extended experimental results

### RQ1: Does Tactical effectively localize the faulty neurons in an AI-enabled CPS?

This RQ aims to explore whether the TACTICAL method can successfully capture neurons with errors. Here is a supplementary histogram comparing this method with the random method to more intuitively display the effect. Under each different benchmark, a set of parameters most suitable for this application scenario are used for comparison, tops uses the top 20% number of neurons. Consistent with the paper, D* is used as the metric. If you need to get the code for the following histogram, you can get it by running the `figs/comparetoRandBar.m` file. <br>
It can be seen from the figure that under the conditions of the first 20% of screening, this method has great advantages over random in most cases, which illustrates the effectiveness of the method on the other hand. <br>
In some cases, particularly in the benchmark of AFC#2_phi3, the expected results were not achieved satisfactorily. Specifically, concerning the identification of faulty neurons, the criteria employed by PTK and MD still demonstrated suboptimal performance, with recognition rates approaching randomness. Through experimentation, it was observed that this discrepancy arose from the utilization of different neural network controllers in various benchmarks, each exhibiting distinct output characteristics. During the output process, these characteristics did not entirely align with the behavioral features defined by each criterion. Future research endeavors will focus on exploring more effective criteria based on these diverse output characteristics, aiming to pinpoint error occurrences and enhance the ability of criteria to better elucidate the behavioral patterns of AI controllers, improve the accuracy of fault localization.

<center class="half">
<img src="figs/RQ1/RQ1_bar/ACC_3_15_spec1.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/ACC_3_15_spec2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/ACC_4_10_spec1.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/ACC_4_10_spec2.jpg" width="20%"/>
</center>

<center class="half">
<img src="figs/RQ1/RQ1_bar/AFC_3_15_spec3.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/AFC_3_15_spec4.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/AFC_4_15_spec3.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/AFC_4_15_spec4.jpg" width="20%"/>
</center>

<center class="half">
<img src="figs/RQ1/RQ1_bar/WT_3_5_spec5.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/WT_3_15_spec5.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/SC_4_10_spec6.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_bar/SC_4_15_spec6.jpg" width="20%"/>
</center>

According to the description in RQ3 of the paper, "We also observe that Kulczynski2 and D* exhibit the best performance, as both of them outperform other metrics in at least 50% of the cases." Due to paper space limitations, only results of the D* metric in RQs are displayed, we also want to display results of Kulczynski2，hereinafter referred to as "Ku2". The following are the RQ1 results of Ku2.

<center class="half">
<img src="figs/RQ1/RQ1_ku2/ACC_1_spec1_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/ACC_1_spec1_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/ACC_2_spec1_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/ACC_2_spec2_alphaKulczynski2.jpg" width="20%"/>
</center>

<center class="half">
<img src="figs/RQ1/RQ1_ku2/AFC_1_spec3_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/AFC_1_spec4_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/AFC_2_spec3_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/AFC_2_spec4_alphaKulczynski2.jpg" width="20%"/>
</center>

<center class="half">
<img src="figs/RQ1/RQ1_ku2/WT_1_spec5_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/WT_2_spec5_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/SC_1_spec6_alphaKulczynski2.jpg" width="20%"/>
<img src="figs/RQ1/RQ1_ku2/SC_2_spec6_alphaKulczynski2.jpg" width="20%"/>
</center>


Due to the excessive amount of content associated with presenting the results for RQ1 under all suspiciousness metrics, only the results for Kulczynski2 are supplemented here. The analysis results for the remaining metrics can be found in the directory `figs\RQ1`. Here, additional analyses are provided for the top 20% conditions, showcasing results for each distinct benchmark under all metrics. The table results for this analysis can be obtained by executing the provided file `figs/valRate.m`.
<div align=center><img width="60%" height="60%" src="figs/RQ1/RQ1_allmetallsps_20p/conclusionTab.jpg"></div>

### RQ2: How does the selection of hyperparameters of the neuron activation criteria affect the effectiveness of Tactical?

This research question (RQ) meticulously elucidates the impact of parameter selection on experimental outcomes and provides users with comprehensive guidance for parameter selection. Similar to RQ1, the experimental results for all metrics employed in the paper, excluding D*, are supplemented here.<br>
It was demonstrated in RQ3 that the best metrics are D* and Ku2, through the comparison between the best metrics D* and Ku2, we can find the difference between them is not very big, and both can help users accurately locate errors and obtain better results. The assertion put forth in the paper, stating that 'there is no single value that is consistently better than the others for all the benchmarks,' is validated across all metrics here. Each benchmark necessitates the establishment of either strict or lenient parameters based on the specific application context to achieve optimal recognition outcomes. However, the distinctions in the optimal parameter settings for different metrics are marginal. In other words, the impact of the stringency of parameter selection for a specific benchmark is minimal with respect to different metrics, and is predominantly determined by the nature of the AI controller and the application scenario. If you intend to utilize other metrics for fault localization, it is recommended to consider the parameter selection insights provided in the paper, specifically the result analysis conducted for the D* metric. The findings for D* can serve as a valuable reference for parameter selection when applying alternative metrics in fault localization.

#### Tarantula
<div align=center><img width="80%" height="80%" src="figs/RQ2/RQ2Tarantula_table.png"></div>

#### Ochiai
<div align=center><img width="80%" height="80%" src="figs/RQ2/RQ2Ochiai_table.png"></div>

#### Dstar
<div align=center><img width="80%" height="80%" src="figs/RQ2/RQ2Dstar_table.png"></div>

#### Jaccard
<div align=center><img width="80%" height="80%" src="figs/RQ2/RQ2Jaccard_table.png"></div>

#### Kulczynski1
<div align=center><img width="80%" height="80%" src="figs/RQ2/RQ2ku1_table.png"></div>

#### Kulczynski2
<div align=center><img width="80%" height="80%" src="figs/RQ2/RQ2ku2_table.png"></div>


### RQ3: How does the selection of suspiciousness metric affect the effectiveness of Tactical?

The paper presents a comparative analysis among different metrics, and here, an alternative perspective is provided. Across 12 distinct benchmarks, the occurrences of optimal performance for each criterion under a specific metric are observed. For instance, in the table below, the first row and the eighth column indicate that Tarantula under the metric MD achieved better performance in 5 benchmarks compared to other metrics. The table is presented below, and both this table and the one provided in Research Question 3 (RQ3) in the paper reveal that the metrics D* and Ku2 exhibit superior performance.

<div align=center><img width="40%" height="40%" src="figs/RQ3/diffmetcompare.png"></div>

