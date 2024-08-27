%% Elasticity CIT2
%El_xy=abs((deltay/y)/(deltax/x))
function[ind,EL]=EL_directionByELMean(x,y)
%k为抽取次数
k=length(x);
El_xy=zeros(k); % el值
meanX=mean(x);
%meanX2=mean(x.^2);
%mean1X2=mean(1./(x.^2));
%meanX2*mean1X2;
alpha=var(y)/var(x); %默认为1
meanY=mean(y);
%El_yx=zeros(k);
for i=1:k %x的序号
    for j=1:k %
        if i==j
            El_xy(i,j)=NaN;
            El_yx(i,j)=NaN;
        else
            El_xy(i,j)=((y(j,1)-meanY)/meanY)/((x(j,1)-meanX)/meanX);
            %El_yx(i,j)=((x(j,1)-meanX)/meanX)/((y(j,1)-meanY)/meanY);
        end
    end
end
el_xy_square=El_xy.^2;
%el_yx_square=El_yx.^2;
q=mean(el_xy_square(:),'omitnan');
%p=mean(el_yx_square(:),'omitnan');

    if q<=alpha
        ind=1;%x->y
        EL=q;
    else
        ind=0;%y->x
        EL=1/q;
    end

%disp(abs(meanX)>abs(meanY));
%disp(meanX2);
%disp(mean1X2);