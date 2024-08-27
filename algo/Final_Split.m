function [FinalSaver,Cut]=Final_Split(Saver,W,k)
%Saver为之前谱聚类分好的Saver; W为欧式距离矩阵; k为子集数
if k==2 %分治成2个的case
        for i=1:size(W,1)
            for j=i:size(W,1)
            W(i,j)=NaN;
            end
        end%将W转换成下三角矩阵方便后续计算
        if length(Saver{1,1})>=length(Saver{2,1})
            lm=2;
        else 
            lm=1;
        end     %判断哪个saver小
        W(Saver{1,1},Saver{1,1})=NaN;
        W(Saver{2,1},Saver{2,1})=NaN;
        [temx1,temy1]=find(W==min(min(W))); 
        if ismember(temx1,Saver{lm,1})
            Saver{lm,1}=[Saver{lm,1};temy1];
            Cut=temy1;
            W(:,temy1)=NaN;
        else
            Saver{lm,1}=[Saver{lm,1};temx1];
            Cut=temx1;
            W(temx1,:)=NaN;
        end
        [temx2,temy2]=find(W==min(min(W)));
        if ismember(temx2,Saver{lm,1})
            Saver{lm,1}=[Saver{lm,1};temy2];
            Cut=[Cut;temy2];
        else
            Saver{lm,1}=[Saver{lm,1};temx2];
            Cut=[Cut;temx2];
        end
else%分治成k个的case
        Cut=cell(k,1);
        for i=1:k
            W(Saver{i,1},Saver{i,1})=NaN;
        end%处理所有的同子集点——将所有同子集点的距离设为NaN
        for j=1:k %遍历k个子集
            [temx1,temy1]=find(W==min(min(W(Saver{j,1},:)))); 
            Saver{j,1}=[Saver{j,1};temy1];
            Cut{j,1}=[Cut{j,1};temy1];
            W(temx1,temy1)=NaN;
            [temx2,temy2]=find(W==min(min(W(Saver{j,1},:)))); 
            Saver{j,1}=[Saver{j,1};temy2];
            Cut{j,1}=[Cut{j,1};temy2];
            W(temx2,temy2)=NaN;
        end
end
Cut;
for q=1:k
FinalSaver{q,1}=unique(Saver{q,1});
end
FinalSaver;
end
