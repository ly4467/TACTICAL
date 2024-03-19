clc
clear

AUC_Bench_App_Tarantula = [
0.07834 	0.05603 	0.09169 	0.08191 	0.09956 	0.05741 	0.10018 	0.06156 
0.02271 	0.03311 	0.05535 	0.09194 	0.03710 	0.04208 	0.03829 	0.02872 
0.09675 	0.07780 	0.09541 	0.06955 	0.11605 	0.07698 	0.11559 	0.06831 
0.08103 	0.08249 	0.07994 	0.06207 	0.07436 	0.07786 	0.07480 	0.07607 
0.10349 	0.06628 	0.09236 	0.04188 	0.10913 	0.09260 	0.07275 	0.03290 
0.10085 	0.05677 	0.11814 	0.04378 	0.10248 	0.09140 	0.08779 	0.06892 
0.10405 	0.09508 	0.11029 	0.05310 	0.09208 	0.09745 	0.08683 	0.05012 
0.09265 	0.08083 	0.10513 	0.07327 	0.08018 	0.08310 	0.07657 	0.06926 
0.03361 	0.03772 	0.04596 	0.10874 	0.04092 	0.03438 	0.04001 	0.03775 
0.02142 	0.02743 	0.02873 	0.08012 	0.06542 	0.06295 	0.05618 	0.02719 
0.03914 	0.06868 	0.05211 	0.03369 	0.05635 	0.05678 	0.08232 	0.10478 
0.08605 	0.08466 	0.07024 	0.02299 	0.03291 	0.03312 	0.07554 	0.12479 
];

AUC_Bench_App_Ochiai = [
0.08138 	0.08482 	0.08822 	0.08191 	0.09945 	0.07308 	0.10002 	0.06495 
0.06146 	0.05862 	0.04129 	0.09194 	0.02804 	0.03579 	0.02514 	0.02459 
0.08335 	0.08407 	0.11005 	0.06955 	0.11891 	0.07769 	0.11771 	0.06854 
0.08902 	0.08654 	0.10904 	0.06207 	0.07899 	0.08162 	0.07817 	0.07614 
0.11590 	0.05847 	0.09021 	0.04188 	0.11637 	0.08468 	0.08073 	0.02635 
0.10409 	0.06651 	0.12992 	0.04378 	0.12929 	0.12372 	0.09417 	0.05987 
0.12393 	0.10945 	0.11357 	0.05310 	0.11715 	0.11491 	0.08410 	0.04313 
0.08660 	0.09867 	0.12097 	0.07327 	0.10571 	0.11158 	0.07756 	0.04923 
0.04202 	0.04013 	0.04904 	0.10874 	0.04009 	0.03370 	0.04067 	0.03677 
0.02904 	0.03993 	0.03597 	0.08012 	0.06021 	0.05938 	0.05861 	0.03962 
0.05656 	0.06788 	0.10065 	0.03369 	0.08183 	0.08077 	0.10928 	0.11644 
0.12957 	0.09705 	0.08248 	0.02299 	0.03174 	0.03344 	0.12698 	0.15528 
];

AUC_Bench_App_Dstar = [
0.07892 	0.08757 	0.09113 	0.08191 	0.10006 	0.07707 	0.10074 	0.06505 
0.06749 	0.05872 	0.03597 	0.09194 	0.02118 	0.02563 	0.02124 	0.02671 
0.08227 	0.08525 	0.11131 	0.06955 	0.11635 	0.07775 	0.11383 	0.06850 
0.09709 	0.08822 	0.10888 	0.06207 	0.08147 	0.08384 	0.07973 	0.07442 
0.11384 	0.05756 	0.09253 	0.04188 	0.12083 	0.08485 	0.08007 	0.02713 
0.09940 	0.05515 	0.13041 	0.04378 	0.12748 	0.11273 	0.09587 	0.05344 
0.12774 	0.11146 	0.11148 	0.05310 	0.12396 	0.11599 	0.08241 	0.04314 
0.08930 	0.10078 	0.12582 	0.07327 	0.11162 	0.11974 	0.07839 	0.04879 
0.04809 	0.03442 	0.04817 	0.10874 	0.04016 	0.03336 	0.04029 	0.03128 
0.02267 	0.03971 	0.03739 	0.08012 	0.05656 	0.05494 	0.05830 	0.04434 
0.05557 	0.06895 	0.10127 	0.03369 	0.08133 	0.08149 	0.10971 	0.11649 
0.12961 	0.09816 	0.08282 	0.02299 	0.04630 	0.04562 	0.12669 	0.15542 
];

