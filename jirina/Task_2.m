%% registration elastix-2D

clear all
close all
clc
tempFile = 'TempFile';

addpath('C:\Users\chmelikj\Documents\chmelikj\Lecture5')

try
    rmdir(tempFile, 's')
end
mkdir(tempFile)

load data2.mat

figure
subplot(1,3,1)
imshow(fixed,[])
title('Fixed')
subplot(1,3,2)
imshow(moving,[])
title('Moving')

[~,help] = system('elastix\elastix.exe --help')
[~,elastix_version] = system('elastix\elastix.exe --version')

%% Registration - RIGID AND AFFINE
% save mat to raw - moving and fixed
mat2raw(fixed,tempFile,'fixed')
mat2raw(moving,tempFile,'moving')

% create masks
movingMask = moving>0;
fixedMask = fixed>0;
mat2rawMASK(fixedMask,tempFile,'fixedM')
mat2rawMASK(movingMask,tempFile,'movingM')

% run ELASTIX
NewPath = [pwd filesep tempFile filesep];
ParPath = [pwd filesep 'parameter_files_jirina' filesep];

CMD = ['elastix\elastix -f ' NewPath 'fixed.mhd -m ' NewPath...
    'moving.mhd -out ' NewPath ' -p ' ParPath 'Parameters_Affine.txt '...
    '-fMask ' NewPath 'fixedM.mhd -mMask ' NewPath 'movingM.mhd']; % Elastix

% CMD = ['elastix\transformix -def all -in ' NewPath 'moving.mhd -out ' NewPath ' -tp ' NewPath 'TransformParameters.0.txt']; % Transformix
status = system(CMD)

% read resulting RAW a save to variable - registered
registered = raw2mat([NewPath 'result.0.mhd']);
% registered = raw2mat([NewPath 'result.mhd']);
registered(registered>(35000))=0;

%% display
subplot(1,3,3)
imshow(registered,[])
title('Registered')

figure
subplot(1,2,1)
imshowpair(fixed,moving)
subplot(1,2,2)
imshowpair(fixed,registered)
