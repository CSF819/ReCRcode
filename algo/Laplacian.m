function [W2,D,S,L]=Laplacian(data,n,sigma)%求用全连接法构造的邻接矩阵对应的Laplacian矩阵
%data:原始数据集,n:数据维度
%W=pdist(data') %求各列之间的欧氏距离
W=pdist(data','correlation'); %相关系数作为距离
%W=pdist(data','mahalanobis');
W2 = squareform(W);
%W=normalize(W,'range');
W1 = -(W.*W)/(2*sigma*sigma); %高斯核函数
S = exp(W1);
S = squareform(S);% 在这里S即为相似度矩阵，也就是这不在以邻接矩阵计算，而是采用相似度矩阵
D = full(sparse(1:n, 1:n, sum(S)));
L=eye(n)-(D^(-1/2) * S * D^(-1/2));
%L=D-S;
end
