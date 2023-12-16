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
topk = ''
sps_metric = []
tsf_size = ''
tsf_mode = ''
nsel_mode_fl = ''
fl_l = ''
fl_r = ''
nsel_mode_val = ''
val_l = ''
val_r = ''
behavior_change_rate = []
bugset_budget = ''
# coverage criteria
cov_metric = []
act_param = []
T_suit_num = ''
parallelcompute = ''
window = ''

# script parameters
status = 0
arg = ''
linenum = 0

# For testing, delete this line after test
file = "/Users/ly/Desktop/new-project/test/config/ACC/fl_model_10_10_10"

# Change to "with open(sys.argv[1],'r') as conf:"
with open(sys.argv[1], 'r') as conf:
#with open(file, 'r') as conf:
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
			elif arg == 'topk':
				topk = argu[0]
			elif arg == 'tops':
				tops = argu[0]
			elif arg == 'sps_metric':
				sps_metric.append(argu[0])
			elif arg == 'tsf_size':
				tsf_size = argu[0]
			elif arg == 'tsf_mode':
				tsf_mode = argu[0]
			elif arg == 'nsel_mode_fl':
				nsel_mode_fl = argu[0]
			elif arg == 'fl_l':
				fl_l = argu[0]
			elif arg == 'fl_r':
				fl_r = argu[0]
			elif arg == 'nsel_mode_val':
				nsel_mode_val = argu[0]
			elif arg == 'val_l':
				val_l = argu[0]
			elif arg == 'val_r':
				val_r = argu[0]
			elif arg == 'behavior_change_rate':
				for i in range(len(argu)):
					behavior_change_rate.append(float(argu[i]))
			elif arg == 'bugset_budget':
				bugset_budget = argu[0]
			elif arg == "cov_metric":
				cov_metric.append(argu[0])
			elif arg == "act_param":
				reg = []
				for i in range(len(argu)):
					reg.append(float(argu[i]))
				act_param.append(str(reg))
			elif arg == "T_suit_num":
				T_suit_num = argu[0]
			elif arg == "parallelcompute":
				parallelcompute = argu[0]
			elif arg == "window":
				window = argu[0]

			if linenum == 0:
				status = 0


# script name
for phi_i in range(len(phi_str)):
		ds = dataset[phi_i]
		sig_st = sig_str[phi_i]
		property = phi_str[phi_i].split(';')

		# 这一行和valFL.py的文件不一样
		filename = model + '_spec_' + str(phi_i + 1) + '_size_' + T_suit_num + '_FL.sh'

		print(filename)
		param = '\n'.join(parameters)

		dir = os.getcwd() + '/scripts/'
		if os.access(dir,os.F_OK) is False:
			os.mkdir(dir)

		with open('scripts/'+filename,'w+') as bm:
			bm.write('#!/bin/sh\n')
			bm.write('export PATH=/home/ubuntu/MATLAB/R2021b/bin/:$PATH\n')
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
			bm.write('T_suit_num = ' + T_suit_num + ';\n')
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

			# specification
			bm.write('phi_str = \'' + property[1] + '\';\n')
			bm.write('spec_i = ' + str(phi_i + 1) + ';\n')
			bm.write('sig_str = ' + sig_st + ';\n\n')

			# fault localization parameters
			bm.write('cov_metric = {\'' + cov_metric[0] + '\'')
			for metric in cov_metric[1:]:
				bm.write(',')
				bm.write('\'' + metric + '\'')
			bm.write('};\n')

			bm.write('act_param = {' + act_param[0])
			for param in act_param[1:]:
				bm.write(',')
				bm.write(param)
			bm.write('};\n')


			bm.write('sps_metric = {\'' + sps_metric[0] + '\'')
			for metric in sps_metric[1:]:
				bm.write(',')
				bm.write('\'' + metric + '\'')
			bm.write('};\n')

			bm.write('topk = ' + topk + ';\n')
			bm.write('window = ' + window + ';\n')

			bm.write('nsel_mode_fl = \'' + nsel_mode_fl + '\';\n')
			bm.write('fl_l = ' + fl_l + ';\n')
			bm.write('fl_r = ' + fl_r + ';\n')

			bm.write('test = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, cov_metric, act_param, sps_metric, T_suit_num, topk, window, behavior_change_rate, nsel_mode_fl, fl_l, fl_r, 0, 0, 0);\n\n')

			bm.write("[sig_state, sps_info] = test.runFL(mdl, D.tr_in_cell);\n")
			bm.write("FLdir = ['result/', date, '-', bm, '_sigsetsize_', num2str(T_suit_num), '_topk_', num2str(topk), 'FL', '/'];\n")
			bm.write("FL_file = [FLdir, mdl, '_sigsetsize_', num2str(T_suit_num), '_topk_', num2str(topk), '_FL', '.mat'];\n")
			bm.write("mkdir(FLdir);\n")
			bm.write("save(FL_file, 'sig_state', 'sps_info');\n\n")

			bm.write('quit force\n')
			bm.write('EOF\n')