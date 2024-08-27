%% Elasticity CIT2
%El_xy=abs((deltay/y)/(deltax/x))
function[ind,EL]=EL_directionProb(x,y)
%k为抽取次数
k=length(x);
El_xy=zeros(k); % el值
weightx2y=zeros(k);
weighty2x=zeros(k);
%El_yx=zeros(k);
el=zeros(k); % el比较后的大小判定
for i=1:k %x的序号
    for j=1:k %
        if i==j
            El_xy(i,j)=NaN;
            %El_yx(i,j)=NaN;
            el(i,j)=NaN;
        else
            El_xy(i,j)=((y(j,1)-y(i,1))/y(i,1))/((x(j,1)-x(i,1))/x(i,1));
            %El_yx(i,j)=((x(j,1)-x(i,1))/x(i,1))/((y(j,1)-y(i,1))/y(i,1));
        end
    end
end
for u=1:k
    for r=1:k
        if u~=r
            weightx2y(u,r)=El_xy(u,r)/sum(El_xy(u,:));
            weighty2x(u,r)=El_xy(u,r)/sum(El_xy(:,r));
        else
            weightx2y(u,r)=NaN;
            weighty2x(u,r)=NaN;
        end
    end
end
q=mean(weightx2y(:),"omitnan");
p=mean(weighty2x(:),"omitnan");
if q>=p
    ind=0;%x->y
    else
    ind=1;%y->x
end
EL=mean(mean(El_xy,'omitnan'));