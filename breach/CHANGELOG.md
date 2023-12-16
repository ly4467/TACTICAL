# Release 1.2.13

## Users
- Improves parallel support: display simulations during computation
  and optimization and number of workers now tunable with B.SetupParallel(NumWorkers)
- Experimental struct parameter detection now disabled by default
  (would not work with nested struct), made available with FindStruct
  option in BreachSimulinkSystem constructor 
- New signal generators (sinusoid, exponential, spike)

## Bugfixes
- freq_update now only affects display, independant from number of
  cores during parallel simulation

# Release 1.2.12 

## Users	
- InitBreach now better removes path from older/other versions
- InitBreach takes a second Boolean argument, if true, forces re-initialization
- Added BreachVersion, returns current version
- SaveResults, ExportToStruct, ExportToExcel now available for BreachSet and all derivated classes

## Bugfixes
- InitBreach creates ModelsData folder when absent, e.g., with fresh
  clone 

# Release 1.2.11

## Developpers
- ResetTimeSpent method for BreachProblem

## Bugfixes
- Problems when exporting to Excel with imported data (inputs or not, issues 56-57)
- BreachGui wouldn't start without sets in the workspace (issue 55) 
- Error message caught when checking with no trace 

# Release 1.2.11beta3
- Performance improvement for Export to Excel

## Developpers
- Some cleaning in BreachGui

## Bugfixes
- plot in GUI would not update axes labels and limits
- Fixed errors when clicking buttons and stuff on empty GUI
- Ignore file_idx parameter when writing traces 
- fixed bug in SampleDomain when combining samples of dimensions more than 1
- fixed bug in PlotDomain for more than three dimensions
- fixed load parameter set not working in GUI

# Release 1.2.11beta2

## Bugfixes
- small bug in displaying number of computed traces
- fixed bug in until robustness computation causing crash


# Release 1.2.11beta

## Users
- SetInitFn method sets a callback function for initialization before simulation
- new helper function isSignal returns if a name represents a signal
  in a BreachSet
- GUI safeguards around selected parameters for sampling (Issues 32-33-34)
- GUI 'Domain' button changed to 'Variables' 
- Support struct parameters and model workspace, still experimental 
- Enable parallel from GUI
- SaveSignals/Load
- BreachSave function saves Breach objects in the workspace into a mat file 
- GetVariables method returns names of variables in a set, i.e., parameters with non-empty domain/range

