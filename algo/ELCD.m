function [Fskeleton,CE]=ELCD(data,Cskeleton)
% Elasticity Causal Direction
n=size(Cskeleton,1);
Fskeleton=zeros(n);
CE=zeros(n);
lower_triangle = tril(true(size(Cskeleton)), -1);
Cskeleton(lower_triangle) = 0;
[row,col]=find(Cskeleton==1);
ind=[];
EL=[];
for i=1:length(row)
    X=data(:,row(i));
    Y=data(:,col(i));
    [ind(i,1),EL(i,1)]=EL_direction(X,Y);
    if ind(i,1)==1
        Fskeleton(row(i),col(i))=1;
        CE(row(i),col(i))=EL(i,1);
    else
        Fskeleton(col(i),row(i))=1;
        CE(col(i),row(i))=EL(i,1);
    end
end