AUC_Bench_App_Jaccard = [
0.08145 	0.08344 	0.08815 	0.08191 	0.09891 	0.07304 	0.09988 	0.06415 
0.06022 	0.05252 	0.04678 	0.09194 	0.03052 	0.03605 	0.02690 	0.02343 
0.08681 	0.08414 	0.11001 	0.06955 	0.11883 	0.07750 	0.11569 	0.06871 
0.08688 	0.08547 	0.10643 	0.06207 	0.07801 	0.08140 	0.07688 	0.07615 
0.11608 	0.05695 	0.09183 	0.04188 	0.11574 	0.08778 	0.08145 	0.02707 
0.10042 	0.06506 	0.13052 	0.04378 	0.12859 	0.12460 	0.09416 	0.05995 
0.12234 	0.10795 	0.11184 	0.05310 	0.11287 	0.10761 	0.08286 	0.04314 
0.08327 	0.09303 	0.11950 	0.07327 	0.10088 	0.10715 	0.07886 	0.04820 
0.04280 	0.03987 	0.04842 	0.10874 	0.04065 	0.03377 	0.04017 	0.03674 
0.02940 	0.03523 	0.03425 	0.08012 	0.06025 	0.05935 	0.05789 	0.03881 
0.05557 	0.06780 	0.09072 	0.03369 	0.08156 	0.08137 	0.10617 	0.11613 
0.11805 	0.09699 	0.07078 	0.02299 	0.03281 	0.03315 	0.12727 	0.15315 
];


AUC_Bench_App_Kulczynski1 = [
0.08163 	0.08359 	0.08859 	0.08191 	0.09896 	0.07293 	0.10007 	0.06397 
0.06015 	0.05251 	0.04643 	0.09194 	0.03048 	0.03578 	0.02698 	0.02343 
0.08667 	0.08414 	0.11028 	0.06955 	0.11902 	0.07751 	0.11545 	0.06836 
0.08624 	0.08535 	0.10643 	0.06207 	0.07791 	0.08169 	0.07704 	0.07612 
0.11616 	0.05689 	0.09201 	0.04188 	0.11592 	0.08782 	0.08139 	0.02701 
0.10055 	0.06515 	0.13054 	0.04378 	0.12849 	0.12442 	0.09424 	0.05983 
0.12247 	0.10794 	0.11183 	0.05310 	0.11282 	0.10776 	0.08291 	0.04318 
0.08321 	0.09294 	0.11936 	0.07327 	0.10086 	0.10709 	0.07881 	0.04829 
0.04163 	0.04042 	0.04824 	0.10874 	0.04045 	0.03348 	0.03991 	0.03716 
0.02945 	0.03521 	0.03435 	0.08012 	0.06030 	0.05945 	0.05798 	0.03892 
0.05608 	0.06942 	0.09104 	0.03369 	0.08075 	0.08116 	0.10672 	0.11549 
0.11820 	0.09685 	0.06968 	0.02299 	0.03289 	0.03303 	0.12678 	0.15303 
];

AUC_Bench_App_Kulczynski2 = [
0.08255 	0.08489 	0.09146 	0.08191 	0.10034 	0.07627 	0.10117 	0.06503 
0.06512 	0.05900 	0.04099 	0.09194 	0.02277 	0.03063 	0.02287 	0.02716 
0.08315 	0.08424 	0.11106 	0.06955 	0.11900 	0.07752 	0.11779 	0.06848 
0.09126 	0.09009 	0.11021 	0.06207 	0.08150 	0.08281 	0.07963 	0.07557 
0.11244 	0.05955 	0.08895 	0.04188 	0.11744 	0.08162 	0.08210 	0.02376 
0.10227 	0.06192 	0.12890 	0.04378 	0.12858 	0.11504 	0.09455 	0.05771 
0.12510 	0.11039 	0.11308 	0.05310 	0.12318 	0.11482 	0.08467 	0.04600 
0.09096 	0.10184 	0.12267 	0.07327 	0.11158 	0.11829 	0.07683 	0.05342 
0.04211 	0.04023 	0.04886 	0.10874 	0.04007 	0.03290 	0.04336 	0.02809 
0.02984 	0.04304 	0.03635 	0.08012 	0.06029 	0.05932 	0.06055 	0.04018 
0.05638 	0.06762 	0.10076 	0.03369 	0.08129 	0.08068 	0.10931 	0.11649 
0.13007 	0.10897 	0.08264 	0.02299 	0.04658 	0.04632 	0.12654 	0.15506 
];

