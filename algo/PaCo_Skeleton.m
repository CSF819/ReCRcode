function [PaCoSkeleton]=PaCo_Skeleton[Saver,data,k,m]
%Saver为之前谱聚类分好的Saver;data是生成的数据;k为子集数;m为数据维度
%% 初始化
PaCoSkeleton=zeros(m,m);

%% 求出PaCoSkeleton
for i=1:k
