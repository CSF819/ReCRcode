%function [cit,sig]=PaCoTest(x, y, Z, alpha)
function ind = PcKTest(x, y, Z, alpha)
if isempty(Z) 
    ind1 = PaCoTest(x, y,[],alpha);
    if ind1 == false
        ind = false;
    else
        ind = KCIT(x, y, [],[]);
    end%判断，如果x,y独立，那么再去对x，y判断给定Z，alpha时的偏相关性
else
    ind1 = PaCoTest(x, y,Z,alpha);
    if ind1 == false
        ind = false;
    else %若对x，y判断给定Z，alpha时仍然不偏相关，那么再用KCIT进行核方法的CIT，从而判断出CI性
        ind = KCIT(x, y, Z,[]);
    end
end
%%%PcKTest输出的是一个Logical变量