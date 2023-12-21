function randSuccess = randFL(layerNum, neuronNum, li, i, topk, reptimes)
    % return success percentage of randomly fault localization of neuron (li, i)

    sucTimes = [];
    for rep = 1:reptimes
        randNNIdx = randperm((layerNum-1)*neuronNum, topk);
        nnIdx = (li-2)*neuronNum + i;
        sucTimes(end+1) = ismember(nnIdx, randNNIdx);
    end
    randSuccess = (sum(sucTimes)/reptimes);
end