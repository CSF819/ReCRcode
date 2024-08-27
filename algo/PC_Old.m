function [Score,Cskeleton] = PC_Old(data,skeleton) %需要输入的是data和skeleton
n = size(skeleton,1);
Cskeleton=zeros(n,n);
for i= 1:(n-1)
    lab = i;
    pc = [];
    for j = i+1:n
        flag = true;
        if KCIT(data(:,i), data(:,j),[],[])
            break;
        else
            temp = (1:n);
            temp([i,j])=[];
            for k=1:length(temp)
                x = data(:,i);
                y = data(:,j);
                z = data(:, temp(k));
                if KCIT(x, y,z,[])
                    flag = false;
                    break;
                end
            end
        end
        if flag == true
            pc = unique([pc,j]);
        end
    end
    len=length(pc);
    for w = 1:len
        Cskeleton(lab,pc(w))=1;
        Cskeleton(pc(w),lab)=1;
    end
end
Score = ScoreSkeleton(Cskeleton,skeleton);