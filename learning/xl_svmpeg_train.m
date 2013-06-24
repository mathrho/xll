function [ svmmodel ] = xl_svmpeg_train( data, labels, C, type )
%PL_SVMPEG_TRAIN Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    C = 10 ;
    type = 'onevsall' ;
end

if nargin < 4
    type = 'onevsall' ;
end

if strcmp(type, 'onevsall')

    biasMultiplier = 1 ;
    lambda = 1 / (C *  size(data, 2)) ;

    svmmodel.C = C ;
    svmmodel.nr_feature = size(data, 2) ;
    if size(labels, 1) == 1 || size(labels, 2) == 1
        svmmodel.Label = unique(labels) ;
    else
        svmmodel.Label = 1 : size(labels, 2) ;
    end
    svmmodel.nr_class = length(svmmodel.Label) ;

    w = zeros(size(data, 1) + 1, svmmodel.nr_class) ;
    parfor ci = 1 : svmmodel.nr_class
        cc = svmmodel.Label(ci) ;
        fprintf('Training model for class %s\n', num2str(cc)) ;

        if size(labels, 1) == 1 || size(labels, 2) == 1
            lab = 2 .* (labels == cc) - 1 ;
            w(:, ci) = vl_pegasos(data, int8(lab), lambda, ... 
                                  'NumIterations', length(lab) * 100, 'BiasMultiplier', biasMultiplier) ;
        else
            label = labels(:, ci) ;
            lab = label(label ~= 0) ;
            dat = data(:, label ~= 0) ;
            lambd = 1 / (C *  length(lab)) ;
            w(:, ci) = vl_pegasos(dat, int8(lab), lambd, ... 
                                  'NumIterations', length(lab) * 100, 'BiasMultiplier', biasMultiplier) ;
        end
    end

    svmmodel.bias = biasMultiplier .* w(end, :) ;
    svmmodel.w = w(1 : end - 1, :) ;

elseif strcmp(type, 'onevsone')
    
    disp('not support!!') ;
    
end

end
