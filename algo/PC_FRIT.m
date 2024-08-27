function [Score,consetNum2,Cskeleton,Dskeleton] = PC_FRIT(data,skeleton,consetNum)
n = size(skeleton,1);
alpha = 0.05;
Cskeleton=zeros(n,n);
Acell = cell(1,n);
Bcell = cell(1,n);
Ccell = cell(1,n);
MN = nchoosek(1:n,2);
consetNum2 = 0;
for p = 1:size(MN,1)
    Acell{p}=-1;
    Bcell{p}=-1;
    Ccell{p}=-1;
end
for i= 1:(n-1)
    lab = i;
    pc = [];
    for j = i+1:n
        flag = true;
        indf = PaCoTest(data(:,i), data(:,j),[],alpha);
        if indf
%             start1 = tic;
%             indf = KCIT(data(:,i), data(:,j),[],[]);
%             time1 = toc(start1);
%             start2 = tic;
            indf = indTestByKurtosis(data(:,i), data(:,j));
%             time2= toc(start2);
%             TimeCompare = [time1,time2]
        end
        %         fprintf('lab: %d; neighbor: %d;result: %d',i,j,indf);
        %         fprintf('\r\n');
        if indf
            indTemp = find(ismember(MN, [i,j], 'rows')==1);
            Acell{indTemp}=0;
            Bcell{indTemp}=0; % ×ó
            Ccell{indTemp}=0; % ÓÒ
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
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind = 0;
%                     indf = PaCoTest(x, y,z,alpha);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     if indf
                    res1 = (eye(size(x,1))-z*((z'*z)^-1)*z')*x;
                    res2 = (eye(size(y,1))-z*((z'*z)^-1)*z')*y;
                    ind11 = PaCoTest(res1,res2,[],alpha);
                    if ind11
%                         ind22 = KCIT(res1,res2,[],[]);
                        ind = indTestByKurtosis(res1,res2);
%                         compareCI = [ind22,ind]
                        %mean(res1.*res2)
                        consetNum2 = consetNum2 + 1;
                    else
                        continue;
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if ind
                        for w1 = 1:length(condPa)
                            ind2 = PaCoTest(res1,data(:,condPa(w1)),[],alpha);
                            if ind2
%                                 ind2 = KCIT(res1,data(:,condPa(w1)),[],[]);
                                ind2 = indTestByKurtosis(res1,data(:,condPa(w1)));
                            end
                            if ind2 == false
                                break;
                            end
                        end
                        %%%%%%%%%%%%
                        if ind2
                            indTemp = find(ismember(MN, [i,j], 'rows')==1);
                            Bcell{indTemp}=condPa;
                        end
                        %%%%%%%%%%%%
                        %                          if ind2 == false
                        for w2 = 1:length(condPa)
                            ind3 = PaCoTest(res2,data(:,condPa(w2)),[],alpha);
                            if ind3
%                                 ind3 = KCIT(res2,data(:,condPa(w2)),[],[]);
                                ind3 = indTestByKurtosis(res2,data(:,condPa(w2)));
                            end
                            if ind3 == false
                                break;
                            end
                        end
                        if ind3
                            indTemp = find(ismember(MN, [i,j], 'rows')==1);
                            Ccell{indTemp}=condPa;
                        end
                        %                          else
                        %                              ind3 = 2;
                        %                          end
                    else
                        ind2 = 3;
                        ind3 = 3;
                    end
                    %                     fprintf('lab: %d; neighbor: %d; conSet: %s; result: %d; ind2: %d; ind3: %d',i,j,num2str(condPa),ind,ind2,ind3);
                    %                     fprintf('\r\n');
                    if ind %&& (ind2 || ind3)
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
    %     fprintf('lab: %d; PC: %s',i,num2str(pc));
    %     fprintf('\r\n');
    len=length(pc);
    for w = 1:len
        Cskeleton(lab,pc(w))=1;
        Cskeleton(pc(w),lab)=1;
    end
end
skeletonByVs = deduceSkeleton(Cskeleton,Acell); % by V-structure
skeletonByRCI = deduceSkeletonByRCI(Cskeleton,Bcell,Ccell); % by RCI
Dskeleton = mergeSkeleton(skeletonByVs,skeletonByRCI); % merge
Score1 = ScoreSkeleton(Cskeleton,skeleton);
Score2 = ScoreStructure(Dskeleton,skeleton);
Score = [Score1,Score2];