function [FinalSaver,Cut]=Final_Split_AutoNodes(Saver,W,k,m)
%Saver为之前谱聚类分好的Saver; W为correlation距离矩阵; k为子集数;m数据维度
%% 1.确定被添加元素的子集 2.确定增加节点的数量
b=floor(k/2);%需要添加元素的子集数
c=cellfun(@length,Saver);%找出子集的节点数
c1=sort(c);%排序c
c2=c1(1:b);
c2=max(c2);%节点数最小的b个子集中含有的节点数
%c3=zeros(b,1);
cr=zeros(b,1);
[cr,~]=find(c<=c2); %被添加元素的子集序号
%c3=sub2ind([k 1],cr,cc);
a=max(c); %最大子集的节点数
a=2;%确定添加的节点数
%% 初始化
Cut=cell(b,1);
FinalSaver=cell(k,1);
%% 处理W
for i=1:k
    W(Saver{i,1},Saver{i,1})=NaN;
end%处理所有的同子集点——将所有同子集点的距离设为NaN
%% 对每个子集进行处理
for x=1:b %x为子集序号用于c3
    S=W(:,Saver{cr(x),1});
    S=sort(S);
    S=S(1:a);
    [~,iS,~]=intersect(W,S,'stable');
    [row,col]=ind2sub([m m],iS);
    for y=1:a
        if ismember(row(y),Saver{cr(x),1})
            Saver{cr(x),1}=[Saver{cr(x),1};col(y)];
            Cut{x,1}=[Cut{x,1};col(y)];
        else
            Saver{cr(x),1}=[Saver{cr(x),1};row(y)];
            Cut{x,1}=[Cut{x,1};row(y)];
        end
    end        
end
%% FinalSaver
for u=1:k
FinalSaver{u,1}=unique(Saver{u,1});
end

end



