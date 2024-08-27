function [pos,neg] = OurSplit(v) %只需要对SpeCl中得到的pos，neg进行中心化处理即可
mu=mean(v);
sd=std(v);
c=(v-mu)./sd;
pos=v(c>0);
neg=v(c<=0);
end


