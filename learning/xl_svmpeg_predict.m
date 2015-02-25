function [ pred, ap, acc, scores, confus ] = xl_svmpeg_predict( data, labels, svmmodel, type )
%PL_SVMPEG_PREDICT Summary of this function goes here
%   Detailed explanation goes here

pred = [] ;
ap = [] ;
acc = [] ;
confus = [] ;
scores = [] ;

if nargin < 4
    %svmtype = 'pegasos' ;
    type = 'onevsall' ;
end

if strcmp(type, 'onevsall')

    w = svmmodel.w ;
    bias = svmmodel.bias ;

    testScoresAll = w' * data + repmat(bias', 1, size(data, 2)) ;
    testScoresAll = testScoresAll' ;
    scores = testScoresAll ;
    [mx, pred] = max(testScoresAll, [], 2) ;
    
    if isempty(labels)
        return ;
    end
    
    ap = zeros(svmmodel.nr_class, 1) ;
    for ci = 1 : svmmodel.nr_class
        cc = svmmodel.Label(ci) ;
        display(['Iteration: ' num2str(ci) '/' num2str(svmmodel.nr_class) ' for class: ' num2str(cc)]) ;
        
        if size(labels, 1) == 1 || size(labels, 2) == 1
            labTs = 2 .* (labels == cc) - 1 ;
            testScores = testScoresAll(:, ci) ;
        else
            %label = labels(:, ci) ;
            %labTs = label(label ~= 0) ;
            %testScores = testScoresAll(label ~= 0, ci) ;
            labTs = labels(:, ci) ;
            testScores = testScoresAll(:, ci) ;
        end

        [drop, drop, info] = vl_pr(labTs, testScores) ;
        %ap(ci) = info.auc ;
        ap(ci) = info.ap ;
    end
    
    display(['Mean AP:  ' num2str(mean(ap))]) ;
    if size(labels, 1) == 1 || size(labels, 2) == 1
        idx = sub2ind([max(svmmodel.Label), max(svmmodel.Label)], xl_vec(labels), xl_vec(pred)) ;
        confus = zeros(max(svmmodel.Label)) ;
        confus = vl_binsum(confus, ones(size(idx)), idx) ;
        
        dd = diag(confus) ;
        sm = sum(confus, 2) ;
        acc = dd(sm ~= 0) ./ sm(sm ~= 0) ;
        display(['Accuracy: ' num2str(mean(acc))]) ; 
    else
        %[fr labelsUni] = find(labels) ;
        %idx = sub2ind([max(svmmodel.Label), max(svmmodel.Label)], xl_vec(labelsUni), xl_vec(pred)) ;
        %confus = zeros(max(svmmodel.Label)) ;
        %confus = vl_binsum(confus, ones(size(idx)), idx) ;
        
        pred0 = zeros(size(labels)) ;
        pred0(sub2ind(size(labels), xl_vec(1 : size(labels, 1)), pred)) = 1 ;
        pred0 = sum(pred0 .* labels, 2) ;
        corr = sum(pred0 > 0) ;
        acc = corr ./ sum(pred0 ~= 0) ;
        display(['Accuracy: ' num2str(acc) ' (' num2str(corr) '/' num2str(sum(pred0 ~= 0)) '-' num2str(size(labels, 1)) ')']) ;
    end

elseif strcmp(type, 'onevsone')

    disp('not support!!') ;
    
end


end
