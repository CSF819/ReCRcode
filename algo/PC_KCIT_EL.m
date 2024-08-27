function [Score,consetNum2,Cskeleton,skeletonByVs,Fskeleton] = PC_KCIT_EL(data,skeleton,consetNum)
n = size(skeleton,1);
alpha = 0.05;
Cskeleton=zeros(n,n);
Acell = cell(1,n);%创建一个元素为空矩阵的n维行向量
Bcell = cell(1,n);
Ccell = cell(1,n);
MN = nchoosek(1:n,2);%数字1到n的所有2维组合
consetNum2 = 0;
for p = 1:size(MN,1)
    Acell{p}=-1;
    Bcell{p}=-1;
    Ccell{p}=-1;
end%将三个cell中所有的元素赋值为-1
for i= 1:(n-1)
    lab = i;
    pc = [];
    for j = i+1:n
        flag = true;
        indf = KCIT(data(:,i), data(:,j),[],[]);
        %         fprintf('lab: %d; neighbor: %d;result: %d',i,j,indf);
        %         fprintf('\r\n');
        if indf
            indTemp = find(ismember(MN, [i,j], 'rows')==1);
            Acell{indTemp}=0;
            Bcell{indTemp}=0; % 左
            Ccell{indTemp}=0; % 右
        end
        if indf == false
            temp = (1:n);
            temp([i,j])=[];
            conSepSet = temp;
            for k=1:min(consetNum,length(conSepSet))
                if flag == false
                    break;
                end
                condPaAll = nchoosek(temp,k);
                numCondPaAll = size(condPaAll,1);
                for p = 1:numCondPaAll
                    condPa = condPaAll(p,:);
                    x = data(:,i);
                    y = data(:,j);
                    z = data(:, condPa);
                    
                    ind = KCIT(x,y,z,[]);
                    
                    if ind 
                        indTemp = find(ismember(MN, [i,j], 'rows')==1);
                        Acell{indTemp}=condPa;
                        flag = false;
                        break;
                    end
                end
            end
            if flag == true
                pc = unique([pc,j]);
            end
        end
    end
    len=length(pc);
    for w = 1:len
        Cskeleton(lab,pc(w))=1;
        Cskeleton(pc(w),lab)=1;
    end
end
Fskeleton=ELCD(data,Cskeleton);
skeletonByVs = deduceSkeleton(Cskeleton,Acell); % by V-structure
Score1 = ScoreSkeleton(Cskeleton,skeleton);
Score2 = ScoreSkeleton(skeletonByVs,skeleton);
Score3 = ScoreSkeleton(Fskeleton,skeleton);
Score = [Score1,Score2,Score3];