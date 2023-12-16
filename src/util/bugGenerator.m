function [bugSet] = bugGenerator(budget, func_sel)
    % bugGenerator function returns a set of bugs, given a lb and an ub. (for RQ1)
    %  
    % Inputs:
    %   lb: lower bound
    %   ub: upper bound
    %   size: the number of bugs
    % Outputs:
    %   bugSet: a set of bugs
    
    
    if func_sel == 1
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
        bugSet = bugSet(3:end);

    elseif func_sel == 2

        % sz = budget;
        % bugSet = linspace(lb, ub, size);
        bugSet = linspace(-0.4, 0.4, 10);

        % if 0 is included in bugSet, romove it.
        is_zero = ismember(bugSet, 0);
        bugSet = bugSet(~is_zero);

        pos = bugSet( (1+(10/2)) : 10 );     % 8 --> sz
        bugSet = [];
        mat = [pos', -pos'];
        [row, ~] = size(mat);
        for i = 1:row
            bugSet = [bugSet, mat(i,:)];
        end
        bugSet = [0 bugSet];    % 加入0，验证信号的rob前后是否一致，不一致则报错
        bugSet = [bugSet 1 -1 1.5 -1.5 2 -2 4 -4 8 -8];

        % bugSet = [0 0.02 -0.02 0.04 -0.04 0.08 -0.08 0.16 -0.16 0.32 -0.32 1 -1 1.5 -1.5 2 -2 4 -4 8 -8];
        % bugSet = [0.02];
    end
end
