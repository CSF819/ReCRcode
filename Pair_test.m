clc;clear;
addpath(genpath('.\algo'));%添加路径
addpath(genpath('.\dataset'))
all_data = cell(108, 1);
basePath='\pairs\';
count=[];
ind=[];
% 遍历文件编号，从 pair001 到 pair0106
for i = 1:108
    filename = fullfile(basePath, sprintf('pair0%03d.txt', i));
    data = readmatrix(filename);
    all_data{i} = data;
end
for i = 1:length(all_data)
    % 检查子单元格是否是一个矩阵，并且其列数为2
    if size(all_data{i}, 2) ~= 2
           count(end+1)=i;
    end
end
%data = readmatrix('pairs\pair0056.txt')%读数据
for i = 1:length(all_data)
    if ismember(i,count)
        ind(i)=NaN;
    else
        [ind(i),~]=EL_directionByELMean(all_data{i,1}(:,1),all_data{i,1}(:,2));
    end
end
ind
%% Tuebingen pair accuracy
Tuebingen_pair_result=ones(1,108);
Tuebingen_pair_result(47:53)=0;Tuebingen_pair_result(55:63)=0;Tuebingen_pair_result([68,69,73,75,77,79,80,84,89,90,92,99,106,108])=0;

nonNaNIndices = ~isnan(ind);
isEqual = ind(nonNaNIndices) == Tuebingen_pair_result(nonNaNIndices);
accuracy=sum(isEqual)/length(isEqual)







