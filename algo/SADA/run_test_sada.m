clc
clear
%addpath('.\LiNGAM_DataGenerator');%添加路径
addpath(genpath('.\LiNGAM'));%添加路径
addpath(genpath('.\algo'));
%[skeleton,names] = readRnet( '.\dataset\cancer.net');
%[skeleton,names] = readRnet( '.\dataset\asia.net');
% [skeleton,names] = readRnet( '.\dataset\child.net');
% [skeleton,names] = readRnet( '.\dataset\mildew.net');
% [skeleton,names] = readRnet( '.\dataset\water.net');
%[skeleton,names] = net2sketelon( '.\dataset\insurance.net');
% [skeleton,names] = net2sketelon( '.\dataset\Alarm.net');
%  [skeleton,names] = readRnet( '.\dataset\barley.net');
% [skeleton,names] = net2sketelon( '.\dataset\hailfinder.net');
% [skeleton,names] = net2sketelon( '.\dataset\win95pts.net');
% [skeleton,names] = readRnet( '.\dataset\pathfinder.net');
% [skeleton,names] = readRnet( '.\dataset\andes.net');
     [skeleton,names] = hugin2skeleton( '.\dataset\Pigs.hugin');
%     [skeleton,names] = hugin2skeleton( '.\dataset\Link.hugin');
%     [skeleton,names] = readRnet( '.\dataset\munin2.net');
skeleton = sortskeleton(skeleton);
n = size(skeleton,1);
rand('seed', 0);
noisetype='uniform';%设定噪声类型为均匀分布
nNode=8;
nIndgree=1.25;
nSample = size(skeleton,1)*2;
noiseratio=0.3;
nFreeNode=ceil(nIndgree)+2;

%% running paramters%
%splitTries=1;%used just for test
splitTries=(2*nIndgree+2)^2; %suggested, especially for the large scale probelm 

%% generate data
skeleton = sortskeleton(skeleton);
n = size(skeleton,1);
data = SEMDataGenerator(skeleton,nSample, noisetype, noiseratio);

%% run SADA
%start1=tic;
%E = SADA_Main_new(data,splitTries)
%time1=toc(start1)
start2=tic;
F = SADA_Main(data,splitTries);
time2=toc(start2)
%% stat results
[T,P, TP,FP, WrongDirection, recall, precision]=SADA_Stat(skeleton, F)


