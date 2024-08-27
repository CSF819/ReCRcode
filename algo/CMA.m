function[Result]=CMA(skeleton1,skeleton2,skeleton) %Compare measure
%input skeleton1: result skeleton of primary Algo    
n=size(skeleton,1);
BR=0;RW=0;WR=0;BW=0;
for i=1:n
    for j=1:n
        if (skeleton1(i,j)==skeleton(i,j)) && (skeleton2(i,j)==skeleton(i,j))
            BR=BR+1;
        elseif (skeleton1(i,j)~=skeleton(i,j)) && (skeleton2(i,j)==skeleton(i,j))
            WR=WR+1;
        elseif (skeleton1(i,j)==skeleton(i,j)) && (skeleton2(i,j)~=skeleton(i,j))
            RW=RW+1;
        else
            BW=BW+1;
        end
    end
end
if RW+WR==0 
    CD=0;
else
    CD=(RW-WR)/(RW+WR); 
end %Comparative Deviation
Polarization=(BR+RW-BW)/(BR+RW+WR+BW);
CR=(BR+RW)/(BR+RW+WR);%Comparative Rightness
ER=(BR+RW-WR)/(BR+RW+WR);%Effective Rightness
ES=(BR+RW-WR)/(BR+RW+WR+BW);%Effective Superiority
Result=[CD,Polarization,CR,ER,ES];
end