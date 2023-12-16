function [MINC_activated_neurons] = MINC(nn_hidden_out, t_interval)
    % compute monotonic increase neuron coverage
    
    % Input:
    % nn_hidden_out: the results of hidden layers 
    % t_interval: time interval
    % Output:
    % MINC_value: monotonic increase neuron coverage
    % MINC_activated_neurons: a cell array recording the activated times of each neuron

    % r_size: the number of inputs; c_size: the number of layers
    [r_size, c_size] = size(nn_hidden_out);
    
    % record the activated neurons of each layer
    MINC_activated_neurons = cell(1, c_size);
    
    % total number of neurons
    neuron_num = 0;
    
    for i = 1:c_size
        sz = size(nn_hidden_out{1,i});
        neuron_num = neuron_num + sz(1,1);
        MINC_activated_neurons{1,i} = zeros(sz);
    end
    
    % count the length of continuous activated interval for each neuron
    MI_tempHiddenOut = MINC_activated_neurons;
    
    % % if r_size is less than t_interval, there is no MINC
    % if r_size < t_interval
    % 
    %     return;
    % end
    
    % input squence
    for i = 2:r_size
        for j = 1:c_size
            good_position = (nn_hidden_out{i,j} > nn_hidden_out{i-1,j});
            MI_tempHiddenOut{1,j}(good_position) = MI_tempHiddenOut{1,j}(good_position) + 1;
            
            if i == r_size 
                for goodidx = find(good_position==1)'
                    if MI_tempHiddenOut{1,j}(goodidx) >= t_interval
                        MINC_activated_neurons{1,j}(goodidx) = MINC_activated_neurons{1,j}(goodidx) + 1;
                    end
                end
            end
            
            %bad_postion = (nn_hidden_out{i,j} < nn_hidden_out{i-1,j});
            %if MI_tempHiddenOut{1,j}(bad_postion) > t_interval
            %    MINC_activated_neurons{1,j}(bad_postion) = MINC_activated_neurons{1,j}(bad_postion) + 1;
            %end
		    bad_position = (nn_hidden_out{i,j} <= nn_hidden_out{i-1,j});
		    for index = 1: numel(bad_position)
			    if bad_position(index, 1) ==1 & MI_tempHiddenOut{1,j}(index)>= t_interval
				    MINC_activated_neurons{1,j}(index, 1) = MINC_activated_neurons{1,j}(index, 1) + 1;
			    end
		    end
            MI_tempHiddenOut{1,j}(bad_position) = 0;
        end
    end


end

