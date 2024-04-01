clc
clear

AUC_Bench_App_Tarantula = [
0.07632 	0.07922 	0.07611 	0.07190 	0.08003 	0.06502 	0.08002 	0.06629 
0.04244 	0.04292 	0.04331 	0.04477 	0.03465 	0.04001 	0.03523 	0.02865 
0.06449 	0.04778 	0.06877 	0.07106 	0.08466 	0.07389 	0.08443 	0.08080 
0.08231 	0.06470 	0.06475 	0.07414 	0.05896 	0.06545 	0.06091 	0.06584 
0.09045 	0.08343 	0.09992 	0.04782 	0.09895 	0.09519 	0.07995 	0.04151 
0.07973 	0.07148 	0.09503 	0.03987 	0.09336 	0.08471 	0.07460 	0.05210 
0.07747 	0.06925 	0.09502 	0.05741 	0.07138 	0.08867 	0.05715 	0.05408 
0.04430 	0.03351 	0.06464 	0.03773 	0.04109 	0.04438 	0.05610 	0.05089 
0.03485 	0.03227 	0.03716 	0.02726 	0.03382 	0.03170 	0.02948 	0.03399 
0.07004 	0.05062 	0.05337 	0.03123 	0.07308 	0.06763 	0.03473 	0.03904 
0.04591 	0.05942 	0.06192 	0.11136 	0.04536 	0.04605 	0.08555 	0.08799 
0.03661 	0.05565 	0.03841 	0.06984 	0.03606 	0.03660 	0.06222 	0.07580 
];

AUC_Bench_App_Ochiai = [
0.07836 	0.07911 	0.07890 	0.07190 	0.06579 	0.07953 	0.06552 	0.07974 
0.04279 	0.03978 	0.03620 	0.04477 	0.02498 	0.03355 	0.02442 	0.02598 
0.07300 	0.05661 	0.08183 	0.07106 	0.08116 	0.07675 	0.07780 	0.08166 
0.08977 	0.08091 	0.07140 	0.07414 	0.06846 	0.07247 	0.06883 	0.08021 
0.10885 	0.07960 	0.10825 	0.04782 	0.11337 	0.09377 	0.08675 	0.03999 
0.10731 	0.06857 	0.10029 	0.03987 	0.10891 	0.10588 	0.07390 	0.03775 
0.10229 	0.09160 	0.11022 	0.05741 	0.09380 	0.09985 	0.05042 	0.04654 
0.07466 	0.06010 	0.09306 	0.03773 	0.06687 	0.07725 	0.04819 	0.04220 
0.03437 	0.03156 	0.03683 	0.02726 	0.03177 	0.03121 	0.02886 	0.03132 
0.06571 	0.04550 	0.04885 	0.03123 	0.06815 	0.06289 	0.04135 	0.04046 
0.05989 	0.08162 	0.10069 	0.11136 	0.05984 	0.05936 	0.11671 	0.10066 
0.03624 	0.06989 	0.03879 	0.06984 	0.03613 	0.03653 	0.11533 	0.11681 
];

AUC_Bench_App_Dstar = [
0.07981 	0.08110 	0.08008 	0.07190 	0.06398 	0.08069 	0.06325 	0.08112 
0.04188 	0.03887 	0.03532 	0.04477 	0.02358 	0.03259 	0.02284 	0.02577 
0.07256 	0.05544 	0.08510 	0.07106 	0.08103 	0.07642 	0.07779 	0.08027 
0.08941 	0.08782 	0.07351 	0.07414 	0.06952 	0.08154 	0.06947 	0.08349 
0.11542 	0.07437 	0.10881 	0.04782 	0.11788 	0.09153 	0.08856 	0.03865 
0.10449 	0.06239 	0.09600 	0.03987 	0.10359 	0.10366 	0.06740 	0.03634 
0.10690 	0.09525 	0.11250 	0.05741 	0.09644 	0.10111 	0.04939 	0.04745 
0.08954 	0.06734 	0.10552 	0.03773 	0.08167 	0.09233 	0.04049 	0.03926 
0.03489 	0.03264 	0.03845 	0.02726 	0.03166 	0.03242 	0.02980 	0.03173 
0.06379 	0.04548 	0.04752 	0.03123 	0.06773 	0.06015 	0.04319 	0.03811 
0.05941 	0.08185 	0.10073 	0.11136 	0.05922 	0.05938 	0.11697 	0.10298 
0.03593 	0.07271 	0.03881 	0.06984 	0.03649 	0.03602 	0.11566 	0.12253 
];

