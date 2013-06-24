function path = xl_setup(varargin)
% XL_SETUP Add Toolbox to the path

% Authors: Zhenyang Li

% Copyright (C) 2013- Zhenyang Li
% All rights reserved.
%


[a,b,c] = fileparts(mfilename('fullpath')) ;
[a,b,c] = fileparts(a) ;
root = a ;
main = b ;

addpath(genpath(fullfile(root, main, 'learning'))) ;
addpath(genpath(fullfile(root, main, 'vision'))) ;
addpath(genpath(fullfile(root, main, 'utils'))) ;



if nargout == 0
  clear path ;
end
