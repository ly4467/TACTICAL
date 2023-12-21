import sys
import os

# path
addpath = []
# dataset
dataset = []
dataset_nor = ''
# model parameters
bench = ''
model = ''
parameters = []
# io parameters
in_name = []
in_range = []
in_span = ''
icc_name = []
ic_const = []
ics_name = []
oc_name = []
oc_span = []
# nn parameters
nn = ''
# specification
phi_str = []
sig_str = []
# fault localization parameters
es_mode = []
sps_metric = []
# tsf_size = ''
# tsf_mode = ''
# nsel_mode_fl = ''
# fl_l = ''
# fl_r = ''
nsel_mode_val = ''
valLayer = []
behavior_change_rate = []
bugset_budget = ''
# coverage criteria
T_suit_num = ''

# script parameters
status = 0
arg = ''
linenum = 0

# For testing, delete this line after test
# file = "/Users/ly/Desktop/new-project/test/config/SC/SC_mut_4_10"

# Change to "with open(sys.argv[1],'r') as conf:"
with open(sys.argv[1], 'r') as conf:
# with open(file, 'r') as conf:
	context = conf.readlines()
	for line in context:
		argu = line.strip().split()
		if argu == [] or argu[0] == "#" or argu[0][0] == "#":
			continue
		if status == 0:
			linenum = int(argu[1])
			if linenum == 0:
				continue
			status = 1
			arg = argu[0]
		elif status == 1:
			linenum = linenum - 1
			if arg == 'addpath':
				addpath.append(argu[0])
			elif arg == 'dataset':
				dataset.append(argu[0])
			elif arg == 'dataset_nor':
				dataset_nor = argu[0]
			elif arg == 'bench':
				bench = argu[0]
			elif arg == 'model':
				model = argu[0]
			elif arg == 'parameters':
				parameters.append(argu[0])
			elif arg == 'in_name':
				in_name.append(argu[0])
			elif arg == 'in_range':
				in_range.append([float(argu[0]),float(argu[1])])
			elif arg == 'in_span':
				in_span += argu[0]
				if linenum > 0:
					in_span += ","
			elif arg == 'icc_name':
				icc_name.append(argu[0])
			elif arg == 'ic_const':
				ic_const.append(argu[0])
			elif arg == 'ics_name':
				ics_name.append(argu[0])
			elif arg == 'oc_name':
				oc_name.append(argu[0])
			elif arg == 'oc_span':
				oc_span = '{'
				for idx in range(len(argu)-1):
					oc_span = oc_span + argu[idx] + ','
					# print(argu[idx])
				oc_span = oc_span + argu[len(argu)-1] + '}'
			elif arg == 'nn':
				nn = argu[0]
			elif arg == 'phi_str':
				complete_phi = argu[0] + ';' + argu[1]
				for a in argu[2:]:
					complete_phi = complete_phi + ' ' + a
				phi_str.append(complete_phi)
			elif arg == 'sig_str':
				sig_str.append(argu[0])
			elif arg == 'tops':
				tops = argu[0]
			elif arg == 'sps_metric':
				sps_metric.append(argu[0])
			# elif arg == 'tsf_size':
			# 	tsf_size = argu[0]
			# elif arg == 'tsf_mode':
			# 	tsf_mode = argu[0]
			# elif arg == 'nsel_mode_fl':
			# 	nsel_mode_fl = argu[0]
			# elif arg == 'fl_l':
			# 	fl_l = argu[0]
			# elif arg == 'fl_r':
			# 	fl_r = argu[0]
			elif arg == 'nsel_mode_val':
				nsel_mode_val = argu[0]
			elif arg == 'valLayer':
				for i in range(len(argu)):
					valLayer.append(float(argu[i]))
			elif arg == 'behavior_change_rate':
				for i in range(len(argu)):
					behavior_change_rate.append(float(argu[i]))
			elif arg == 'bugset_budget':
				bugset_budget = argu[0]
			elif arg == "T_suit_num":
				T_suit_num = argu[0]

			if linenum == 0:
				status = 0