AUC_Bench_App_Jaccard = [
0.07981 	0.08110 	0.08008 	0.07190 	0.06398 	0.08069 	0.06325 	0.08112 
0.04188 	0.03887 	0.03532 	0.04477 	0.02358 	0.03259 	0.02284 	0.02577 
0.07256 	0.05544 	0.08510 	0.07106 	0.08103 	0.07642 	0.07779 	0.08027 
0.08941 	0.08782 	0.07351 	0.07414 	0.06952 	0.08154 	0.06947 	0.08349 
0.11542 	0.07437 	0.10881 	0.04782 	0.11788 	0.09153 	0.08856 	0.03865 
0.10449 	0.06239 	0.09600 	0.03987 	0.10359 	0.10366 	0.06740 	0.03634 
0.10690 	0.09525 	0.11250 	0.05741 	0.09644 	0.10111 	0.04939 	0.04745 
0.08954 	0.06734 	0.10552 	0.03773 	0.08167 	0.09233 	0.04049 	0.03926 
0.03489 	0.03264 	0.03845 	0.02726 	0.03166 	0.03242 	0.02980 	0.03173 
0.06379 	0.04548 	0.04752 	0.03123 	0.06773 	0.06015 	0.04319 	0.03811 
0.05941 	0.08185 	0.10073 	0.11136 	0.05922 	0.05938 	0.11697 	0.10298 
0.03593 	0.07271 	0.03881 	0.06984 	0.03649 	0.03602 	0.11566 	0.12253 
];


AUC_Bench_App_Kulczynski1 = [
 
];

AUC_Bench_App_Kulczynski2 = [

];


app_num = size(AUC_Bench_App_Tarantula, 2);

% initialize matrix to store d
matrix_d_Tarantula = zeros(app_num, app_num);
matrix_d_Ochiai = zeros(app_num, app_num);
matrix_d_Dstar = zeros(app_num, app_num);
matrix_d_Jaccard = zeros(app_num, app_num);
matrix_d_Kulczynski1 = zeros(app_num, app_num);
matrix_d_Kulczynski2 = zeros(app_num, app_num);

for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_Tarantula(i, j) = computeCohen_d(AUC_Bench_App_Tarantula(:, i), AUC_Bench_App_Tarantula(:, j), 'paired');
        matrix_d_Ochiai(i, j) = computeCohen_d(AUC_Bench_App_Ochiai(:, i), AUC_Bench_App_Ochiai(:, j), 'paired');
        matrix_d_Dstar(i, j) = computeCohen_d(AUC_Bench_App_Dstar(:, i), AUC_Bench_App_Dstar(:, j), 'paired');
        matrix_d_Jaccard(i, j) = computeCohen_d(AUC_Bench_App_Jaccard(:, i), AUC_Bench_App_Jaccard(:, j), 'paired');
        matrix_d_Kulczynski1(i, j) = computeCohen_d(AUC_Bench_App_Kulczynski1(:, i), AUC_Bench_App_Kulczynski1(:, j), 'paired');
        matrix_d_Kulczynski2(i, j) = computeCohen_d(AUC_Bench_App_Kulczynski2(:, i), AUC_Bench_App_Kulczynski2(:, j), 'paired');
    end
end

new_cohensd_matrix_tarantula = string(matrix_d_Tarantula);
new_cohensd_matrix_ochiai = string(matrix_d_Ochiai);
new_cohensd_matrix_dstar = string(matrix_d_Dstar);
new_cohensd_matrix_jaccard = string(matrix_d_Jaccard);
new_cohensd_matrix_kulczynski1 = string(matrix_d_Kulczynski1);
new_cohensd_matrix_kulczynski2 = string(matrix_d_Kulczynski2);

[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_Tarantula);

new_cohensd_matrix_tarantula(large_worse) = 'large_worse';
new_cohensd_matrix_tarantula(medium_worse) = 'medium_worse';
new_cohensd_matrix_tarantula(small_worse) = 'small_worse';
new_cohensd_matrix_tarantula(small_better) = 'small_better';
new_cohensd_matrix_tarantula(medium_better) = 'medium_better';
new_cohensd_matrix_tarantula(large_better) = 'large_better';

[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_Ochiai);

new_cohensd_matrix_ochiai(large_worse) = 'large_worse';
new_cohensd_matrix_ochiai(medium_worse) = 'medium_worse';
new_cohensd_matrix_ochiai(small_worse) = 'small_worse';
new_cohensd_matrix_ochiai(small_better) = 'small_better';
new_cohensd_matrix_ochiai(medium_better) = 'medium_better';
new_cohensd_matrix_ochiai(large_better) = 'large_better';

[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_Dstar);

new_cohensd_matrix_dstar(large_worse) = 'large_worse';
new_cohensd_matrix_dstar(medium_worse) = 'medium_worse';
new_cohensd_matrix_dstar(small_worse) = 'small_worse';
new_cohensd_matrix_dstar(small_better) = 'small_better';
new_cohensd_matrix_dstar(medium_better) = 'medium_better';
new_cohensd_matrix_dstar(large_better) = 'large_better';

[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_Jaccard);

