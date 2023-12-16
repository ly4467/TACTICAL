function sps_score = spsScoreCompute(cov_metric, con_spectrum, sps_metric)
    % spsScoreCompute function compute sps score of each neuron under different cov_metric and sps_metric.
    %
    % Inputs:
    %   con_spectrum: contribution spectrum of all neural weights
    %   sps_metric: suspiciousness metric, i.e., Tarantula, OChiai, D*
    % Outputs:
    %   sps_score: suspiciousness score of all neural weights 
    
    layerNum = numel(con_spectrum{1,1});
    % neuron_num = numel(con_spectrum{1,1}{1,1});

    % initialize sps_score
    sps_score = cell(1,numel(cov_metric));
    for cov = 1:numel(cov_metric)
        sps_score{cov} = zeros(numel(con_spectrum{1,1}{1,1}), layerNum);
    end

    % calculate the suspiciousness score for each neural weight and record the topk neural weights
    for cov = 1:numel(cov_metric)
        for li = 1: layerNum
            [row, ~] = size(con_spectrum{cov}{1,li});
            for i = 1:row
                cs = con_spectrum{cov}{1,li}{i};
                single_sps_score = spsCalculator(cs(1,1), cs(1,3), cs(1,2), cs(1,4), sps_metric);
                % update the score of current neural weight
                sps_score{cov}(i,li) = single_sps_score;
            end
        end
    end
end