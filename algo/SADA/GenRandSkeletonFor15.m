function skeleton = GenRandSkeletonFor15(nNode, nFreeNode, ~)
skeleton = false(nNode,nNode);
for i = (nFreeNode+1):nNode
    flag = true;
    t = 1;
    while flag
        s = randperm(i-1);
        num = rand;
        if num <= 1/3
            pa  = s(1);
            if length(find(skeleton(:, s(1)))==1) < nFreeNode + t
                skeleton(pa,i) = 1;
                flag = false;
            end
        end
        if num >1/3 && num <= 2/3
            pa  = s(1:2);
            if length(find(skeleton(:, s(1)))==1) < nFreeNode + t && length(find(skeleton(:, s(2)))==1) < nFreeNode + t
                skeleton(pa,i) = 1;
                flag = false;
            end
        end
        if num > 2/3
            pa  = s(1:3);
            if length(find(skeleton(:, s(1)))==1) < nFreeNode + t && length(find(skeleton(:, s(2)))==1) < nFreeNode + t && length(find(skeleton(:, s(3)))==1) < nFreeNode + t
                skeleton(pa,i) = 1;
                flag = false;
            end
        end
        t = t + 1;
    end
end
end