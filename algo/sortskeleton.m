function [skeleton]=sortskeleton(skeleton)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[nNode]=size(skeleton, 1);%nNode为skeleton的行数
dGraph=skeleton;
%apporixmate topical sort
idx=zeros(nNode,1);%构造0向量
nodeFlag=true(nNode, 1);%构造逻辑向量，且元素均为1
for iPass=1:nNode
    % find the mininmal in-degree variable 
    nodeIdx=find(nodeFlag==true);
    for i = 1:length(nodeIdx)
        inSum=sum(dGraph(:, nodeIdx(i)));%计算第i个节点的in-degree
        if inSum ==0
            break;
        end            
    end
    % remove this node and its out degree
    idx(iPass)=nodeIdx(i);
    nodeFlag(nodeIdx(i))=false;
    dGraph(nodeIdx(i), :)=0;
end
skeleton=skeleton(idx, idx);
% 
% skeleton=skeleton(idx, idx);

% 
% for i=1:n
%     indch=find(max(skeleton(1:m,:)>=0));
%     shunxi=indch;
%     indpc=find(skeleton(:,i)==1);
%     yuzhi=find(shunxi==i);
%     len=length(indpc);
%     if len>0
%         if indpc(len)>yuzhi
%             keyind= shunxi==i;
%             rex= shunxi==indpc(len);
%             shunxi(1,keyind)=indpc(len);
%             shunxi(1,rex)=yuzhi;
%         end
%     end
%     skeleton=skeleton(shunxi,shunxi);
%     names=names(shunxi);
% end
% for k=1:n
%     indpc=find(skeleton(:,k)==1);
%     yuzhi=find(shunxi==k);
%     len=length(indpc);
%     if len>0
%         if  indpc(len)>yuzhi
%             [ skeleton,names]=sortskeleton(skeleton,names);
%         end
%     end
% end
% end
% 
