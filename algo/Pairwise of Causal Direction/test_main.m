function [  ] = test_main(  )%%%%≤‚ ‘
clear all;clc;
dims=200;
a=zeros(dims,4);
for i=2:dims
    i
[kkk,kest,Estimate_Error,number_connect_edge,true_connection_identified,true_absence_identified,ntruepruned,nsuperfluous]=Main(i);
a(i,:)=[Estimate_Error,true_connection_identified,ntruepruned,nsuperfluous]';
end
xlswrite('aa.xls', a);
disp('finished');
end