%function [cit,sig]=PaCoTest(x, y, Z, alpha)
function [cit] = PaCoTest(x, y, Z, alpha)
% alpha = 0.01;
%implement according to  http://en.wikipedia.org/wiki/Partial_correlation
if isempty(Z)
    n=length(x);
    ncit=0;
    pcc=corrcoef(x,y);
    pcc=pcc(1,2);
else
    [n,ncit]=size(Z);
    Z=[ones(n,1),Z];
    wx=Z\x;
    rx=x-Z*wx;
    wy=Z\y;
    ry=y-Z*wy;
    pcc=(n*rx'*ry- sum(rx)*sum(ry))/sqrt(n*rx'*rx-sum(rx)^2)/sqrt(n*ry'*ry-sum(ry)^2);
end
zpcc=0.5*log((1+pcc)/(1-pcc));
A = sqrt(n-ncit-3)*abs(zpcc) ;
B = icdf('normal',1-alpha/2,0,1); 
sig = (B-A)/(A+B);
if sqrt(n-ncit-3)*abs(zpcc) > icdf('normal',1-alpha/2,0,1) 
    cit=false;
else
    cit=true;
end
%PaCoTest就是直接判断x，y在给定Z，α后的偏相关性，并输出一个logical数据true代表无关，false代表有关