# script name
for phi_i in range(len(phi_str)):
		ds = dataset[phi_i]
		sig_st = sig_str[phi_i]
		property = phi_str[phi_i].split(';')
		if nsel_mode_val == "specify":
			# filename = model + '_spec_' + str(phi_i + 1) + '_size_' + tsf_size + '_mode_' + tsf_mode + '_valnselmode_' + nsel_mode_val + '_vall_' + val_l + '_valr_' + val_r + '_bugbudget_' + bugset_budget + '_bcr_' + str(behavior_change_rate) + '_parallel_' + parallelcompute + '_valFL.sh'
			filename = model + '_spec_' + str(phi_i + 1) + '_size_' + T_suit_num + '_valnselmode_' + nsel_mode_val + '_valLayer_' + str(valLayer) + '_bcr_' + str(
				behavior_change_rate) + '_valFL.sh'
		else:
			# filename = model + '_spec_' + str(phi_i + 1) + '_size_' + tsf_size + '_mode_' + tsf_mode + '_valnselmode_' + nsel_mode_val + '_bugbudget_' + bugset_budget + '_bcr_' + str(behavior_change_rate) + '_parallel_' + parallelcompute + '_valFL.sh'
			filename = model + '_spec_' + str(
				phi_i + 1) + '_size_' + T_suit_num + '_valnselmode_' + nsel_mode_val + '_bcr_' + str(
				behavior_change_rate) + '_valFL.sh'
		print(filename)
		param = '\n'.join(parameters)

		dir = os.getcwd() + '/scripts/'
		if os.access(dir,os.F_OK) is False:
			os.mkdir(dir)

		with open('scripts/'+filename,'w+') as bm:
			bm.write('#!/bin/sh\n')
			# bm.write('export PATH=/home/ubuntu/MATLAB/R2021b/bin/:$PATH\n')
			bm.write('csv=$1\n')
			bm.write('matlab -nodesktop -nosplash <<EOF\n\n')
			bm.write('clear;\n')
			bm.write('close all;\n')
			bm.write('clc;\n')
			bm.write('bdclose(\'all\');\n')

			# addpath
			bm.write('cd ' + addpath[0] + '\n')
			bm.write('addpath(genpath(\'' + addpath[0] + '\'));\n')
			bm.write('InitBreach;\n\n')

			# load dataset
			if ds != '':
				bm.write('D = load(\'' + ds + '\');\n')

			if dataset_nor != '':
				bm.write('dataset_nor = \'' + dataset_nor + '\';\n')
			elif dataset_nor == '':
				bm.write("dataset_nor = 'Null.mat';\n")

			bm.write("if strcmp(dataset_nor, 'Null.mat')\n")
			bm.write("    D_run = '';\n")
			bm.write("    is_nor = 0;\n")
			bm.write("else\n")
			bm.write("    D_run = load(dataset_nor);\n")
			bm.write("    is_nor = 1;\n")
			bm.write("end\n")

			# model parameters info
			bm.write('bm = \'' + bench + '\';\n')
			bm.write('mdl = \''+ model + '\';\n')
			# nn parameters
			bm.write('nn = load(\'' + nn + '\');\n')
			bm.write('net = nn.net;\n\n')

			# breach sim model parameters
			bm.write(param + '\n\n')

			# io parameters
			bm.write('sysconf.in_name = {\'' + in_name[0] + '\'')
			for inname in in_name[1:]:
				bm.write(',')
				bm.write('\'' + inname + '\'')
			bm.write('};\n')

			bm.write('sysconf.in_range = {[' + str(in_range[0][0]) + ' ' + str(in_range[0][1]) + ']')
			for ir in in_range[1:]:
				bm.write(',[' + str(ir[0]) + ' ' + str(ir[1]) + ']')
			bm.write('};\n')

			bm.write('sysconf.in_span = {' + in_span + '};\n')

			if icc_name == []:
				bm.write('sysconf.icc_name = {};\n')
			else:
				bm.write('sysconf.icc_name = {\'' + icc_name[0] + '\'')
				for iccname in icc_name[1:]:
					bm.write(',')
					bm.write('\'' + iccname + '\'')
				bm.write('};\n')
				
			if ic_const == []:
				bm.write('sysconf.ic_const = {};\n')
			else:
				bm.write('sysconf.ic_const = {' + ic_const[0])
				for iccon in ic_const[1:]:
					bm.write(',')
					bm.write('' + iccon)
				bm.write('};\n')

			bm.write('sysconf.ics_name = {\'' + ics_name[0] + '\'')
			for icsname in ics_name[1:]:
				bm.write(',')
				bm.write('\'' + icsname + '\'')
			bm.write('};\n')

			bm.write('sysconf.oc_name = {\'' + oc_name[0] + '\'')
			for ocname in oc_name[1:]:
				bm.write(',')
				bm.write('\'' + ocname + '\'')
			bm.write('};\n')

			bm.write('sysconf.oc_span = ' + oc_span + ';\n\n')

			bm.write('T_suit_num = ' + T_suit_num + ';\n')
			bm.write('nsel_mode_val = \'' + nsel_mode_val + '\';\n')
			bm.write('valLayer = ' + str(valLayer) + ';\n')
			bm.write('bugset_budget = ' + bugset_budget + ';\n')
			bm.write("behavior_change_rate = " + str(behavior_change_rate) + ";\n\n")

			bm.write('phi_str = \'' + property[1] + '\';\n')
			if bench == 'ACC':
				addNum = 1
			elif bench == 'AFC':
				addNum = 3
			elif bench == 'WT':
				addNum = 5
			elif bench == 'SC':
				addNum = 6
			bm.write('spec_i = ' + str(phi_i + addNum) + ';\n')
			bm.write('sig_str = ' + sig_st + ';\n\n')

			bm.write('covModel = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, [], [], [], T_suit_num, [], [], behavior_change_rate, [], [], [], nsel_mode_val, valLayer);\n')
			bm.write("mutationWeightList = covModel.constructVar('mutationWeightList');\n\n")

			bm.write('if numel(valLayer) == 1\n')
			bm.write("    resultPath = sprintf('result/%s_%d_%d_spec%d', bm, numel(covModel.networkStru), covModel.networkStru(1), spec_i);\n")
			bm.write('else\n')
			bm.write("    resultPath = sprintf('result/%s_%d_%d_spec%d_%d-%d/', bm, numel(covModel.networkStru), covModel.networkStru(1), spec_i, covModel.valLayer(1), covModel.valLayer(end));\n")
			bm.write('end\n')
			bm.write('mkdir(resultPath);\n')
			bm.write('bugset = bugGenerator(bugset_budget);\n\n')

			bm.write('sig_state = cell(1,T_suit_num);\n')
			bm.write('for sig = 1:T_suit_num\n')
			bm.write("    warning('off', 'all');\n")
			bm.write('    [sig_state{sig}.rob, sig_state{sig}.tau_s, sig_state{sig}.ic_sig_val, sig_state{sig}.oc_sig_val, sig_state{sig}.nn_hidden_out, sig_state{sig}.nn_output] = covModel.signalDiagnosis(mdl, covModel.testsuite{sig}, spec_i);\n')
			bm.write('    sig_state{sig}.in_sig = covModel.testsuite{sig};\n')
			bm.write("    fprintf('No Mutation Signal.%d finished!\\n', sig);\n")
			bm.write('end\n')
			bm.write("nobugMut_file = fullfile(resultPath, [mdl(1:end-2), '_nomutation.mat']);\n")
			bm.write("save(nobugMut_file, 'sig_state');\n\n")

			bm.write('%% Parallel compute codes\n')
			bm.write('pool = gcp(\'nocreate\');\n')
			bm.write('if ~isempty(pool)\n')
			bm.write('     delete(pool);\n')
			bm.write('end\n')
			bm.write('pool = parpool([2 10]);\n\n')

			bm.write('parfor idx = 1:size(mutationWeightList,1)\n')
			bm.write("    warning('off', 'all');\n")
			# bm.write('    covModel = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, [], [], [], T_suit_num, [], [], behavior_change_rate, [], [], [], nsel_mode_val, valLayer);\n')
			bm.write('    covModel.mutationParallelProcess(idx, mutationWeightList, bugset, resultPath);\n')
			bm.write('end\n\n')

			bm.write('quit force\n')
			bm.write('EOF\n')