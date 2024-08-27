function E=SADA_Merge(data, EA,EB)
% INPUT:
% EA,EB - the solution of subproblems, in the form [a,b,P] presets a->b, P is Pvalue of the edge
%OUTPUT:
% E     - the merge edges 

%merge 
E=[EA;EB];
if ~isempty(E)
    nE=size(E,1);
    flag=true(nE, 1);
    E=sortrows(E, 3);%sort in asending order of p valued
    %remove pair redudancy 
    for i=1:nE
        for j=i+1:nE
            if E(i,1)==E(j,1) & E(i,2)==E(j,2)
                flag(j)=false;
            end
        end
    end
    E=E(flag, :);
    
    %remove path redundancy
    nE=size(E,1);
    if nE>0    
        flag=true(nE, 1);
        nNode=max(max(E(:,[1,2])));
        reachable=logical(eye(nNode));
        GInter=false(nNode, nNode, nNode);

%         for i=1:nE
%             reachable(E(i,1),E(i,2))=true;
%             for j=1:nNode
%                 for k=1:nNode
%                     if ~(j==E(i,1)&& k==E(i,2))
%                         if reachable(j, E(i,1))&&reachable(E(i,2),k)%E(i.1)-> E(i,2) are
%                             GInter(j,k, E(i,1))=true;
%                             GInter(j,k, E(i,2))=true;
%                             GInter(j,k, :)= GInter(j,k, :) | GInter(j,E(i,1), :)|GInter(E(i,2),k, :);
%                         end
%                     end
%                 end
%             endx`
%         end
        for i=1:nE
            GInter(E(i,1),:, E(i,2))=true;
            GInter(:, E(i,2), E(i,1))=true;
        end
        for i=1:nE
            %GInter(E(i,1),E(i,2),:)=true;
            GInter(E(i,1),E(i,2),E(i,1))=false;
            GInter(E(i,1),E(i,2),E(i,2))=false;
            if checkSeperate(data(:, E(i,1)), data(:, E(i,2)), data(:, GInter(E(i,1),E(i,2),:), :), 0.05)
                flag(i)=false;
            end
        end
        E=E(flag, :);
    end
    %remove conflict
    nE=size(E,1);
    if nE>0     
        flag=true(nE, 1);
        nNode=max(max(E(:,[1,2])));
        reachable=logical(eye(nNode));
        for i=1:nE
            Gtmp=reachable;
            Gtmp(E(i,1), E(i,2))=true;% add reachable E(i,1) -> E(i,2) 
            Gtmp(Gtmp(:, E(i,1)),Gtmp(E(i,2),:))=true;%x->E(i.1)-> E(i,2)->Y
            if ~isequal(Gtmp & Gtmp', eye(nNode))
                flag(i)=false;
            else
                reachable=Gtmp;
            end
        end
        E=E(flag, :);
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
        xzInd(i,j) = KCIT(x(:,i), z(:, j), [], alpha);
    end;
end
yzInd=false(dy,dz);
for i=1:dy
    for j=1:dz
        yzInd(i,j) = KCIT(y(:,i), z(:, j),[], alpha);
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
                        xyzind(k2) = KCIT(x(:,i), z(:, k1), z(:, k2), alpha) | KCIT(y(:,j),z(:, k1), z(:, k2), alpha);
                    end
                end
            end
        end;
        zTmp=z(:, find(xyzind==false));

        if isempty(zTmp)
            ind = KCIT(x(:,i), y(:,j), [], alpha);
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
                if true==KCIT(x(:,i), y(:,j), zTmp(:, find(B=='1')), alpha);
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

function [ind]=KCIT(x, y, Z, pars)%ÅĞ¶ÏÆ«Ïà¹Ø

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