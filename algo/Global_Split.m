function [SplitData,SplitSkeleton]=Global_Split(Saver,data,skeleton,k)
parfor i=1:k
    SplitData{i,1}=data(:,Saver{i,1});
end
parfor s=1:k
    SplitSkeleton{s,1}=skeleton(Saver{s,1},Saver{s,1});
end
end
