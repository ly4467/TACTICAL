function [NC_activated_neurons] = NC(nn_hidden_out, activation_threshold)
    % compute basic neuron coverage
    
    % Input:
    % tau_s
    % hiddenOut: the results of hidden layers 
    % activation_threshold: activation threshold
    % Output:
    % NC_value: basic neuron coverage
    % NC_activated_neurons: a cell array recording the activated times of each neuron

    % r_size: the number of inputs; c_size: the number of layers
    [r_size, c_size] = size(nn_hidden_out);
    
    % record the activated neurons of each layer,记录每层有多少个激活的neuron {a,b,...,z}
    NC_activated_neurons = cell(1, c_size);
    
    % total number of neurons
    neuron_num = 0;
    
    % 数总共 neuron的个数，初始化NC_activated_neurons元胞数组
    for i = 1:c_size
        sz = size(nn_hidden_out{1,i});
        neuron_num = neuron_num + sz(1,1);
        NC_activated_neurons{1,i} = zeros(sz);      % NC_activated_neurons = {{cell1},{cell2},{cell3}} 为1*3，有3个30行1列的cell
    end

    % count the length of continuous activated interval for each neuron <- 并没有起到这个作用，再跑跑这个代码
    tempHiddenOut = NC_activated_neurons;
    
    % for each input 
    for i = 1:r_size
        for j = 1:c_size
    %         k = numel(hiddenOut{i,j});
    %         eval(['layer_',num2str(j), '_activated_neuron', '=',  'zeros(', num2str(k), ', 1)']);
    %         eval(['activated_neurons{1,', num2str(j), '} = layer_', num2str(j), '_activated_neuron' ]);
            tempHiddenOut{1,j}((nn_hidden_out{i,j} > activation_threshold)) = 1;    % 将输出值大于阈值的neuron设置为1,视为激活1次
            NC_activated_neurons{1,j} =  NC_activated_neurons{1,j} + tempHiddenOut{1,j};    % 累加激活次数
            tempHiddenOut{1,j} = zeros(size(tempHiddenOut{1,j}));
        end
    end

end
