function [skeleton,names2] = readRnet(file)
fid=fopen(file);%打开文件
%%%%%%%%%%%%%%%%%%%%需要节点数，初始化skeleton%%%%%%%%%%%%%%%%%
k=0;
while ~feof(fid)
    tline=fgets(fid);% 从文件读入一行文本（不含回车键）
    tline= strrep(tline,'''','');%将tline中的单引号替换成''
    if ~isempty(tline) % 判断是否空行
        [~,n]=size(tline); %如果不是的话，赋值
        if n>=4
            yuchu = tline(1,1:end);%如果n>=4，给yuchu赋值为tline的第一行
            pi=yuchu(1,1:4);%pi赋值为yuchu的第一行前四列
            if strcmp(pi,'node')==1
                k=k+1;
            end  %当pi=='node'时，k=k+1
        end
    end
    stop='potential';
    if  regexpi(yuchu,stop)  %若yuchu中出现了stop，那么跳出循环
        break
    end
end
skeleton=zeros(k,k); %初始化skeleton为0矩阵
%%%第一步最重要功能就是确定skeleton的维数，那其实维数就是数据文件中node的数目%%%
%%%%%%%%%%%%%%%%%%%给节点命名%%%%%%%%%%%%%%%%%
j=0;
frewind(fid) %指针移到前头
while ~feof(fid)%判断fid是否为结束指示符
    tline=fgets(fid);% 从文件读入一行文本（不含回车键）
    tline= strrep(tline,'''',''); %将tline中的单引号删除
    [~,n]=size(tline);%~表示之后不会使用这个变量，即只将size(tline)赋值给n
    pipei=tline(1,1:end);%写入tline的第一行所有元素
    stop='potential';
    if  regexpi(pipei,stop)
        break
    end   %如果pipei中有出现‘potential’，则跳出while循环
    if n>=4
        yuchu=tline(1,1:end);
        pa='node.*';
        out=regexp(yuchu,pa,'match');%out为yuchu中所有具有node.前缀的字符串值
        if ~isempty(out)
            j=j+1;
            A = char(out); %A为out的字符串向量
            A=strrep(A,' ','');
            A=strrep(A,' ','');
            A=strrep(A,' ','');
            names{j}=strrep(A,'node','');%去掉node只留后缀
        end
    end
end
for k = 1:size(names,2)
    names2{k} = names{k}(1:end-1);
end
%%%将有node前缀的元素记录到数组中%%%
%%%%%%%%%%%%%%%%%%%生成sketelon结果%%%%%%%%%%%%%%%%%
frewind(fid)
while ~feof(fid)
    tline=fgets(fid);% 从文件读入一行文本（不含回车键）
    tline= strrep(tline,'''','');
    [~,n]=size(tline);
    
    if n>=2
        yuchu=tline(1,1:end);
        p='potential';
        if regexpi(yuchu,p)
            pa='\|.*\w';%父节点，\|表示字符|，.为通配符表示不用管的字符串，*表示与匹配所用的标准字符串出现0次或更多，\w表示匹配任意的单个文字字符
            A=regexp(yuchu,pa,'match');
            A=strrep(A,'| ','');
            A= regexp(A,'\s+','split');%\s 匹配任意的单个空白字符
            if ~isempty(A)
                A=A{1};
            end
            pa='potential.*\|';
            B=regexp(yuchu,pa,'match');
            B=strrep(B,'potential','');
            B=strrep(B,'(','');
            B=strrep(B,' ','');
            B=strrep(B,'|','');
            len=length(A);
            for n=1:len
                if ~isempty(A{n})
                    inda=strcmp(names2,A{n});
                    f= inda==1;
                    indb=strcmp(names2,B);
                    z= indb==1;
                    skeleton(f,z)=1;
                end
            end
        end
    end
end
fclose(fid);
end
%%%node之间有potential关系时，矩阵对应元素为1，其余为0