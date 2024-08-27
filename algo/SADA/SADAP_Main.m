function [Oskeleton,SADAcell] = SADAP_Main(X,data,Cskeleton,idx,SADAcell)
Oskeleton = Cskeleton;
[n,d]=size(X);
if d <= max(floor(size(Cskeleton,1)/10),3)
    SADAcell{size(SADAcell,2)+1} = {idx};
else
%     [idxA,idxB,idxCut]=SADA_Split_Test(X,Ind_Temp,Ds_Temp,Ind_Cell,idx,skeleton);
%     [idxA,idxB,idxCut]=SADA_Split_True(X);
[idxA,idxB,idxCut]=SADA_Split(X,1);
    V1 = find(idxA == 1)';
    V2 = find(idxB == 1)';
    C = find(idxCut == 1)';
    R1 = idx(V1);
    R2 = idx(V2);
    RC = idx(C);
    
%     Tskeleton = ones(size(skeleton,1),size(skeleton,1));
%     Tskeleton(R1,R2) =0;
%     Tskeleton(R2,R1) =0;
%     ScoreObtain= ScoreOSkeleton2(Tskeleton,skeleton)
    
    Oskeleton(R1,R2) = 0;
    Oskeleton(R2,R1) = 0;
    
    if sum(idxA)==0 | sum(idxB)==0
        %         [Oskeleton,SADAcell] = SADA_Cai( data(:, [R1,R2,RC]),data,Oskeleton,[R1,R2,RC],SADAcell,skeleton,Ind_Temp,Ds_Temp,Ind_Cell);
        SADAcell{size(SADAcell,2)+1} = {[R1,R2,RC]};
    else
        [Oskeleton,SADAcell] = SADAP_Main( data(:, [R1,RC]),data,Oskeleton,[R1,RC],SADAcell);
        [Oskeleton,SADAcell] = SADAP_Main( data(:, [R2,RC]),data,Oskeleton,[R2,RC],SADAcell);
    end
end






