function [TPKNC_activated_neurons] = TPKNC(nn_hidden_out, K)
    % compute top-k neuron coverage
    
    % Input:
    % nn_hidden_out: the results of hidden layers
    % K: Top-K neurons of each layer 
    % Output:
    % TPKNC_value: top-k neuron coverage
    % TPKNC_activated_neurons: a cell array recording the activated times of each neuron
    
    % r_size: the number of inputs; c_size: the number of layers
    [r_size, c_size] = size(nn_hidden_out);
    
    % total number of neurons
    neuron_num = 0;
    
    % record the top-k activated neurons of each layer
    TPKNC_activated_neurons = cell(1, c_size);
    
    for i = 1:c_size
        sz = size(nn_hidden_out{1,i});
        neuron_num = neuron_num + sz(1,1);
        TPKNC_activated_neurons{1,i} = zeros(sz);
    end
    
    tempHiddenOut = TPKNC_activated_neurons;
    
    % for each input
    for i = 1:r_size
        for j = 1:c_size
            layerHiddenOutArray = cell2mat(nn_hidden_out(i,j)');
            layerHiddenOutArray = sort(layerHiddenOutArray,'descend');
            kth = layerHiddenOutArray(K+1,1);   
            tempHiddenOut{1,j}(nn_hidden_out{i,j} > kth) = 1;   % nn_hidden_out{i,j} >= kth ----> nn_hidden_out{i,j} > kth
            TPKNC_activated_neurons{1,j} = TPKNC_activated_neurons{1,j} + tempHiddenOut{1,j};
            tempHiddenOut{1,j} = zeros(size(tempHiddenOut{1,j}));
        end
    end

end


