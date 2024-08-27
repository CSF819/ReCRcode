%% Elasticity CIT
%El_xy=abs((deltay/y)/(deltax/x))
function[ind,EL]=EL_direction(X,Y)
%k为抽取次数
s=100;k=3*length(X);
El_xy=zeros(k,1);
El_yx=zeros(k,1);
El=zeros(s,2);
for j=1:s
    for i=1:k
        indx=randperm(length(X),2);
        x1=X(indx(1,1),1);    
        y1=Y(indx(1,1),1);
        x2=X(indx(1,2),1);
        y2=Y(indx(1,2),1);
        El_xy(i,1)=((y1-y2)/y1)/((x1-x2)/x1);
        El_yx(i,1)=((x1-x2)/x1)/((y1-y2)/y1);
    end 
    notNaN=~isnan(El_xy);%防止El_xy=0
    El_xy=El_xy(notNaN);
    El_yx=El_yx(notNaN);
    if mean(abs(El_xy))>1
        El(j,1)=1; 
    elseif mean(abs(El_yx))>1
        El(j,2)=1; 
    end
end
q=sum(El(:,1));
p=sum(El(:,2));
if q>=p
    ind=1;%x->y
    EL=mean(El_xy);
else
    ind=0;%y->x
    EL=mean(El_yx);
end