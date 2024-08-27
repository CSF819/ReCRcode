function[Dskeleton] = deduceSkeletonByRCI(Cskeleton,Bcell,Ccell)
n = size(Cskeleton,1);
MN = nchoosek(1:n,2);
Dskeleton = zeros(n,n);
% for p = 1:size(MN,1)
% ij = Bcell{p} 
% ji = Ccell{p}
% end
for p = 1:size(MN,1)
    x = MN(p,1);
    y = MN(p,2);
    if sum(Bcell{p}) > 0
        temp = Bcell{p};
        lenTemp = length(temp);
        for i=1:lenTemp
            if Cskeleton(temp(i),x)==1 || Cskeleton(x,temp(i))==1 
                Dskeleton(temp(i),x)=1;
                Dskeleton(x,temp(i))=0;
            end
        end
    end
    if sum(Ccell{p}) > 0
        temp = Ccell{p};
        lenTemp = length(temp);
        for i=1:lenTemp
            if Cskeleton(temp(i),y)==1 || Cskeleton(y,temp(i))==1
                Dskeleton(temp(i),y)=1;
                Dskeleton(y,temp(i))=0;
            end
        end
    end
%     x = MN(p,1);
%     y = MN(p,2);
%     pax = find(Cskeleton(:,x)==1)';
%     chx = find(Cskeleton(x,:)==1);
%     pcx = unique([pax,chx]);
%     pay = find(Cskeleton(:,y)==1)';
%     chy = find(Cskeleton(y,:)==1);
%     pcy = unique([pay,chy]);
%     interPc = intersect(pcx,pcy);
%     if ~isempty(interPc)
%         if sum(Bcell{p}) > 0
%             diffPc = setdiff(interPc,Bcell{p});
%             if ~isempty(diffPc)
%                 Dskeleton(diffPc,x)=1;
%                 Dskeleton(x,diffPc)=0;
%             end
%         end
%         if sum(Ccell{p}) > 0
%             diffPc = setdiff(interPc,Ccell{p});
%             if ~isempty(diffPc)
%                 Dskeleton(diffPc,y)=1;
%                 Dskeleton(y,diffPc)=0;
%             end
%         end
%     end
end
end