clc;clear
Beta=struct2cell(load("Alarm_Beta.mat"));
chi2=struct2cell(load("Alarm_Chi2.mat"));
exp=struct2cell(load("Alarm_exp.mat"));
Gamma=struct2cell(load("Alarm_Gamma.mat"));
Gaussian=struct2cell(load("Alarm_Gaussian.mat"));
Uniform=struct2cell(load("Alarm_Uniform.mat"));
%%
RPFBeta=[Beta{2}(1:3),Beta{2}(6:8),Beta{2}(11:13)];
RPFchi2=[chi2{2}(1:3),chi2{2}(6:8),chi2{2}(11:13)];
RPFexp=[exp{2}(1:3),exp{2}(6:8),exp{2}(11:13)];
RPFGamma=[Gamma{2}(1:3),Gamma{2}(6:8),Gamma{2}(11:13)];
RPFGaussian=[Gaussian{2}(1:3),Gaussian{2}(6:8),Gaussian{2}(11:13)];
RPFUniform=[Uniform{2}(1:3),Uniform{2}(6:8),Uniform{2}(11:13)];
%% 画图
Recall=[RPFUniform(7),RPFGaussian(7),RPFGamma(7),RPFexp(7),RPFchi2(7),RPFBeta(7)];
Precision=[RPFUniform(8),RPFGaussian(8),RPFGamma(8),RPFexp(8),RPFchi2(8),RPFBeta(8)];
F1=[RPFUniform(9),RPFGaussian(9),RPFGamma(9),RPFexp(9),RPFchi2(9),RPFBeta(9)];
%categories = {'Uniform', 'Gaussian', 'Gamma','Exponential','Chi-Square','Beta'};
categories = {'Recall','Precision','F1'};
% 绘制分组柱状图
x = 1:length(categories);
width = 0.9;
figure;
bar(x, [Recall' Precision' F1'], width, 'LineWidth', 1);

% 设置柱子属性
 colors = [0,191,255; 0,128,255; 0,64,255;64,0,255;128,0,255;191,0,255];
 colors=colors./255;
 bars = get(gca, 'Children');
set(gca, 'Children');
for i = 1:length(bars)
    bar = bars(i);
    set(bar, 'FaceColor', colors(i,:));
end

% 设置x轴刻度标签
xticks(x);
xticklabels(categories);

% 添加图例
legend('Uniform', 'Gaussian', 'Gamma','Exponential','Chi-Square','Beta');

% 添加标题和标签
%title('Insurance');
xlabel('Metric','FontSize',7.5);

% 调整柱子位置

% 添加数值标签
% for i = 1:length(categories)
%     text(x(i)-width, Csk(i)+10, num2str(Csk(i)), 'HorizontalAlignment', 'center');
%     text(x(i), Dsk(i)+10, num2str(Dsk(i)), 'HorizontalAlignment', 'center');
%     text(x(i)+width, Esk(i)+10, num2str(Esk(i)), 'HorizontalAlignment', 'center');
% end









