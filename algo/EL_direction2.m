%% Elasticity CIT2
%El_xy=abs((deltay/y)/(deltax/x))
function[ind,EL]=EL_direction2(x,y)
%k为抽取次数
k=length(x);
El_xy=zeros(k); % el值
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
            if abs(El_xy(i,j))>1
                el(i,j)=1;
            else 
                el(i,j)=0;
            end
            % if abs(El_yx(i,j))>1
            %     el(j,i)=1;
            % else 
            %     el(j,i)=0;
            % end
        end
    end
end
q=sum(el(:) == 1);
p=sum(el(:) == 0);
if q>=p
    ind=1;%x->y
    else
    ind=0;%y->x
end
EL=mean(mean(El_xy,'omitnan'));