function [idxA,idxB,idxCut]=SADA_Split(X, splitTries)
% INPUT:
% X     - Data matrix
%OUTPUT:
% idxA,idxB,idxCut    - idx of each variable set after partition
[ns, nNode]=size(X);
objBest1=0;
objBest2=nNode;
for i=1:splitTries
    idx=randperm(nNode);%把从1到nNode这些数随机打乱成一个序列
    [~, idxInv]=sort(idx);%将idx里的元素按升序排序；~代表忽略此参数
    [idxATmp,idxBTmp,idxCutTmp]=SADA_Split_Basic(X(:, idx));
    objTmp1=min(sum(idxATmp), sum(idxBTmp));
    objTmp2=sum(idxCutTmp);
    if objBest1 < objTmp1 | (objBest1==objTmp1 & objBest2 > objTmp2)
        objBest1=objTmp1;
        objBest2=objTmp2;
        idxA=idxATmp(idxInv);
        idxB=idxBTmp(idxInv);
        idxCut=idxCutTmp(idxInv);
    end
end

function [idxA,idxB,idxCut]=SADA_Split_Basic(X)
[ns, nNode]=size(X);
idxA=false(nNode, 1);%false(n，m)生成n*m维logical零矩阵
idxB=false(nNode, 1);
idxCut=false(nNode, 1);
alpha=0.05;

%initial
idxA(1)=true;
for i=2:nNode
    if checkSeperate(X(:, idxA), X(:, i), X(:, idxCut), alpha)
        idxB(i)=true;
        break;
    else
        idxCut(i)=true;
    end
end

%d-sperate
for i=1:nNode
    if (idxA(i)~=true && idxB(i)~=true && idxCut(i)~=true)
        if sum(idxA)>sum(idxB)
            if checkSeperate(X(:, i), X(:, idxA), X(:, idxCut), alpha)
                idxB(i)=true;
            elseif checkSeperate(X(:, i), X(:, idxB), X(:, idxCut), alpha)
                idxA(i)=true;
            else
                idxCut(i)=true;
            end
        else
            if checkSeperate(X(:, i), X(:, idxB), X(:, idxCut), alpha)
                idxA(i)=true;
            elseif checkSeperate(X(:, i), X(:, idxA), X(:, idxCut), alpha)
                idxB(i)=true;
            else
                idxCut(i)=true;
            end        
        end
    end
end

%refine
for i=1:nNode
    if idxCut(i)==true
        idxCut(i)=false;
        if sum(idxA)>sum(idxB)
            if checkSeperate(X(:, i), X(:, idxA), X(:, idxCut), alpha)
                idxB(i)=true;
            elseif checkSeperate(X(:, i), X(:, idxB), X(:, idxCut), alpha)
                idxA(i)=true;
            else
                idxCut(i)=true;
            end
        else
            if checkSeperate(X(:, i), X(:, idxB), X(:, idxCut), alpha)
                idxA(i)=true;
            elseif checkSeperate(X(:, i), X(:, idxA), X(:, idxCut), alpha)
                idxB(i)=true;
            else
                idxCut(i)=true;
            end        
        end
    end
end


function ind = checkSeperate(x, y, z, alpha)
%%%check each v in X is independent of each v in Y, given Z
[n, dx]=size(x);
[n, dy]=size(y);
[n, dz]=size(z);
ind=true;

xzInd=false(dx,dz);
for i=1:dx
    for j=1:dz
        xzInd(i,j) = PartialCorrelationCIT(x(:,i), z(:, j), [], alpha);
    end;
end
yzInd=false(dy,dz);
for i=1:dy
    for j=1:dz
        yzInd(i,j) = PartialCorrelationCIT(y(:,i), z(:, j),[], alpha);
    end;
end     
        
for i=1:dx
    for j=1:dy
        %%%%%%%%%% shrink the condition set using independence%%%%%%%%%%
        xyzind=false(dz,1);
        for k=1:dz
            xyzind(k) = xzInd(i,k) | yzInd(j,k);
        end;
        %%%%%%%%%% shrink the condition set using cond independence%%%%%%%%%%
        for k1=1:dz                
            if xyzind(k1)==false 
                for k2=1:dz
                    if  k1~=k2
                        xyzind(k2) = PartialCorrelationCIT(x(:,i), z(:, k1), z(:, k2), alpha) | PartialCorrelationCIT(y(:,j),z(:, k1), z(:, k2), alpha);
                    end
                end
            end
        end;
        zTmp=z(:, find(xyzind==false));

        if isempty(zTmp)
            ind = PartialCorrelationCIT(x(:,i), y(:,j), [], alpha);
            if ind ==false
                return
            end;
        else
            %%%%%%%%%% enumerate all possible subsets of condSetIdx %%%%%%%%
            ind=false;
            dzTmp=size(zTmp,2);
            maxCITSize=min(size(zTmp,2),log2(n/10));
            for k=0:(2^maxCITSize-1)
                B=dec2bin(k,dzTmp);
                if true==PartialCorrelationCIT(x(:,i), y(:,j), zTmp(:, find(B=='1')), alpha);
                    ind=true;
                    break ;
                end
            end
            if ind == false 
                return;
            end;
        end
    end
end

function cit=PartialCorrelationCIT(x, y, Z, alpha)%判断偏相关
%implement according to  http://en.wikipedia.org/wiki/Partial_correlation
if isempty(Z)%判断Z是否为零矩阵
    n=length(x);
    ncit=0;
    pcc=corrcoef(x,y);%pcc:Pearson Correlation Coefficient皮尔逊相关系数;
                      %corrcoef(A)返回x与y的相关系数矩阵
    pcc=pcc(1,2);
else
    [n,ncit]=size(Z);%若Z不为0矩阵，按照公式计算pcc的值
    Z=[ones(n,1),Z];%ones(n,1)构建一个n元列向量
    wx=Z\x;         %wx=Z\x=Z^(-1)*x
    rx=x-Z*wx;      %rx实为ρx
    wy=Z\y;
    ry=y-Z*wy;
    pcc=(n*rx'*ry- sum(rx)*sum(ry))/sqrt(n*rx'*rx-sum(rx)^2)/sqrt(n*ry'*ry-sum(ry)^2);
end
zpcc=0.5*log((1+pcc)/(1-pcc));
if sqrt(n-ncit-3)*abs(zpcc) > icdf('normal',1-alpha/2,0,1) 
    cit=false;
else
    cit=true;
end
