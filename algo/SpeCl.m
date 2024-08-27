function [v2,pos,neg] = SpeCl(l)
%v=特征向量，d=特征值
[v,d]=eig(l);
d=diag(d);%将特征值对角阵转换为一个向量
[d,dorder]=sort(d);%排序，y为元素，z为元素序列
dorder=dorder(2);%找出第二小特征值λ2所在的位置
v2=v(:,dorder);%找到v2
pos=v2(v2>0);
neg=v2(v2<=0);
end



