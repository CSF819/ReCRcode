function [Score]= ScoreSkeleton(Cskeleton,skeleton)
n = size(skeleton,1);
TP=0; FN=0; FP=0; TN=0;
for i =1:n
    for j = 1:n
        if Cskeleton(i,j)==skeleton(i,j) && Cskeleton(i,j)==1
            TP=TP+1;
        elseif Cskeleton(i,j)==skeleton(i,j) && Cskeleton(i,j)==0
            TN=TN+1;
        elseif Cskeleton(i,j)~=skeleton(i,j) && Cskeleton(i,j)==0
            FN=FN+1;
        else
            FP=FP+1;
        end
    end
end
Recall=TP/(TP+FN);
Precision=TP/(TP+FP);
FPR=FP/(FP+TN); %越小越好
SHD=FN+FP; %越小越好
% if TP<2
%     TP1=0;
% else
%     TP1=nchoosek(TP,2);
% end
% if FN<2
%     FN1=0;
% else
%     FN1=nchoosek(FN,2);
% end
% if FP<2
%     FP1=0;
% else
%     FP1=nchoosek(FP,2);
% end
% if TN<2
%     TN1=0;
% else
%     TN1=nchoosek(TN,2);
% end
%a=nchoosek(TP+FN,2);b=nchoosek(FP+TN,2);c=nchoosek(TP+FP,2);d=nchoosek(FN+TN,2);
%e=nchoosek(n,2);
%ARI=((TP1+FN1+FP1+TN1)-((a+b)*(c+d)/e))/(((a+b+c+d)/2)-((a+b)*(c+d)/e));
% NMI=nmi(Cskeleton(:)',skeleton(:)');
% purity=(TP+TN)/n^2;
if Recall+Precision == 0
    Score = [Recall,Precision,0,FPR,SHD];
else
    Score = [Recall,Precision,2*Recall*Precision/(Recall+Precision),FPR,SHD];
end
%Edge=[TP,TN,FP,FN];
end

% function MIhat = nmi(A, B)
% %NMI Normalized mutual information
% % A, B: 1*N;
% if length(A) ~= length(B)
%     error('length( A ) must == length( B)');
% end
% N = length(A);
% A_id = unique(A);
% K_A = length(A_id);
% B_id = unique(B);
% K_B = length(B_id);
% % Mutual information
% A_occur = double (repmat( A, K_A, 1) == repmat( A_id', 1, N ));
% B_occur = double (repmat( B, K_B, 1) == repmat( B_id', 1, N ));
% AB_occur = A_occur * B_occur';
% P_A= sum(A_occur') / N;
% P_B = sum(B_occur') / N;
% P_AB = AB_occur / N;
% MImatrix = P_AB .* log(P_AB ./(P_A' * P_B)+eps);
% MI = sum(MImatrix(:));
% % Entropies
% H_A = -sum(P_A .* log(P_A + eps),2);
% H_B= -sum(P_B .* log(P_B + eps),2);
% %Normalized Mutual information
% MIhat = MI / sqrt(H_A*H_B);
% end