allData = {AUC_Bench_App_Tarantula, AUC_Bench_App_Ochiai, AUC_Bench_App_Dstar, AUC_Bench_App_Jaccard, AUC_Bench_App_Kulczynski1, AUC_Bench_App_Kulczynski2};

% there are 6 approaches
app_num = 6;

% consider all hyper param
AUC_Bench_App_All_Param = [];
for spsIdx = 1:app_num
    AUC_Bench_App_All_Param = cat(2, AUC_Bench_App_All_Param, reshape(allData{spsIdx}, size(allData{spsIdx},1)*size(allData{spsIdx},2), 1));
end

matrix_d_All_Param = zeros(app_num, app_num);

% perform Wilcoxon signed-rank test to compare each pair of apps
for i = 1:app_num
    for j = 1:app_num
        % calculate the Cohen's d effect size
        matrix_d_All_Param(i, j) = computeCohen_d(AUC_Bench_App_All_Param(:, i), AUC_Bench_App_All_Param(:, j), 'paired');
    end
end

new_cohensd_matrix_all_param = string(matrix_d_All_Param);
[large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_Param);

new_cohensd_matrix_all_param(large_worse) = 'large_worse';
new_cohensd_matrix_all_param(medium_worse) = 'medium_worse';
new_cohensd_matrix_all_param(small_worse) = 'small_worse';
new_cohensd_matrix_all_param(small_better) = 'small_better';
new_cohensd_matrix_all_param(medium_better) = 'medium_better';
new_cohensd_matrix_all_param(large_better) = 'large_better';


% %% consider all hyper param without Jaccard
% AUC_Bench_App_All_Param_NoJaccard = [AUC_Bench_App_unwin_01; AUC_Bench_App_unwin_02; AUC_Bench_App_unwin_03; AUC_Bench_App_unwin_04; AUC_Bench_App_unwin_05; ...
%     AUC_Bench_App_win_01; AUC_Bench_App_win_02; AUC_Bench_App_win_03; AUC_Bench_App_win_04; AUC_Bench_App_win_05];
% 
% matrix_d_All_Param_No_Jaccard = zeros(app_num, app_num);
% 
% % perform Wilcoxon signed-rank test to compare each pair of apps
% for i = 1:app_num
%     for j = 1:app_num
%         % calculate the Cohen's d effect size
%         matrix_d_All_Param_No_Jaccard(i, j) = computeCohen_d(AUC_Bench_App_All_Param(:, i), AUC_Bench_App_All_Param(:, j), 'paired');
%     end
% end
% 
% new_cohensd_matrix_all_param_no_jaccard = string(matrix_d_All_Param_No_Jaccard);
% [large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d_All_Param_No_Jaccard);
% 
% new_cohensd_matrix_all_param_no_jaccard(large_worse) = 'large_worse';
% new_cohensd_matrix_all_param_no_jaccard(medium_worse) = 'medium_worse';
% new_cohensd_matrix_all_param_no_jaccard(small_worse) = 'small_worse';
% new_cohensd_matrix_all_param_no_jaccard(small_better) = 'small_better';
% new_cohensd_matrix_all_param_no_jaccard(medium_better) = 'medium_better';
% new_cohensd_matrix_all_param_no_jaccard(large_better) = 'large_better';


function [large_worse, medium_worse, small_worse, small_better, medium_better, large_better] = label(matrix_d)
    large_worse = matrix_d < -0.8;
    medium_worse = matrix_d >= -0.8 & matrix_d <= -0.2;
    small_worse = matrix_d > -0.2 & matrix_d < 0;
    small_better = matrix_d > 0 & matrix_d < 0.2;
    medium_better = matrix_d >= 0.2 & matrix_d <= 0.8;
    large_better = matrix_d > 0.8;
end