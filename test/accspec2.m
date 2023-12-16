clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/new-project
addpath(genpath('/Users/ly/Desktop/new-project'));
InitBreach;

D = load('ACC_vl_28_ve_22_spec_2_FFNN_trainlm_10_10_10_Nor_Sat_Feb_15_Tr.mat');
dataset_nor = 'Nor_ACC_vl_28_ve_22_ddefault_105_spec_1_Orig_Feb_7_Tr.mat';
if strcmp(dataset_nor, 'Null.mat')
    D_run = '';
    is_nor = 0;
else
    D_run = load(dataset_nor);
    is_nor = 1;
end
bm = 'ACC';
mdl = 'ACC_FFNN_trainlm_10_10_10_Nor_Sat_Feb_15_M';
T_suit_num = 200;
nn = load('ACC_FFNN_trainlm_10_10_10_config_Feb_15_Nor_1.mat');
net = nn.net;

T=50;
Ts=0.1;
v_set=30;
t_gap=1.4;
D_default=10;
x0_lead=70;
v0_lead=28;
x0_ego=10;
v0_ego=22;
amin_lead=-1;
amax_lead=1;
amin_ego=-3;
amax_ego=2;

sysconf.in_name = {'in_lead'};
sysconf.in_range = {[-1.0 1.0]};
sysconf.in_span = {5};
sysconf.icc_name = {'v_set','t_gap'};
sysconf.ic_const = {30,1.4};
sysconf.ics_name = {'v_ego','d_rel','v_rel'};
sysconf.oc_name = {'a_ego'};
sysconf.oc_span = {0.1};

cov_metric = {'nc','tkc','tnc','ttk','pd','nd','mi','md'};
act_param = {[10.0],[3.0],[50.0, 10.0],[50.0, 3.0],[50.0, 10.0],[50.0, 10.0],[50.0],[50.0]};
sps_metric = {'alphaTarantula','alphaOchiai','alphaDstar','alphaJaccard','alphaKulczynski1','alphaKulczynski2'};
topk = 8;
window = 10;
tsf_size = 120;
tsf_mode = 'allpass';
nsel_mode_fl = 'all';
fl_l = 0;
fl_r = 0;
nsel_mode_val = 'specify';
val_l = 3;
val_r = 3;
bugset_budget = 12;
behavior_change_rate = [0.1, 0.9];

parallelcompute = 1;
phi_str = 'alw_[0,45]((d_rel[t] - 1.4 * v_ego[t] <= 12) => ev_[0,5](d_rel[t] - 1.4 * v_ego[t] > 12))';
spec_i = 2;
sig_str = 'd_rel,v_ego';

test = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, cov_metric, act_param, sps_metric, T_suit_num, topk, window, behavior_change_rate, nsel_mode_fl, fl_l, fl_r, nsel_mode_val, val_l, val_r);

%% Parallel compute codes
[test_suite, ~, ~] = generateTestSuite(test.D, tsf_size+80, tsf_mode);
bugset = bugGenerator(bugset_budget,2);
disp(['Bug mutator:', mat2str(bugset)])

if strcmp(test.nsel_mode_val, 'specify')
    if test.val_l >= test.net.numLayers || test.val_r >= test.net.numLayers || test.val_l>test.val_r
        error("val_l or val_r error! Please check them.")
    end
elseif strcmp(test.nsel_mode_val, 'all')
    test.val_l = 1;
    test.val_r = test.layer_num;
else
    error("nsel_mode_val error! Please check it!")
end

if test.val_l == test.val_r
    resultdir = ['result/', date, '-', test.mdl, '_spec_', num2str(test.spec_i), '_valFL_layer_', num2str(test.val_l), '/'];
else
    resultdir = ['result/', date, '-', test.mdl, '_spec_', num2str(test.spec_i), '_valFL_layer_', num2str(test.val_l), '-', num2str(test.val_r),'/'];
end
mkdir(resultdir);

dirNomutation = fullfile(resultdir, [test.bm, '_spec', num2str(test.spec_i), '_bugval_0']);
mkdir(dirNomutation);
biasCell = {};
for layer_idx = test.val_l:test.val_r
    for neuron_idx = 1:test.nn_stru(layer_idx)
        
        % 这里填入要进行test的neuron Index
        layer1idx = [1 2 3 4 5 6 7 10];
        layer2idx = [2 3 4 6 7 8 10];
        layer3idx = [1 5 7];
        if (layer_idx == 1) && ~sum(layer1idx == neuron_idx)
            continue
        elseif (layer_idx == 2) && ~sum(layer2idx == neuron_idx)
            continue
        elseif (layer_idx == 3) && ~sum(layer3idx == neuron_idx)
            continue
        end

        biasCell{end+1} = [layer_idx neuron_idx test.bias{layer_idx}(neuron_idx)];
    end
end

pool = gcp('nocreate');
if ~isempty(pool)
     delete(pool);
end
pool = parpool([2 10]);

parfor idx = 1:numel(biasCell)
    test = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, cov_metric, act_param, sps_metric, T_suit_num, topk, window, behavior_change_rate, nsel_mode_fl, fl_l, fl_r, nsel_mode_val, val_l, val_r);
    li = biasCell{1,idx}(1);
    i = biasCell{1,idx}(2);
    if i == 1
        bug = bugset(18);
    elseif i == 5
        bug = bugset(20);
    elseif i == 7 
        bug = bugset(17);
    end

    [sig_state, sps_info, mutate_FL, bugbias, sig_success_rate, mutate_success, bug_mdl] = test.neuronMutate(bug, find(bugset==bug), li, i, test_suite, tsf_size);
    if mutate_success
        % do nothing
    else
        if sig_success_rate < test.behavior_change_rate(1)
            bugidxStartpos = 1;
            bugNum = find(bugset==1) - 2;
        elseif sig_success_rate > test.behavior_change_rate(2)
            bugidxStartpos = find(bugset==1);
            bugNum = numel(bugset) - bugidxStartpos;
        end

        for bugidx = 1:bugNum 
            bugidxReg = bugidx + bugidxStartpos;
            bug = bugset(bugidxReg);
            disp(['Mutation + Fault Localization processing.', '  Neuron Layer:', num2str(li), ' ,Index:', num2str(i), ' ,Mutator no.', num2str(bugidxReg)  '   Test suite size:', num2str(tsf_size)]);
            [sig_state, sps_info, mutate_FL, bugbias, sig_success_rate, mutate_success, bug_mdl] = test.neuronMutate(bug, bugidxReg, li, i, test_suite, tsf_size);
            if (sig_success_rate<test.behavior_change_rate(1)) || (mutate_success==1)
                break
            end
        end
    end
    FL_file = [resultdir, bug_mdl, '_mutate_', num2str(mutate_success), '.mat'];
    parsaveFLinfo(FL_file, sig_state, sps_info, bug, bugset, mutate_FL, bugbias, sig_success_rate);

    [sig_state, sps_info, mutate_FL, bugbias, sig_success_rate, ~, bug_mdl] = test.neuronMutate(0, 1, li, i, test_suite, tsf_size);
    nobugFL_file = fullfile(dirNomutation, [bug_mdl, '.mat']);
    parsaveFLinfo(nobugFL_file, sig_state, sps_info, bug, bugset, mutate_FL, bugbias, sig_success_rate);
end
