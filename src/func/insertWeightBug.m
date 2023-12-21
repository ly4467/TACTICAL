function insertWeightBug(mdl, bug_mdl, weight_bug)
    % Given a simulink model and a weight bug, insertWeightBug can
    % insert this bug to the corresponding position of this simulink model.
    %
    % Inputs:
    %   mdl: simulink model
    %   bug_mdl: the name of the simulink model with inserted weight bug
    %   weight_bug: a weight bug, including the weight postion and a weight bug value
    %   layer_idx: 
    % Outputs:
    %   bug_mdl: the simulink model with inserted weight bug
    
    %%% usage of find_system function
    % nn_blocks = find_system('WT_FFNN_trainbfg_5_5_5_Dec_22/Feed-Forward Neural Network','LookUnderMasks','on');
    % nn_blocks consists of the name of all the blocks
    
    %%% usage of get_param function
    % param_list = get_param('model/XXX_block','DialogParameters')
    % param_list contains all of the numeric fields about XXX_block, then you
    % can rerun this funtion to get the value of the numeric field you want
    % get_param('model/XXX_block','numeric field 1')
    %%% usage of set_param function
    % set_param('model/XXX_block','numeric field 1', 'value')
    
    % obtain the absolute path of mdl file
    mdl_path = which([mdl, '.slx']);

    % copy original simulink model as the new model with a weight bug
    path = erase(mdl_path, [mdl, '.slx']);
    copyfile(mdl_path, [path, bug_mdl, '.slx']);
    % load the model to be inserted a weight bug
    load_system(bug_mdl);

    bug_value = weight_bug;
    
    % obtain the name of current suspicious weight. But currently, matlab
    % can only obtain all weights whose right endpoints are the same as that of current
    % suspicious weight.

    % if contains(bug_mdl, 'WT') || contains(bug_mdl, 'ACC')
    %     % weight block name
    %     weight_str = [bug_mdl, '/Feed-Forward Neural Network/Layer ', num2str(layer_idx), '/b{',num2str(layer_idx),'}'];
    % elseif contains(bug_mdl, 'AFC')
    %     weight_str = [bug_mdl, '/Air Fuel Control Model 1/Feed-Forward Neural Network/Layer ', num2str(layer_idx), '/b{',num2str(layer_idx),'}'];
    % else
    %     error('The target blocks can not be found!');
    % end
    
    layer_idx = weight_bug(1, 1);
    right_idx = weight_bug(1, 2);
    left_idx = weight_bug(1, 3);
    bug_value = weight_bug(1, 4);

    if contains(bug_mdl, 'WT') || contains(bug_mdl, 'ACC')
        weight_str = [bug_mdl, '/Feed-Forward Neural Network/Layer ', ...
            num2str(layer_idx), '/LW{', num2str(layer_idx), ',', num2str(layer_idx-1), '}/IW{', num2str(layer_idx), ',', num2str(layer_idx-1), ...
            '}(', num2str(right_idx), ',:)'''];
    elseif contains(bug_mdl, 'AFC')
        weight_str = [bug_mdl, '/Air Fuel Control Model 1/Feed-Forward Neural Network/Layer ', ...
            num2str(layer_idx), '/LW{', num2str(layer_idx), ',', num2str(layer_idx-1), '}/IW{', num2str(layer_idx), ',', num2str(layer_idx-1), ...
            '}(', num2str(right_idx), ',:)'''];
    else
        error('The target blocks can not be found!');
    end    

    
    % includes all weights whose right endpoints are the same as that of current
    % target weight.
    cur_weight_row_str = get_param(weight_str, 'Value');
    
    % split the str by semicolon ';'
    cur_weight_row_str = erase(cur_weight_row_str, '[');
    cur_weight_row_str = erase(cur_weight_row_str, ']');
    cur_weight_row_cell = strsplit(cur_weight_row_str, ';');
    
    % obtain the target weight
    target_weight_str = cur_weight_row_cell{1,left_idx};
    % we can specify the number of significant digits of vpa funciton. Since the target weight is
    % in a state of flux, there is no need to pursue a absolutely precious value.
    target_weight = vpa(target_weight_str, 100);
    % insert the weight bug
    target_weight = target_weight + bug_value;
    % sym to str
    target_weight_str = char(target_weight);
    % replace sps_weight_str to target_weight_str
    cur_weight_row_cell{1,left_idx} = target_weight_str;
    
    % assemble cur_weight_row_str
    new_weight_row_str = '';
    new_weight_row_str = strjoin(cur_weight_row_cell, ';');
    new_weight_row_str = ['[', new_weight_row_str, ']'];
    
    % apply the weight with a inserted bug
    set_param(weight_str, 'Value', num2str(new_weight_row_str));
    
    % save the model with a weight bug
    % save_system(bug_mdl, [],'OverwriteIfChangedOnDisk',true, 'SaveAsVersion', 'R2021a');
    save_system(bug_mdl);
end