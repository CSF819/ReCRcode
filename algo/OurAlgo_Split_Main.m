function [Saver,PosSaver,NegSaver] = OurAlgo_Split_Main(L,k) 
%INPUT：L为laplacian矩阵，k为欲分的簇数
%OUTPUT: saver存储了最终各簇中的节点序号
[v2,pos1,neg1] = SpeCl(L); 
PosOrder1=find(ismember(v2,pos1)==1);
NegOrder1=find(ismember(v2,neg1)==1);
s=1;%已分的簇数
%%%预分配内存%%%
    PosSaver=cell(floor(k/2),1);
    NegSaver=cell(ceil(k/2),1);
    Saver=cell(k,1);
%%%分治%%%
for s=1:k
    [posa,nega]=OurSplit(eval(['pos',num2str(s)]));
    eval(['pos',num2str(2*s),'=','posa',';']);
    eval(['neg',num2str(2*s),'=','nega',';']);
    %%%将求得的pos，neg转换成v2中对应的位置，即转换成全局中的节点%%%
    PosOrdera=find(ismember(v2,posa)==1);
    eval(['PosOrder',num2str(2*s),'=','PosOrdera',';'])
    NegOrdera=find(ismember(v2,nega)==1);
    eval(['NegOrder',num2str(2*s),'=','NegOrdera',';'])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [posb,negb]=OurSplit(eval(['neg',num2str(s)]));
    eval(['pos',num2str(2*s+1),'=','posb',';']);
    eval(['neg',num2str(2*s+1),'=','negb',';']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    PosOrderb=find(ismember(v2,posb)==1);
    eval(['PosOrder',num2str(2*s+1),'=','PosOrderb',';'])
    NegOrderb=find(ismember(v2,negb)==1);
    eval(['NegOrder',num2str(2*s+1),'=','NegOrderb',';'])
    s=s+1;
end
%%%因为我们只在乎每个簇中对应的节点，所以只要存储节点信息即可%%%
if mod(k,2)==1
    for i=(k-1):-1:(k-(k-1)/2)
        PosSaver{k-i,1}=eval(['PosOrder',num2str(i)]);
        i=i+1;
    end
    for j=(k-1):-1:(k-(k+1)/2)
        NegSaver{k-j,1}=eval(['NegOrder',num2str(j)]);
        j=j+1;
    end
elseif mod(k,2)==0
    for x=(k-1):-1:(k/2)
        PosSaver{k-x,1}=eval(['PosOrder',num2str(x)]);
        NegSaver{k-x,1}=eval(['NegOrder',num2str(x)]);
        x=x+1;
    end
end
for v=1:ceil(k/2)
    Saver{v,1}=NegSaver{v,1};
end
for b=1:floor(k/2)
    Saver{ceil(k/2)+b,1}=PosSaver{b,1};
end
end





