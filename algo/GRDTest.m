function cit=GRDTest(x,y) %x,y为data的列向量,x为母向量
alpha=0.99;
p=0.5; %
A=abs(y-x);
epsilon=(min(A)+p*max(A))/(A+p*max(A));
if epsilon>alpha
    cit = true;
else
    cit = false;
end
end