new_cohensd_matrix_jaccard(large_worse) = 'large_worse';
new_cohensd_matrix_jaccard(medium_worse) = 'medium_worse';
new_cohensd_matrix_jaccard(small_worse) = 'small_worse';
new_cohensd_matrix_jaccard(small_better) = 'small_better';
new_cohensd_matrix_jaccard(medium_better) = 'medium_better';
new_cohensd_matrix_jaccard(large_better) = 'large_better';


[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_Kulczynski1);

new_cohensd_matrix_kulczynski1(large_worse) = 'large_worse';
new_cohensd_matrix_kulczynski1(medium_worse) = 'medium_worse';
new_cohensd_matrix_kulczynski1(small_worse) = 'small_worse';
new_cohensd_matrix_kulczynski1(small_better) = 'small_better';
new_cohensd_matrix_kulczynski1(medium_better) = 'medium_better';
new_cohensd_matrix_kulczynski1(large_better) = 'large_better';

[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_Kulczynski2);

new_cohensd_matrix_kulczynski2(large_worse) = 'large_worse';
new_cohensd_matrix_kulczynski2(medium_worse) = 'medium_worse';
new_cohensd_matrix_kulczynski2(small_worse) = 'small_worse';
new_cohensd_matrix_kulczynski2(small_better) = 'small_better';
new_cohensd_matrix_kulczynski2(medium_better) = 'medium_better';
new_cohensd_matrix_kulczynski2(large_better) = 'large_better';

%% consider all suspiciousness metrics
AUC_Bench_App_All = [AUC_Bench_App_Tarantula; AUC_Bench_App_Ochiai; AUC_Bench_App_Dstar; ...
    AUC_Bench_App_Jaccard; AUC_Bench_App_Kulczynski1; AUC_Bench_App_Kulczynski2];

matrix_d_All = zeros(app_num, app_num);

% perform Wilcoxon signed-rank test to compare each pair of apps
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All(i, j) = computeCohen_d(AUC_Bench_App_All(:, i), AUC_Bench_App_All(:, j), 'paired');
    end
end

new_cohensd_matrix_all = string(matrix_d_All);

[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All);

new_cohensd_matrix_all(large_worse) = 'large_worse';
new_cohensd_matrix_all(medium_worse) = 'medium_worse';
new_cohensd_matrix_all(small_worse) = 'small_worse';
new_cohensd_matrix_all(small_better) = 'small_better';
new_cohensd_matrix_all(medium_better) = 'medium_better';
new_cohensd_matrix_all(large_better) = 'large_better';


% %% consider all suspiciousness metrics except Jaccard
% AUC_Bench_App_All_NoJaccard = [AUC_Bench_App_Tarantula; AUC_Bench_App_Ochiai; AUC_Bench_App_Dstar; ...
%     AUC_Bench_App_Kulczynski1; AUC_Bench_App_Kulczynski2];
% 
% matrix_d_All_NoJaccard = zeros(app_num, app_num);
% 
% % perform Wilcoxon signed-rank test to compare each pair of apps
% for i = 1:app_num
%     for j = 1:app_num
%         % calculate the Cohen's d effect size
%         matrix_d_All_NoJaccard(i, j) = computeCohen_d(AUC_Bench_App_All_NoJaccard(:, i), AUC_Bench_App_All_NoJaccard(:, j), 'paired');
%     end
% end
% 
% new_cohensd_matrix_all_nojaccard = string(matrix_d_All_NoJaccard);
% 
% [large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_NoJaccard);
% 
% new_cohensd_matrix_all_nojaccard(large_worse) = 'large_worse';
% new_cohensd_matrix_all_nojaccard(medium_worse) = 'medium_worse';
% new_cohensd_matrix_all_nojaccard(small_worse) = 'small_worse';
% new_cohensd_matrix_all_nojaccard(small_better) = 'small_better';
% new_cohensd_matrix_all_nojaccard(medium_better) = 'medium_better';
% new_cohensd_matrix_all_nojaccard(large_better) = 'large_better';
% 
% diff = ones(13, 13);
% for i = 1:13
%     for j = 1:13
%         if new_cohensd_matrix_all(i,j) ~= new_cohensd_matrix_all_nojaccard(i,j)
%             disp(new_cohensd_matrix_all(i,j));
%             disp(new_cohensd_matrix_all_nojaccard(i,j));
%             diff(i,j) = 0;
%         end
%     end
% end


function [large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d)
    large_worse = matrix_d < -0.8;
    medium_worse = matrix_d >= -0.8 & matrix_d <= -0.2;
    small_worse = matrix_d > -0.2 & matrix_d < 0;
    small_better = matrix_d > 0 & matrix_d < 0.2;
    medium_better = matrix_d >= 0.2 & matrix_d <= 0.8;
    large_better = matrix_d > 0.8;
end
