function [spsRate, neuronSpsCell] = spstopkAnalyze(all_neuronSpsScoreCell, repTimes, topk, networkStru)

    layerNum = numel(networkStru);
    neuronNum = networkStru(1);
    nnMat = [];
    for li = 2:layerNum
        neuronReg = 1:neuronNum;
        layerReg = li*ones(1,neuronNum);
        nnMat = [nnMat; cat(2, layerReg', neuronReg')];
    end

    sucFLRatePage = [];
    neuronSpsCell = cell(1, numel(all_neuronSpsScoreCell));
    % parfor mut = 1:numel(all_neuronSpsScoreCell)
    for mut = 1:numel(all_neuronSpsScoreCell)

        li = all_neuronSpsScoreCell{mut}.layerIdx;
        i = all_neuronSpsScoreCell{mut}.neuronIdx;
        j = all_neuronSpsScoreCell{mut}.lastIdx;
        spsData = all_neuronSpsScoreCell{mut}.spsScore;
        sucFLRate = zeros(size(spsData));
        neuronSpsReg = cell(size(spsData));

        for sps = 1:size(spsData,1)
            for cov = 1:size(spsData,2)
                
                % actTimesMat = reshape(all_neuronSpsScoreCell{mut}.actTimes{cov}(:,2:end), [neuronNum*(layerNum-1) 1]);
                % spsMat = cat(2, reshape(spsData{sps,cov}(:,2:end), [neuronNum*(layerNum-1) 1]), actTimesMat, nnMat);
                % spsMat(isnan(spsMat)) = 0;     % If sps score = NaN, let it equals 0
                % spsMat = sortrows(spsMat, [-1 -2]);
                % 
                % neuronSpsList = spsMat(1:topk, [1 3 4]);
                % sucFLRate(sps,cov) = ismember([li i], neuronSpsList(:,2:3), 'rows');
                
                sucFLMat = [];
                spsMat = cat(2, reshape(spsData{sps,cov}(:,2:end), [neuronNum*(layerNum-1) 1]), nnMat);
                spsMat(isnan(spsMat)) = 0;     % If sps score = NaN, let it equals 0
                spsMat = sortrows(spsMat, -1);
                [~, uniqueIndex, ~] = unique(spsMat(:,1), 'stable');
                rankings = zeros(size(spsMat, 1), 1);
                % sort sortedData according to the value of first column
                % same rank for same ranking
                for uni = 1:numel(uniqueIndex)
                    if uni == numel(uniqueIndex)
                        rankings(uniqueIndex(uni):end) = uni;
                        break
                    end
                    rankings(uniqueIndex(uni):uniqueIndex(uni+1)-1) = uni;
                end
                spsMatRank = cat(2, spsMat, rankings);

                randSps = spsMatRank(spsMatRank(:,1) == 0, :);
                spsMatRank(spsMatRank(:,1) == 0, :) = [];
                neuronSpsList = spsMatRank(ismember(spsMatRank(:,end),1:topk),1:end);

                % topk num > neuronSpsList's neurons num && neuronSpsList didn't find buggy neuron
                if size(neuronSpsList,1) < topk && ~ismember([li i], neuronSpsList(:,2:3), 'rows')
                    for rep = 1:repTimes
                        randSpsIdx = randperm(size(randSps,1), topk - size(neuronSpsList,1));
                        randSpsList = randSps(randSpsIdx,:);
                        sucFLMat(end+1) = ismember([li i], randSpsList(:,2:3), 'rows');
                    end
                    neuronSpsList = cat(1, neuronSpsList(:,1:end-1), randSpsList(:,1:end-1));

                % topk num > neuronSpsList's neurons num && neuronSpsList find buggy neuron    
                elseif size(neuronSpsList,1) < topk && ismember([li i], neuronSpsList(:,2:3), 'rows')
                    sucFLMat = ones(1,repTimes);
                    randSpsIdx = randperm(size(randSps,1), topk - size(neuronSpsList,1));
                    randSpsList = randSps(randSpsIdx,:);
                    neuronSpsList = cat(1, neuronSpsList(:,1:end-1), randSpsList(:,1:end-1));

                % topk num <= neuronSpsList's neurons num && neuronSpsList didn't find buggy neuron
                elseif size(neuronSpsList,1) >= topk && ~ismember([li i], neuronSpsList(:,2:3), 'rows')
                    sucFLMat = zeros(1,repTimes);
                    neuronSpsList = neuronSpsList(1:topk,1:end-1);

                % topk num <= neuronSpsList's neurons num && neuronSpsList find buggy neuron
                elseif size(neuronSpsList,1) >= topk && ismember([li i], neuronSpsList(:,2:3), 'rows')

                    % decide which is more suspicious randomly
                    checkArr = neuronSpsList(neuronSpsList(:,end) <= neuronSpsList(end,end)-1,:);
                    randArr = neuronSpsList(neuronSpsList(:,end) == neuronSpsList(end,end),1:end);
                    randNum = topk - size(checkArr,1);
                    if ~ismember([li i], checkArr(:,2:3), 'rows') && randNum < size(randArr,1) && topk > size(checkArr,1)
                        for rep = 1:repTimes
                            randSpsIdx = randperm(size(randArr,1), randNum);
                            randSpsList = randArr(randSpsIdx,:);
                            sucFLMat(end+1) = ismember([li i], randSpsList(:,2:3), 'rows');
                        end
                        neuronSpsList = cat(1, checkArr(:,1:end-1), randSpsList(:,1:end-1));
                    % 防止出现topk=1，checkArr中有两个分数相同的neuron的类似情况，此情况下randNum<0
                    elseif ~ismember([li i], checkArr(:,2:3), 'rows') && topk <= size(checkArr,1)
                        sucFLMat = zeros(1,repTimes);
                        neuronSpsList = checkArr(1:topk,1:end-1);
                    else
                        sucFLMat = ones(1,repTimes);
                        spsIndex = ismember(neuronSpsList(:,2:3), [li i], 'rows');
                        neuronSpsInfo = neuronSpsList(spsIndex,:);
                        neuronSpsList(spsIndex,:) = [];

                        neuronSpsList = cat(1, neuronSpsList(1:topk-1,1:end-1), neuronSpsInfo(:,1:end-1));
                        neuronSpsList = sortrows(neuronSpsList, 1, 'descend');
                    end

                % bug
                else
                    msg = sprintf('Error in spstopkAnalyze.m, layer:%d, neuron:%d,  topk:%d,   size(neuronSpsList,1):%d', li, i, topk, size(neuronSpsList,1));
                    error(msg)
                end
                sucFLRate(sps,cov) = sum(sucFLMat)/repTimes;
                

                neuronSpsReg{sps,cov} = neuronSpsList;
            end
        end
        sucFLRatePage = cat(3, sucFLRatePage, sucFLRate);
        neuronSpsCell{1,mut}.neuronSpsList = neuronSpsReg;
        neuronSpsCell{1,mut}.layerIdx = li;
        neuronSpsCell{1,mut}.neuronIdx = i;
        neuronSpsCell{1,mut}.lastIdx = j;
    end
    spsRate = sum(sucFLRatePage, 3)/numel(all_neuronSpsScoreCell);
end