## Bugfixes
- GUI: fixed Env. Param button when no input signal
- Calling InitBreach in InstallBreach at very beginning to avoid
  missing varargin2struc (#52)
- Fixed bug in BreachDomain with 'int' and empty domain leading to change to enum type
- Fixed bug in SetInputGen which would not update domains appropriately

## Developpers
- New class BreachOptionGui to create gui from options
- FalsificationProblem now ignores requirement variables 
- ParamSynthesisProblem now ignores non-requirement variables

# Release 1.2.10

## Users
- InstallBreach option linear_interp, now default to 0 
- PrintAll and PrintParams now displays enum values
- Simulink Breach menu for creating interface improvements 

## Bugfixes
- GUI: selecting worst samples, etc, does not change plot parameters any more (#26-1)
- RobustAnd can't return inconsistent time values (not time advancing)
- GUI: embarrassing st_info bug when changing sampling option fixed (#26-4)

## Developpers
- PlotParams not using DiscrimPropValues any more
- More robust implementation of BreachDomain constructor 

# Release 1.2.9

## Users
- STL_ReadFile now supports parameters overriding existing functions, mex-files, etc (e.g., x[t]>eps) 
- PlotSatParams now shows superposed samples with different satisfaction values
- GUI can be opened by BreachGUI command, without argument
- GUI Check formula button sorts results by satisfaction and robustness
- PlotSatParams has datacursormode on by default, shows parameter values and robustness 
- SaveSignals method saves signals in a format that from_files_signal_gen can read easily 
- Many changes in GUI

## Bugfixes
- GetSignalsValues with itraj would assume itraj=1 
- ParamSynth/ReqMining works when changing the solver of param synth problem (Issue #10)

## Developpers
- GetSatValues returns unique values and params as well as all values and non-unique params
- BreachPlot and BreachPlotSat, new classes for listening plots

# Release 1.2.8

## Users
- Minor changes in Excel exported from SaveResults  
- GenDoc function to generate html documentation from a set of script

## Bugfixes
 - SaveResults now uses v7.3 format for large files
- Fixed issue in Autotrans_tutorial  

## Developpers
- new function get_breach_path 
- CleanModelsData erase stuff in Ext/ModelsData folder 

# Release 1.2.7

## Bugfixes
- GetSatValues not returning the proper values (caused issue #14)
- BreachProblem with 4 arguments not properly setting  domains (issue #19)
- Fixed issue with signal builder parameters that should be ignored in sim_breach (issue #19) 
- Fixed bug in BreachProblem that was converting singular domains into unbounded ones (issue #18)

## Developpers
- FEvalInit now updates obj_best and x_best fields rather than setting it

# Release 1.2.6

## Users 
- GetSignalValues can collect values from one or a subset of traces instead of all available

## Bugfixes
- Fixed ExportTracesToStruct  output (time series for data)
- Fixed Excel template path 
- Fixed PlotParam

# Release 1.2.5

## Bugfixes
- Fixed bug in STL_ExtractSignal (quotes around varname)
- Fixed PlotRobusMap changing order of props_names (Issue 14)
 
# Release 1.2.4

## Users 
- Changed CHANGELOG to CHANGELOG.md
- ExportTraces method for Simulink 
- SaveResults method creates a folder with  breach_system and summary files  and traces subfolder with trace files
- LoadResults reads a folder created with SaveResults

## Bugfixes
- Fixed bug in ComputeTraj (Issue 13)
- STL formulas now can use custom p-file, m-file, mex and builtin, though parameters with same name get shadowed   
- Issue with z-axis label in PlotSatParams
- GUI creating new set updates display
- Traj GUI: fixed bug preventing recomputation of trajectory when modifying a parameter 

## Developpers
- get_checksum method computes the checksum of Simulink mdl, and returned boolean true if it changed wrt creation
- mdl BreachSimulinkSystem property is a struct with model name, original path and date of creation
- varargin2struct function can be used to setup basic optional argument with syntax optionName, optionValue

# Release 1.2.3

## Users
- New method PlotSatParams to implement red-green dot maps available in GUI
- New method GetSetValues to get satifaction values of a previously monitored requirement

## Bugfixes
- fixed plot satisfaction map in GUI
- fixed PlotRobustMap method

# Release 1.2.2

## Users
- ReqMiningProblem constructor with two argument (synth_pb and falsif_pb, e.g.) now works no matter the order of argument, but will error if it cannot identify a synthesis problem and a falsification problem
- SetupLogFolder default now has date of creation in name in format mdl_name_ddmmyy-HHMM 
- Predicates accept builtin and custom  user defined functions 

## Bugfixes
- fixed problem when shift-selecting multiple parameters in main GUI  
- fixed falsification (and all types of problems) not enforcing domains properly 
- fixed renaming in GUI not renaming in base workspace
- fixed GUI allows multiple cell edition with shift-return

## Developpers
- BreachProblem now stores domains for params  
- BreachProblem has a CheckinDomain method 

# Release 1.2.1

## Users
- GUI: set input now updates main GUI when done
- InitNNDemo in simple ML model example
- GUI allows multiple cell edition with shift-return
- GUI: set input does not reset signal generators

## Bugfixes
- GUI copy select button works again

## Developpers

# Release 1.2.0

## Users
- New PlotDomain method
- domains can be set with the syntax SetDomain([4 5.1]), will infer double type
- error is returned when wrong type is given in SetDomain
- default behavior of legacy sampling functions is to reset and replace, this is changed by AppendWhenSample flag
- new warning when breach can't get checksum of model from Simulink. Only affects the Log to file features.
- GetBoundedDomains returns domains with bounds/ranges
- GUI work with all BreachSet in the workspace, regardles of system interfaced
- AddSpec now add property parameters automatically
- PlotParams, PlotSignals, etc, now re-use the current figure if there is one (gcf)

## Bugs fixed
- compilation issue with VS 2015 for online monitoring (added include minmax and algorithm) 
- from_file_signal_gen not working for files in current folder 
- AppendWhenSample now works with legacy sampling functions, i.e., concat new param vectors when true 
- Parallel with less initial parameters than freq_update now works as intended
- AddSpec now checks whether formula is already present (prevent overwrite param values)

## Developpers  
- SampleDomain now calls sample method of BreachDomain
- BreachSet now has only one field Domains for signal and parameter domains 
- SetParamRanges errors when param does not exist (before would create it)
- ResetParamSet uses Domains instead of ParamRanges field
- SetParamSpec has an additional argument to ignore if param is a system parameter, if not set, return an error
- got rid of ParamRanges field, useless since we use domains

# Release 1.1.0

## Users 
- New menu in Simulink editor, can generate a Breach interface
- Breach now supports/detects To Workspace blocks
- Breach now supports/detects signal builders
- GUI for specs now can change parameters of formulas
- New GUI for creating input generator, accessible from main GUI 
- Main GUI keyboard shortcuts
- rightarrow from constant parameters to varying parameters, equivalent to [add =>]
- leftarrow from varying parameters equivalent to button [<= rem]
- return from varying parameters focus on min value
- log to files via SetupLogFolder 
- Support for different types via Domains
- SampleDomain, more comprehensive sampling of domains

## BugFix
- Fixed problem when resetting input generator with models with no inputs
- Fixed problem when logging multi dimensional signals
- Fixed problem with empty tspan when interfacing model
- Fixed problem Simulink models with no inputs


# Release 1.0.0

## Users

- BrDemo subfolder Optim contains InitAFC_Falsif which creates falsification problems
- BrDemo has a subfolder InputGen containing demo script for each type of generator (under construction)
- New method FilterSpec return sets that satisfy and don't satisfy a spec  
- SetParamRanges accepts a single interval for multiple parameters, 
    Example:
B.SetParamRanges({'p1', 'p2','p3'}, [ -1 , 1] ) is equivalent to
B.SetParamRanges({'p1', 'p2','p3'}, [ -1 , 1 ; -1 1 ;-1 1] ) 

- BreachSimulinkSystem now has a field sim_args used to pass additional option arguments to the Simulink sim command
- BreachSystem has SetSpec method - same as AddSpec, but reset Specs before
- BreachOpenSystem (hence BreachSimulinkSystem) has a AddInputSpec and SetInputSpec, calls AddSpec or SetSpec its InputGenerator
- PrintSignals now says which signal is an input 
- GetInputSignalsIdx returns indices of input signals in the list of signals of a system
- Minor improvement on display status for BreachProblem
- Input specs now are taken into account in Falsification problems
- Breach now stores its model copy and GUI files in a unique folder in Ext/ModelsData
