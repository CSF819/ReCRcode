function [idxA,idxB,idxCut]=SADA_Split_new(X, splitTries)
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
        xzInd(i,j) = KCIT(x(:,i), z(:, j), [], []);
    end;
end
yzInd=false(dy,dz);
for i=1:dy
    for j=1:dz
        yzInd(i,j) = KCIT(y(:,i), z(:, j),[], []);
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
                        xyzind(k2) = KCIT(x(:,i), z(:, k1), z(:, k2), []) | KCIT(y(:,j),z(:, k1), z(:, k2), []);
                    end
                end
            end
        end;
        zTmp=z(:, find(xyzind==false));

        if isempty(zTmp)
            ind = KCIT(x(:,i), y(:,j), [],[]);
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
                if true==KCIT(x(:,i), y(:,j), zTmp(:, find(B=='1')),[]);
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

function [ind]=KCIT(x, y, Z, pars)%判断偏相关

if ~isfield(pars,'pairwise')
    pars.pairwise = false;
end;
if ~isfield(pars,'bonferroni')
    pars.bonferroni = false;
end;
if ~isfield(pars,'width')
    pars.width = 0;
end;

if size(x,2)>1||size(y,2)>1
    error('This test only works for one-dimensional random variables X and Y. Maybe it can be extended??')
end

if isempty(Z) %unconditional HSIC
    if pars.pairwise
        p = zeros(size(x,2),size(y,2));
        for i = 1:size(x,2);
            for j = 1:size(y,2);
                [sta(i,j), Cri, p_vala, Cri_appr, p(i,j)] = UInd_test(x(:,i), x(:,j), 0.8, pars.width);
            end
        end
        [pp iii] = min(p);
        [pval jj] = min(pp);
        stat = sta(iii(jj),jj);
        if pars.bonferroni
	        pval=size(x,2)*size(y,2)*pval;
        end
    else
        [stat, Cri, p_vala, Cri_appr, pval] = UInd_test(x, y, 0.8, pars.width);
    end
else %conditional HSIC
    [stat, Cri, p_val_appr, Cri_appr, pval] = CInd_test_new_withGP(x, y, Z, 0.8, pars.width);
end
if pval > 0.05
    ind = 1;
else
    ind = 0;
end
return
