function data=SEMDataGenerator(skeleton,nSample, noiseType, noiseRatio)
% skeleton = sortskeleton(skeleton);
skeleton = skeleton';
[dim, dim2]=size(skeleton);
if (dim ~= dim2)
    disp('The skeleton is not square!\n');
    return;
end
data=zeros(nSample, dim);
for i=1:dim
    parentIdx=find(skeleton(i,:)==true);
    if strcmp (noiseType, 'uniform')
        noise=mapstd(rand(1, nSample))';
    elseif strcmp (noiseType, 'Gaussian')
        noise=mapstd(randn(1,nSample))';
    elseif strcmp(noiseType, 'exp')
        noise=mapstd(exprnd(1,1,nSample))';
    elseif strcmp(noiseType, 'Chi2')
        noise=mapstd(chi2rnd(1,1,nSample))';    
    elseif strcmp(noiseType, 'Gamma')
        noise=mapstd(gamrnd(2,0.5,1,nSample))';%a=1时为exp;a=n/2,b=2为卡方分布
    elseif strcmp(noiseType, 'Beta')
        noise=mapstd(betarnd(2,5,1,nSample))';
    end
    if isempty(parentIdx)
        data(:, i) = mapstd(rand(1, nSample))';
%         data(:, i) = data(:, i) - mean(data(:, i));
    else
        %weight=2*(rand(length(parentIdx),1)-0.5); 
        weight=ones(length(parentIdx),1)/length(parentIdx); 
        %data(:, i) = data (:, parentIdx) * weight+ noise*noiseRatio;
        %data(:, i) = data (:, parentIdx).^2 * weight+ noise*noiseRatio;
        %data(:, i) = exp(data (:, parentIdx)) * weight+ noise*noiseRatio;
        data(:, i) = sin(data (:, parentIdx)) * weight+ noise*noiseRatio;
        data(:, i) = mapstd(data(:, i)')';
%         data(:, i) = data(:, i) - mean(data(:, i));
    end
end
