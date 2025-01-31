function [ind] = KCIT(X, Y, Z, pars)
% function [pval, stat] = indtest_new(X, Y, Z, pars)
%
%
% This function is a WRAPPER
% Performs new method (to be submitted to UAI 2011)
%
% INPUT:
%   X          Nxd1 matrix of samples (N data points, d1 dimensions)
%   Y          Nxd2 matrix of samples (N data points, d2 dimensions)
%   Z          Nxd3 matrix of samples (N data points, d3 dimensions)
%   pars       structure containing parameters for the independence test
%     .pairwise	    if true, the test is performed pairwise if d1>1 (standard: false)
%     .bonferroni   if true, bonferroni correction is performed (standard: false)
%     .width        kernel width (standard: 0, which results in an automatic -heuristic- choice)
%
% OUTPUT:
%   pval      p value of the test
%   stat      test statistic
%
%
% Copyright (c) 2011-2011  Kun Zhang
%               2011-2011  Jonas Peters
% All rights reserved.  See the file COPYING for license terms.


if ~isfield(pars,'pairwise')
    pars.pairwise = false;
end;
if ~isfield(pars,'bonferroni')
    pars.bonferroni = false;
end;
if ~isfield(pars,'width')
    pars.width = 0;
end;

if size(X,2)>1||size(Y,2)>1
    error('This test only works for one-dimensional random variables X and Y. Maybe it can be extended??')
end

if isempty(Z) %unconditional HSIC
    if pars.pairwise
        p = zeros(size(X,2),size(Y,2));
        for i = 1:size(X,2);
            for j = 1:size(Y,2);
                [sta(i,j), Cri, p_vala, Cri_appr, p(i,j)] = UInd_test(X(:,i), X(:,j), 0.8, pars.width);
            end
        end
        [pp iii] = min(p);
        [pval jj] = min(pp);
        stat = sta(iii(jj),jj);
        if pars.bonferroni
	        pval=size(X,2)*size(Y,2)*pval;
        end
    else
        [stat, Cri, p_vala, Cri_appr, pval] = UInd_test(X, Y, 0.8, pars.width);
    end
else %conditional HSIC
    [stat, Cri, p_val_appr, Cri_appr, pval] = CInd_test_new_withGP(X, Y, Z, 0.8, pars.width);
end
if pval > 0.05
    ind = 1;
else
    ind = 0;
end
return



