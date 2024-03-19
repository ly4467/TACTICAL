#!/bin/sh
csv=$1
matlab -nodesktop -nosplash <<EOF

clear;
close all;
clc;
bdclose('all');
cd /Users/ly/Desktop/TACTICAL
addpath(genpath('/Users/ly/Desktop/TACTICAL'));
InitBreach;

D = load('ACC_vl_28_ve_22_spec_2_FFNN_trainscg_15_15_15_Nor_Sat_Feb_7_Tr.mat');
dataset_nor = 'Nor_ACC_vl_28_ve_22_ddefault_20_spec_1_Orig_Feb_7_Tr.mat';
if strcmp(dataset_nor, 'Null.mat')
    D_run = '';
    is_nor = 0;
else
    D_run = load(dataset_nor);
    is_nor = 1;
end
bm = 'ACC';
mdl = 'ACC_FFNN_trainscg_15_15_15_Nor_Sat_Feb_7_M';
nn = load('ACC_FFNN_trainscg_15_15_15_Nor_config_Feb_7.mat');
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

T_suit_num = 100;
nsel_mode_val = 'all';
valLayer = [2.0, 3.0];
bugset_budget = 20;
behavior_change_rate = [0.1, 0.9];

phi_str = 'alw_[0,45]((d_rel[t] - 1.4 * v_ego[t] <= 12) => ev_[0,5](d_rel[t] - 1.4 * v_ego[t] > 12))';
spec_i = 2;
sig_str = 'd_rel,v_ego';

covModel = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, [], [], [], T_suit_num, [], [], behavior_change_rate, [], [], [], nsel_mode_val, valLayer);
resultPath = sprintf('result/%s_%d_%d_spec%d', bm, covModel.layerNum, covModel.networkStru(1), spec_i);
mkdir(resultPath);

sig_state = cell(1,T_suit_num);
for sig = 1:T_suit_num
    warning('off', 'all');
    [sig_state{sig}.rob, sig_state{sig}.tau_s, sig_state{sig}.ic_sig_val, sig_state{sig}.oc_sig_val, sig_state{sig}.nn_hidden_out, sig_state{sig}.nn_output] = covModel.signalDiagnosis(mdl, covModel.testsuite{sig}, spec_i);
    sig_state{sig}.in_sig = covModel.testsuite{sig};
    fprintf('No Mutation Signal.%d finished!\n', sig);
end
nobugMut_file = fullfile(resultPath, [mdl(1:end-2), '_nomutation.mat']);
save(nobugMut_file, 'sig_state');

%% Parallel compute codes
pool = gcp('nocreate');
if ~isempty(pool)
     delete(pool);
end
pool = parpool([2 10]);

parfor idx = 1:size(covModel.mutationWeightList,1)
    warning('off', 'all');
    covModel.mutationParallelProcess(idx, resultPath);
end

quit force
EOF
