function randSuccess = randFL(layerNum, neuronNum, li, i, topk, reptimes)
    % 返回random方法进行错误定位layer li index i的neuron是否成功
    % Input: reptimes-重复进行random FL的次数，确保曲线是随topk增长平滑上升的

    sucTimes = [];
    for rep = 1:reptimes
        % random生成可疑neuron信息
        % randWeightIdx = randperm((layerNum-1)*neuronNum*neuronNum, topk);
        % weightIdx = (li-2)*neuronNum*neuronNum + (i-1)*neuronNum + j;
        % sucTimes(end+1) = ismember(randWeightIdx, randIdx);

        randNNIdx = randperm((layerNum-1)*neuronNum, topk);
        nnIdx = (li-2)*neuronNum + i;
        sucTimes(end+1) = ismember(nnIdx, randNNIdx);
    end
    randSuccess = (sum(sucTimes)/reptimes);
end