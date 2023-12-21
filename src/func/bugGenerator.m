function [bugSet] = bugGenerator(budget)
    % bugGenerator function returns a set of bugs, given a lb and an ub. (for RQ1)
    %  
    % Inputs:
    %   lb: lower bound
    %   ub: upper bound
    %   size: the number of bugs
    % Outputs:
    %   bugSet: a set of bugs

    bugSet = [];
    % gaussian distribution mean value set used to generate bugs
    gap = 1; % initial gap
    cur_gm = 0; % current gm
    gm_r = [];
    while numel(gm_r) < budget/2
        gm_r = [gm_r, cur_gm];
        cur_gm = cur_gm + gap; % update gm
        gap = gap * 2; % update gap
    end

    gm_l = -gm_r;
    % mean value set of gaussian distribution used to generate bugs
    gm = [gm_l', gm_r'];
    for r = 1:budget/2
        bugSet = [bugSet, gm(r,:)];
    end
    bugSet = bugSet(2:end);
end
