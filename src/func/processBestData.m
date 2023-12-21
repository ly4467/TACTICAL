function [RQ1_2_tab, RQ3_tab] = processBestData(filePathCell)
    
    for fileIdx = 1:numel(filePathCell)
        reg = load(filePathCell{fileIdx});
        bm_best_auc = reg.areaArr(:,1:8,1);
    end
    
    talantura_auc = zeros(12,8);
    ochiai_auc = zeros(12,8);
    dstar_auc = zeros(12,8);
    jaccard_auc = zeros(12,8);
    ku1_auc = zeros(12,8);
    ku2_auc = zeros(12,8);
    
    for bmi = 1:12
        for aci = 1:8
            talantura_auc(bmi, aci) = bm_best_auc{1,bmi}(1,aci); 
            ochiai_auc(bmi, aci) = bm_best_auc{1,bmi}(2,aci); 
            dstar_auc(bmi, aci) = bm_best_auc{1,bmi}(3,aci); 
            jaccard_auc(bmi, aci) = bm_best_auc{1,bmi}(4,aci); 
            ku1_auc(bmi, aci) = bm_best_auc{1,bmi}(5,aci); 
            ku2_auc(bmi, aci) = bm_best_auc{1,bmi}(6,aci); 
        end
    end
    
    metric_auc = {talantura_auc, ochiai_auc, dstar_auc, jaccard_auc, ku1_auc, ku2_auc};

    planA = zeros(6, 6);
    for i = 1:6
        for j = 1:6
            delta = metric_auc{1,i} - metric_auc{1,j};
            planA(i,j) = sum(delta(:) > 0);
        end
    end
    
    planA = planA/96;
    RQ1_2_tab = planA;
    % planA = [planA, sum(planA, 2)];
    
    % sort dstar_auc
    [sorted_dstar_auc, ranks] = sort(dstar_auc, 2, 'descend');
    [m, n] = size(dstar_auc);
    for i = 1:m
        for j = 1:n
            sorted_dstar_auc(i, j) = find(ranks(i, :) == j);
        end
    end
    
    % add the average ranking
    sorted_dstar_auc = [sorted_dstar_auc; mean(sorted_dstar_auc, 1)];
    RQ3_tab = sorted_dstar_auc;
end