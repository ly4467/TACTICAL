function [sig_state, sps_info, covPercentage] = nnresultEval(networkStru, cov_metric, sps_metric, sig_state, act_param)

    [~, layerNum] = size(sig_state{1,1}.nn_hidden_out);
    new_sps_spectrum = cell(1,numel(cov_metric));
    for cov = 1:numel(cov_metric)
        new_sps_spectrum{cov} = cell(1,layerNum);
        for li = 1: layerNum 
            neuronNum = numel(sig_state{1,1}.nn_hidden_out{1,li});
            new_sps_spectrum{cov}{li} = cell(neuronNum,1);
            for i = 1:neuronNum
                new_sps_spectrum{cov}{li}{i,1} = zeros(1,4);
            end
        end
    end
    
    actnnNumArr = zeros(1, numel(cov_metric));
    for sig = 1:numel(sig_state)
        [sig_state{1,sig}.cov_activation, actnnNum_reg] = newparamactCompute(networkStru, cov_metric, act_param, sig_state{1,sig}.tau_s, sig_state{1,sig}.nn_hidden_out, sig_state{1,sig}.rob);
        actnnNumArr = actnnNumArr + actnnNum_reg;
    end
    actnnNumArr_avg = actnnNumArr/numel(sig_state);
    covPercentage = actnnNumArr_avg/sum(networkStru(2:end));

    for sig = 1:numel(sig_state)
        for cov = 1:numel(cov_metric)
            for li = 1:layerNum
                for j = 1:numel(sig_state{1,1}.nn_hidden_out{1,li})

                    if sig_state{1,sig}.cov_activation{cov}(j,li) >= 1 && sig_state{1,sig}.rob>0
                        new_sps_spectrum{cov}{li}{j}(1) = new_sps_spectrum{cov}{li}{j}(1)+1;     % as, activated and successed

                    elseif sig_state{1,sig}.cov_activation{cov}(j,li) >= 1 && sig_state{1,sig}.rob <= 0
                        new_sps_spectrum{cov}{li}{j}(2) = new_sps_spectrum{cov}{li}{j}(2)+1;     % af, activated and failed

                    elseif sig_state{1,sig}.cov_activation{cov}(j,li) == 0 && sig_state{1,sig}.rob > 0
                        new_sps_spectrum{cov}{li}{j}(3) = new_sps_spectrum{cov}{li}{j}(3)+1;     % ns, unactivated and successed
                        
                    elseif sig_state{1,sig}.cov_activation{cov}(j,li) == 0 && sig_state{1,sig}.rob <= 0
                        new_sps_spectrum{cov}{li}{j}(4) = new_sps_spectrum{cov}{li}{j}(4)+1;     % nf, unactivated and failed
                    end
                    
                end
            end
        end
    end
    
    reg = {};
    for sps = 1:numel(sps_metric)
        % sps_weight_info结构 cov-> array topk*3, sps_score结构 cov-> nn
        reg = cat(1, reg, spsScoreCompute(cov_metric, new_sps_spectrum, sps_metric{sps}));
        % for cov = 1:numel(cov_metric)
        %     % 删除第一列有关Layer1 neuron的信息，不对Layer1做可疑分析
        %     reg{sps,cov}(:,1) = [];
        % end
    end
    
    % % 不要合并这个for循环和上面的那个for循环，会出bug！
    % for cov = 1:numel(cov_metric)
    %     new_sps_spectrum{cov}(1) = [];
    % end
    sps_info.sps_spectrum = new_sps_spectrum;
    sps_info.sps_name = sps_metric;
    sps_info.sps_score = reg;
end

function [act, actnnNum] = newparamactCompute(networkStru, cov_metric, act_param, tau_s, nn_hidden_out, rob)

    % 如果taus比较长的话取固定的时间窗口,这里还需要确定窗口长度和判定范围
    if rob >= 0
        % Do nothing when the signal is passed
    elseif rob < 0
        % start_time = tau_s - window;
        % start_slice = 1 + int16(start_time/0.1);
        % end_slice = 1 + int16(tau_s/0.1);
        % 
        % nn_hidden_out = nn_hidden_out(start_slice:end_slice,:);
        end_slice = 1 + int16(tau_s/0.1);
        nn_hidden_out = nn_hidden_out(1:end_slice,:);        
    end

    act = cell(1,numel(cov_metric));
    actnnNum = [];
    for i = 1: numel(cov_metric)
        
        [~, layerNum] = size(nn_hidden_out);
        var = cell(1,layerNum);
        for li = 1: layerNum 
            var{li} = zeros(numel(nn_hidden_out{1,li}), 1);
        end

        act{i} = var;
        cov = cov_metric{i};

        switch cov
            case 'nc'   % (1) threshold
                [act{i}] = NC(nn_hidden_out, act_param{1});    
                % v为cov值，a_neurons为1*3 cell，每个cell为30*1，里面有该层30个神经元在501个时间点上的激活次数
                % 因为nc是判断每个时间点上neuron输出值是否大于阈值，所以神经元可以激活501次
                
            case 'tkc'
                [act{i}] = TPKNC(nn_hidden_out, act_param{2});     % (1) topk
                
            case 'tnc'
                [act{i}] = TimedNC(nn_hidden_out, act_param{3}(1), act_param{3}(2)); % (1): t_interval. (2) threshold
            
            case 'ttk'
                [act{i}] = TTK(nn_hidden_out, act_param{4}(1), act_param{4}(2));     % (1): t_interval. (2) topk
                
            case 'pd'
                [act{i}] = PDNC(nn_hidden_out, act_param{5}(1), act_param{5}(2));     % (1): t_interval. (2) diff_threshold
                
            case 'nd'
                [act{i}] = NDNC(nn_hidden_out, act_param{6}(1), act_param{6}(2));     % (1): t_interval. (2) diff_threshold
                
            case 'mi'
                [act{i}] = MINC(nn_hidden_out, act_param{7});     % (1): t_interval
                
            case 'md'
                [act{i}] = MDNC(nn_hidden_out, act_param{8});      % (1): t_interval
            
            otherwise
                error("Please check the cov_metric!")
        end
        act{i} = cell2mat(act{i})>0;
        actnnNum = [actnnNum sum(sum(act{i}))];
    end

end

