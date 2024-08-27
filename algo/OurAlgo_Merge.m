function [Score] = OurAlgo_Merge(skeleton,FinalSaver,Result_Skeleton,k,n)
FinalSkeleton=zeros(n,n);
for i=1:k
    FinalSkeleton=FinalSkeleton+Result_Skeleton{i,1};
end
FinalSkeleton(FinalSkeleton~=0)=1;
Score=ScoreSkeleton(FinalSkeleton,skeleton);
end
