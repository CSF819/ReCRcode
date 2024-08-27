clc;clear;
addpath(genpath('.\algo'));%添加路径
 %[skeleton,names] = readRnet( '.\dataset\cancer.net');
%[skeleton,names] = readRnet( '.\dataset\asia.net');%分析完毕
%[skeleton,names] = net2sketelon( '.\dataset\insurance.net');
 %[skeleton,names] = net2sketelon( '.\dataset\Alarm.net');
%[skeleton,names] = readRnet( '.\dataset\barley.net');
[skeleton,names] = net2sketelon( '.\dataset\hailfinder.net');
% [skeleton,names] = net2sketelon( '.\dataset\win95pts.net');
%[skeleton,names] = readRnet( '.\dataset\andes.net');
    skeleton = sortskeleton(skeleton);%分析完毕
    %nSample = [25,50,100,150,200];
%for j=1:5
    %j
    
    k=16;
    CE=zeros(size(skeleton,1));
    %time3=[];
    %Score=zeros(k,9);
    ScoreP=zeros(k,15);
parfor i = 1:k
    data = SEMDataGenerator(skeleton, max(500,3*size(skeleton,1)), 'uniform', 0.3);%分析完毕
    start=tic;
    %[ScoreP(i,:),CEA,csk,dsk,esk]=PC_PaCoTest_EL2(data,skeleton,3);
   % [ScoreP(i,:),CEA,csk,dsk,esk]=PC_PaCoTest_ELProb(data,skeleton,3);
    [ScoreP(i,:),CEA,csk,dsk,esk]=PC_PaCoTest_ELMean(data,skeleton,3);
    %[ScoreP(i,:),CEA,csk,dsk,esk]=PC_KCIT_EL(data,skeleton,3);
    %[Score_paca(i,:)]=PC_Old(data,skeleton);
    %[Score(i,:),~]=PC_RCIT_ELCD(data,skeleton,3);
    CE=CE+CEA;
    time=toc(start)
end
MCE=CE./k;
ScoreP;
%mean(ScoreK)
%mean(Score)
MS=mean(ScoreP)
Sstd=std(ScoreP);
save('.\Result_alpha\Hailfinder_sin_uniform.mat', 'ScoreP', 'MS', 'Sstd', 'MCE');
%time
%time3=mean(time3)
%end
