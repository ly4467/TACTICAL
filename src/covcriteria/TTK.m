function [TTK_activated_neurons] = TTK(nn_hidden_out, t_interval, K)

    [r_size, c_size] = size(nn_hidden_out);
    TTK_activated_neurons = cell(1, c_size);
    
    neuron_num = 0;

    for i = 1:c_size
        sz = size(nn_hidden_out{1,i});
        neuron_num = neuron_num + sz(1,1);
        TTK_activated_neurons{1,i} = zeros(sz);
    end
    
    tempHiddenOut = TTK_activated_neurons;
    
    % if r_size < t_interval
    %     return;
    % end
    
    for i = 1:r_size
        for j = 1:c_size
            layerHiddenOutArray = cell2mat(nn_hidden_out(i,j)');
            %layerHiddenOutArray = sort(layerHiddenOutArray,'descend');
            %kth = layerHiddenOutArray(K,1);
            
            [~, idx] = sort(layerHiddenOutArray,'descend');
            for t = 1:K
                if nn_hidden_out{i,j}(idx(t)) == 0 
                    continue
                end
                tempHiddenOut{1,j}(idx(t)) = tempHiddenOut{1,j}(idx(t)) + 1;
            end
            
            %position_activated = (nn_hidden_out{i,j} >= kth);
            %tempHiddenOut{1,j}(position_activated) = tempHiddenOut{1,j}(position_activated) + 1;
            
            position_true = (tempHiddenOut{1,j} >= t_interval & (nn_hidden_out{i,j} < layerHiddenOutArray(idx(K)) | i == r_size) );  
            TTK_activated_neurons{1,j}(position_true) =  TTK_activated_neurons{1,j}(position_true) + 1;
            tempHiddenOut{1,j}(position_true) = 0; 
            
            position_false = (tempHiddenOut{1,j} < t_interval & nn_hidden_out{i,j} <= layerHiddenOutArray(idx(K)));  
            tempHiddenOut{1,j}(position_false) = 0;  
        end
    end

end