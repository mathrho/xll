function [] = xl_voc_cls_train( descriptor )
%XL_VOC_CLS_TRAIN Summary of this function goes here
%   Detailed explanation goes here


expDir = './VOC/';

addpath('/datastore/zli2/Workspace/Data/PASCAL/VOC2007/VOCdevkit/VOCcode/');
VOCinit
imgset='trainval';

if(~isempty(model))
    model = ['-' model];
end

%load fisher
ld = load(fullfile(expDir, 'Measurements/', ['voc2007_'  imgset '_fisher' model '_phow-ss2_spm-3122_gmm-256.mat']));
if(~isempty(strfind(model, 'sqrt')))
    fish = double(ld.fish_sqrt);
else
    fish = double(ld.fish);
end

%truncate fisher
%dim = ld.model.nPCADims * ld.model.numWords * 2;
%fish = normalizeFisher(fish(1:dim, :));

%normalization
if(~isempty(strfind(model, 'sqrt')))
    model = [model '-L1-sqrt'];
    fish = normalizeHistsL1(fish, ld.model.spm);
    fish = sign(fish) .* sqrt(abs(fish));
    %fish = normalizeFisher(fish, ld.model.spm);
    %fish = normalizeFisherColsL2(fish, ld.model.spm);
else
    fish = normalizeFisher(fish, ld.model.spm);
end
%fish = normalizeFisherColsL1(fish, ld.model.spm);
%fish = normalizeFisherColsPolarL1(fish, ld.model.spm);

%load labels
load(['ClassificationVOC2007' imgset 'PCls.mat']);

%
%labels = (labels == 1);

%start training
vl_twister('state', 0);
%svmmodel = svmpeg_train(labels, fish);
svmmodel = xl_svmpeg_train(fish, labels);

save('-v7.3', fullfile(expDir, 'MODELS/', ['voc2007_svmpeg_model_pcls_fisher' model '_phow-ss2_gmm-256.mat']), 'svmmodel');


end

