function Best= Pairwise_Main(X)

%%
%X是原变量
%candidates是要计算残差的变量的行数
%首先寻找第一个外生变量
% Center variables去均值
[dims,samples]=size(X);
X = X - mean(X,2)*ones(1,samples);
K = zeros(1,dims);
U_K = 1:dims;
XX=X;
%M=zeros(dims,dims);
for i=1:dims-1
    Cov = cov(XX');
    [LR] = pwling(XX,1);%%%%这里可以选择方法
    [aaa,bbb ] = Test_non_gaussian(LR(U_K,:));
    %     U_K(bbb)
    K(i)=U_K(bbb(1));
    U_K(U_K == K(i)) = [];
    XX= Computer_X(XX,U_K,K(i),Cov);
end
K(dims)=U_K;
kest=K;
[Best, stde, ci] = prune(X, kest);
end

