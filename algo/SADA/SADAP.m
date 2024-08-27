function [SADA_skeleton,TimeCP_SADAP,TimePC_SADAP] = SADAP(data,skeleton,conSize)
%PC_RCP Summary of this function goes here
%   Detailed explanation goes here
    node = size(skeleton,1);
    SADA_Cell = {};
    SADA_skeleton = ones(node,node);
    tic;
    [SADA_skeleton,SADA_Cell] = SADAP_Main(data,data,SADA_skeleton,1:node,SADA_Cell);
    TimeCP_SADAP = toc
    
    %------------------------remove redundance-------------------------------------------------
    c  = size(SADA_Cell,2);
    Size_Of_SADA_Cell =[];
    for i = 1:c
        Size_Of_SADA_Cell = [Size_Of_SADA_Cell,size(SADA_Cell{i}{1},2)];
    end
    [a,b] = sort(Size_Of_SADA_Cell,'descend');
    Tmep_Cell = SADA_Cell;
    SADA_Cell = {};
    SADA_Cell{1}{1} = Tmep_Cell{b(1)}{1};
    for p = 2:c
        flag = 0;
        for d = 1:size(SADA_Cell,2)
            aa = Tmep_Cell{b(p)}{1};
            bb = SADA_Cell{d}{1};
            if length(Tmep_Cell{b(p)}{1}) == length(intersect(aa,bb))
                flag = 1;
            end
        end
        if flag == 0;
            SADA_Cell{size(SADA_Cell,2)+1}{1} = Tmep_Cell{b(p)}{1};
        end
    end
    Size_Of_Cell = [c,size(SADA_Cell,2),size(SADA_Cell{1}{1},2)]
    %-------------------------------------------------------------------------------------------    
    tic
    for k = 1:size(SADA_Cell,2)
%         if size(SADA_Cell{k}{1},2) > 10
%             conSizeR = 3;
%         else
            conSizeR = conSize;
%         end
        SADA_skeleton = KCI_split_linear(data(:,SADA_Cell{k}{1}),SADA_Cell{k}{1},SADA_skeleton,conSizeR);
    end
    TimePC_SADAP = toc
end

