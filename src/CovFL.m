classdef CovFL < handle
    properties
        % model info
        bm              % benchmark
        mdl             % the model with problematic NN controller
        D               % dataset with test suite, for fault localization
        D_run
        is_nor
        T
        Ts
        t_span_num          % time span of signals 0~50s
        T_suit_num          % signal numbers in test suite

        % nn parameters
        net             % neural network controller
        networkStru         % nn structure (includes the output layer)
        layerNum       % the number of hidden layers (does not include output layer)
        weight          % weight of hidden layers and output layer stored as a cell array according to the layer index
        bias            % bias of hidden layers and output layer stored as a cell array according to the layer index

        % config of input signal of model
        in_name         % input signal of the model
        in_range        % the range of input signal
        in_span         % the time span of input signal
        % config of input signal of controller
        icc_name        % input constant of controller
        ics_name        % input signal of controller
        ic_const        % input constant value of controller
        % config of output signal of controller
        oc_name         % output signal of controller before repair
        oc_span         % the time span of output signal

        % specification
        phi
        phi_str 
        sig_str         
        spec_i

        % parameters of fault localization
        nsel_mode_fl
        % nsel_mode_fl == 'all', [all neurons in hidden layers]
        % nsel_mode_fl == 'specify', [only consider neurons in layer val_l~val_r]
        fl_l                 
        fl_r  

        % parameters of validation of fault localization
        nsel_mode_val
        % nsel_mode_val == 'all', [all neurons in hidden layers]
        % nsel_mode_val == 'specify', [only consider neurons in layer val_l~val_r]
        valLayer                               
        
        % Coverage criteria 
        cov_metric
        act_param
        sps_metric
        topk
        window
        behavior_change_rate
        testsuite
    end

    methods
        function this = CovFL(bm, mdl, D, D_run, is_nor, net, T, Ts, sysconf, phi_str, sig_str, spec_i, cov_metric, act_param, sps_metric, T_suit_num, topk, window, behavior_change_rate, nsel_mode_fl, fl_l, fl_r, nsel_mode_val, valLayer)
            
            this.bm = bm;
            this.mdl = mdl;
            this.D = D;
            this.D_run = D_run;
            this.is_nor = is_nor;
            this.T_suit_num = T_suit_num;

            this.T = T;
            this.Ts = Ts;
            this.t_span_num = T/Ts + 1;

            this.net = net;
            this.networkStru = [];
            for i = 1:this.net.numLayers
                this.networkStru = [this.networkStru, this.net.layers{i}.size];
            end

            this.layerNum = net.numLayers - 1;
            this.weight = cell(1, net.numLayers);
            this.bias = cell(1, net.numLayers);
            this.act = cell(1, net.numLayers);      

            for li = 1:this.layerNum + 1
                if li == 1
                    this.weight{1,li} = this.net.IW{1,1};
                else
                    this.weight{1,li} = this.net.LW{li,li-1};
                end
                this.bias{1,li} = this.net.b{li};
            end

            this.in_name = sysconf.in_name;
            this.in_range = sysconf.in_range;
            this.in_span = sysconf.in_span;
            this.icc_name = sysconf.icc_name;
            this.ics_name = sysconf.ics_name;
            this.ic_const = sysconf.ic_const;
            this.oc_name = sysconf.oc_name;

            this.phi_str = phi_str;
            this.phi = STL_Formula('phi', this.phi_str);
            this.sig_str = sig_str;
            this.spec_i = spec_i;
            
            this.nsel_mode_fl = nsel_mode_fl;
            this.fl_l = fl_l;
            this.fl_r = fl_r;
            this.nsel_mode_val = nsel_mode_val;
            this.valLayer = valLayer;
            if strcmp(this.nsel_mode_val, 'specify')
                if sum(this.valLayer==1)
                    msg = 'valLayer can not include Layer1!';
                    error(msg)
                elseif max(this.valLayer)>this.layerNum
                    msg = sprintf('valLayer maximum layer index can not lager than %d!', this.layerNum);
                    error(msg)
                end
            elseif strcmp(this.nsel_mode_val, 'all')
                this.valLayer = 2:this.layerNum;
            else
                error("nsel_mode_val error! Please check it!")
            end            

            this.cov_metric = cov_metric;
            this.act_param = act_param;
            this.sps_metric = sps_metric;
            this.topk = topk;
            this.window = window;
            this.behavior_change_rate = behavior_change_rate;
            this.testsuite = this.constructVar('testsuite');
        end
        
        function [rob, tau_s, ic_sig_val, oc_sig_val, nn_hidden_out, output] = signalDiagnosis(this, mdl, in_sig, spec_i)
            % signalDiagnosis function returns the robustness, tau_s, controller's input signal and controller's output signal of a system execution
            %
            % Inputs:
            %   mdl: simulink model
            %   in_sig: the input signals of the simulink model
            %   spec_i: specification index
            % Outputs:
            %   rob: robustness
            %   Br: BreachSimulinkSystem of the Simulink model
            %   tau_s: the first timestamp at which the robustness value turns negative
            %   ic_sig_val: input signal of controller
            %   oc_sig_val: output signal of controller
            
            Br = BreachSimulinkSystem(mdl);
            Br.Sys.tspan = 0:this.Ts:this.T;
            
            % unistep signal   
            input_gen.cp = this.T/this.in_span{1};      
            input_gen.type = 'UniStep';
            Br.SetInputGen(input_gen);
                        
            for i = 1:numel(this.in_name)
                for cpi = 0:input_gen.cp - 1
                    % eval(['Br.SetParamRanges({''',this.in_name{1,i},'_u',num2str(cpi),'''}, this.in_range{1,cpi+1});']);
                    eval(['Br.SetParam({''',this.in_name{1,i},'_u',num2str(cpi),'''}, in_sig{i}(1,cpi+1));']);
                end
            end
            
            % % varstep signal
            % if length(unique(this.in_span)) == 1
            %     con_type = 'UniStep';
            %     input_gen.cp = this.T/this.in_span(1,1);
            % else
            %     con_type = 'VarStep';
            %     input_gen.cp = this.T./this.in_span;
            % end
            % 
            % input_gen.type = con_type;
            % Br.SetInputGen(input_gen);
            % 
            % if strcmp(con_type, 'UniStep')
            %     for i = 1:numel(this.in_name)
            %         for cpi = 0:input_gen.cp - 1
            %             eval(['Br.SetParam({''',this.in_name{1,i},'_u',num2str(cpi),'''}, in_sig{1,i}(1,cpi+1));']);
            %         end
            %     end
            % elseif strcmp(con_type, 'VarStep')
            %     for i = 1:numel(this.in_name)
            %         for cpi = 0: input_gen.cp(1,i) - 1
            %             eval(['Br.SetParam({''',this.in_name{1,i},'_u',num2str(cpi),'''}, in_sig{1,i}(1,cpi+1));']);
            %             if cpi ~= input_gen.cp(1,i) - 1
            %                 eval(['Br.SetParam({''',this.in_name{1,i},'_dt',num2str(cpi),'''},this.in_span(1,i));']);
            %             end
            %         end
            %     end
            % end
            
            Br.Sim(0:this.Ts:this.T);
            rob = Br.CheckSpec(this.phi);   % return the robustness during [0, T] according to specification phi

            % extract ic signal and oc signal for forward impact analysis
            % (analysis the impact of a neural weight to the final result)
            ic_sig_val = sigMatch(Br, this.ics_name);   
            oc_sig_val = sigMatch(Br, this.oc_name);    % return the actual output_signal (the real signal not the name) of nn before repaired
            
            % normalization
            if this.is_nor == 1
                x_gain = this.D_run.ps_x.gain;
                x_gain = diag(x_gain);
                x_offset = this.D_run.ps_x.xoffset;
                ic_sig_val = ic_sig_val - x_offset;
                ic_sig_val = x_gain * ic_sig_val;

                y_gain = this.D_run.ps_y.gain;
                y_offset = this.D_run.ps_y.xoffset;
                oc_sig_val = oc_sig_val/y_gain;
                oc_sig_val = oc_sig_val + y_offset;
            end

            % calculate the tau_s according to the given specification
            if rob > 0
                tau_s = this.T;
            end
            
            if strcmp(this.bm, 'ACC')
                interval_LR = {[0,50]};
            elseif strcmp(this.bm, 'AFC') && spec_i == 3
                interval_LR = {[0,30]};
            elseif strcmp(this.bm, 'AFC') && spec_i == 4
                interval_LR = {[10,30]};
            elseif strcmp(this.bm, 'WT')
                interval_LR = {[4,4.9], [9,9.9], [14,14.9]};
            elseif strcmp(this.bm, 'SC')
                interval_LR = {[30,35]};
            end
            [nn_hidden_out, output] = neuronCompute(this, ic_sig_val);
           
            scan_interval = zeros(1, this.t_span_num);
            neg_interval = zeros(1, this.t_span_num);
            for scan_i = 1: numel(interval_LR)
                LR = interval_LR{1, scan_i};
                LR = LR./this.Ts;
                scan_interval(1, LR(1,1)+1:LR(1,2)+1) = 1;
            end

            if strcmp(this.bm, 'ACC') && spec_i == 1            
                left_neg_interval = sigMatch(Br, "d_rel") - 1.4 * sigMatch(Br, "v_ego") < 10;
                right_neg_interval = sigMatch(Br, "v_ego") > 30.1;
                neg_idx = (left_neg_interval + right_neg_interval > 0);    
                neg_interval(1, neg_idx) = 1;
            elseif strcmp(this.bm, 'ACC') && spec_i == 2
                delta = sigMatch(Br, "d_rel") - 1.4 * sigMatch(Br, "v_ego");
                % i == 500, i = 501, true
                for i = 1: 451
                    if delta(1, i) <= 12
                        i_behind = i + 50;
                        delta_behind = delta(1, i:i_behind);
                        if ~any(delta_behind > 12)
                            neg_interval(1, i_behind) = 1;
                        end
                    end
                end
            elseif strcmp(this.bm, 'AFC') && spec_i == 3
                af = sigMatch(Br, "AF");
                mu = abs(af - 14.7)/14.7;
                neg_interval(mu > 0.2) = 1;
            elseif strcmp(this.bm, 'AFC') && spec_i == 4
                af = sigMatch(Br, "AF");
                % i == 300, i = 301, true
                for i = 101: 286
                    if af(1, i) >= 1.1*14.7 || af(1, i) <= 0.9*14.7
                        i_behind = i + 15;
                        af_behind = af(1, i:i_behind);
                        if ~any(af_behind <= 1.1*14.7 & af_behind >= 0.9 *14.7)
                            neg_interval(1, i_behind) = 1;
                        end
                    end
                end
            elseif strcmp(this.bm, 'WT')
                h_error = abs(sigMatch(Br, "h_error"));
                neg_interval(h_error > 0.86) = 1;
            elseif strcmp(this.bm, 'SC')
                pressure = sigMatch(Br, "pressure");
                neg_interval(pressure < 87 | pressure > 87.5) = 1;
            end
            int_interval = neg_interval .* scan_interval;

            if ismember(1,int_interval)
                negl_idx = find(int_interval == 1);
                tau_s = (negl_idx(1,1) - 1) * this.Ts;
                % extract the input and output signals of nn controller in the interval [0, tau_s]
                ic_sig_val = ic_sig_val(:,1:negl_idx(1,1));
                oc_sig_val  = oc_sig_val(:,1:negl_idx(1,1));
            end
        end

        function [nn_hidden_out, output] = neuronCompute(this, signals)

            nn_hidden_out = cell(this.t_span_num, this.layerNum);
            output = cell(this.t_span_num, 1);

            % compute all neurons output during the execution of each signal
            % and save them into variable nn_hidden_out, output
            for j = 1: this.t_span_num
                for i = 1: this.net.numLayers
                    if i == 1
                        activationFcn = this.net.layers{i}.transferFcn();       % activationFcn = 'poslin' Positive linear transfer function ReLU
                        activationFcn = str2func(activationFcn);
                        nn_hidden_out{j, i} = activationFcn(this.weight{i}*signals(:,j) + this.bias{i});
                    elseif i > 1 && i <  this.net.numLayers
                        activationFcn = this.net.layers{i}.transferFcn();
                        activationFcn = str2func(activationFcn);
                        nn_hidden_out{j, i} = activationFcn(this.weight{i}*nn_hidden_out{j, i-1} + this.bias{i});
                    else
                        transFcn = this.net.layers{this.net.numLayers}.transferFcn();
                        transFcn = str2func(transFcn);
                        output{j, 1} = transFcn(this.weight{i}*nn_hidden_out{j, i-1} + this.bias{i});
                    end
                end
            end
        
        end

        function [sig_state, sig_stateAll, mutate, bugWeight, sig_success_rate, bug_mdl] = singleWeightMutate(this, bug, bugRealIdx, li, i, j, tsf_size)

            this.weight{li}(i,j) = this.weight{li}(i,j) + bug;
            bugWeight = this.weight{li}(i,j);
        
            % buggy model name
            bug_mdl = sprintf('%s_spec%d_M_%d_%d_%d_bug%d', this.bm, this.spec_i, li, i, j, bugRealIdx);
            insertWeightBug(this.mdl, bug_mdl, [li i j bug]);

            sig_stateAll = {};
            for sig = 1:tsf_size
                try
                    [sig_stateAll{end+1}.rob, sig_stateAll{end+1}.tau_s, sig_stateAll{end+1}.ic_sig_val, sig_stateAll{end+1}.oc_sig_val, sig_stateAll{end+1}.nn_hidden_out, sig_stateAll{end+1}.nn_output] = this.signalDiagnosis(bug_mdl, this.testsuite{1,sig}, this.spec_i);
                catch
                    msg = sprintf('\n signalDiagnosis Error!\n   error: %s,  signal: %d', bug_mdl, sig);
                    error(msg)
                end

                sig_stateAll{1,sig}.in_sig = this.testsuite{1,sig};
            end
            
            try
                this.weight{li}(i,j) = this.net.LW{li,li-1}(i,j);   % return model's nn into orignal parameters
            catch
                msg = sprintf('this.weight{li}(i,j) = this.net.LW{li,li-1}(i,j) Error!\n   bugmdl:%s   position: %d_%d_%d,  signal: %d', bug_mdl, li, i, j, sig);
                error(msg)                
            end
            [mutate, sig_success_rate, sig_state] = this.sigAnalyze(sig_stateAll);
            fprintf('Mutation finished.  Neuron Layer:%d,    Index:%d,   Weight:%d   Mutator no.%d,  covModel suite size:%d\n', li, i, j, bugRealIdx, tsf_size);
        end
        
        function [mutate, sig_success_rate, sigstateNew] = sigAnalyze(this, sig_state)

            % save all robustness and taus information
            mutArr = zeros(2, numel(sig_state));
            sigstateNew = {};
            for sig = 1:numel(sig_state)
                mutArr(1, sig) = sig_state{sig}.rob;
                mutArr(2, sig) = sig_state{sig}.tau_s;
                if sig_state{sig}.tau_s >= 1
                    sigstateNew{end+1} = sig_state{sig};
                end
            end
            mutArr(:, mutArr(2,:)<1) = [];

            if size(mutArr,2) < 20
                mutate = 0;
                sig_success_rate = 0;
                return
            end
            sig_success_rate = sum(mutArr(1,:)>=0)/size(mutArr,2);
            
            % mutation info: 1: mutation success，0: mutation failed
            if (sig_success_rate<=this.behavior_change_rate(2)) && (sig_success_rate>=this.behavior_change_rate(1))
                mutate = 1;
            else
                mutate = 0;
            end
        end

        function mutationParallelProcess(this, idx, mutationWeightList, bugset, resultPath) 
        
            li = mutationWeightList(idx,1);
            i = mutationWeightList(idx,2);
            j = mutationWeightList(idx,3);

            % bug = 1;
            % [sig_state, sig_stateAll, mutate, bugWeight, sig_success_rate, bug_mdl] = this.singleWeightMutate(bug, find(bugset==bug), li, i, j, this.T_suit_num);
            % if mutate
            %     % do nothing
            % else
            %     if sig_success_rate < this.behavior_change_rate(1)
            %         bugidxStartpos = 1;
            %         bugNum = find(bugset==1) - 2;
            %     elseif sig_success_rate > this.behavior_change_rate(2)
            %         bugidxStartpos = find(bugset==1);
            %         bugNum = numel(bugset) - bugidxStartpos;
            %     end
            % 
            %     for bugidx = 1:bugNum 
            %         bugidxReg = bugidx + bugidxStartpos;
            %         bug = bugset(bugidxReg);
            % 
            %         [sig_state, sig_stateAll, mutate, bugWeight, sig_success_rate, bug_mdl] = this.singleWeightMutate(bug, bugidxReg, li, i, j, this.T_suit_num);
            %         if (sig_success_rate<this.behavior_change_rate(1)) || mutate
            %             break
            %         end
            %     end
            % end

            for bugidx = 1:numel(bugset) 
                bug = bugset(bugidx);
                [sig_state, sig_stateAll, mutate, bugWeight, sig_success_rate, bug_mdl] = this.singleWeightMutate(normrnd(bug,1), bugidx, li, i, j, this.T_suit_num);
                if (sig_success_rate<this.behavior_change_rate(1)) || mutate
                    break
                end
            end

            FL_file = [resultPath, bug_mdl, '_mutate_', num2str(mutate), '.mat'];
            save(FL_file, "sig_state", "sig_stateAll", "bug", "bugset", "mutate", "bugWeight", "sig_success_rate");
            % parsaveMutInfo(FL_file, sig_state, sig_stateAll, bug, bugset, mutate, bugWeight, sig_success_rate);
            fprintf('Mutation File %s complete!', FL_file);
        end

        function var = constructVar(this, str)
            % initializeCell function can initialize the corresponding cell
            % according to str.
            %
            % Inputs:
            %   str: cell name
            % Outputs:
            %   intialized variable

            switch str
                case 'mutationWeightList'
                    var = [];
                    for li = this.valLayer
                        partWeightList = [];
                        for i = 1:this.networkStru(li)
                            partWeightList = [partWeightList; cat(2, (i*ones(1,this.networkStru(li)))', (1:this.networkStru(li))')];
                        end
                        partWeightList = cat(2, ones(size(partWeightList,1),1)*li, partWeightList);
                        var = [var; partWeightList];
                    end
                case 'testsuite'
                    var = {};
                    for i = 1: numel(this.D.tr_in_cell)
                        if this.D.tr_rob_set(i,1) > 0
                            var{end+1} = this.D.tr_in_cell{1,i};
                        end
                    end
                otherwise
                    error('Check cell name!');
            end
        end
    end
end


            