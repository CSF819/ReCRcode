function E=SADA_LiNGAM_Wrapper(X)
% fprintf('Solving Basic Problem (Dim. %d, Samp. %d) using LiNGAM\n',size(X,2),size(X,1))

[B stde ci k W] = estimate(X');
nNode=size(X, 2);
if nNode <20 
    [B P] = prune(X', k, 'W', W, 'B',B, 'stde',stde, 'method', 'wald');
    [x,y]=find(abs(B)>0);
    E=[x,y];
    P=B(abs(B)>0); 
    E=[E,P];
else
    B = prune(X', k, 'W', W, 'B',B, 'stde',stde, 'method', 'resampling');
    [x,y]=find(abs(B)>0);
    E=[x,y];
    P=abs(B(abs(B)>0)); 
    E=[E,P];
end

