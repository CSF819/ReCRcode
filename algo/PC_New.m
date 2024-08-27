function [Score] = PC_New(data,skeleton)
n = size(skeleton,1);
Cskeleton=zeros(n,n);%Cskeleton初始化为与skeleton维数相同的0矩阵
for i= 1:(n-1)
    lab = i;
    pc = [];
    for j = i+1:n
        flag = true;
        if PcKTest(data(:,i), data(:,j),[],0.05)%data为SEMdataGenerater生成的double矩阵
            break;
        else
            temp = (1:n);
            temp([i,j])=[];%s.t.temp的第i个和第j个元素为空，那么temp的长度会减少
            for k=1:length(temp)
                x = data(:,i);
                y = data(:,j);
                z = data(:, temp(k));
                if PcKTest(x, y,z,0.05)
                    flag = false;
                    break;
                end
            end
        end        %%逐一验证条件独立性
        if flag == true
            pc = unique([pc,j]);%unique找出不重复的值
        end
    end
    len=length(pc);
    for w = 1:len
        Cskeleton(lab,pc(w))=1;
        Cskeleton(pc(w),lab)=1;
    end
end
Score = ScoreSkeleton(Cskeleton,skeleton);