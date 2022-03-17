%% registration elastix-2D

clear all
close all
clc
tempFile = 'TempFile';
addpath('E:\skola\magisterske\4.semester\AB2\MPC-AB2\Lecture5\cobolaci\elastix');

try
    rmdir(tempFile)
end

mkdir(tempFile);

load data1.mat

figure
subplot(1,3,1)
imshow(fixed,[])
title('Fixed')
subplot(1,3,2)
imshow(moving,[])
title('Moving')


[~,help] = system('elastix\elastix.exe --help')

[~,elastix_version] = system('elastix\elastix.exe --version')



%% Registratio - RIGID AND AFFINE

% save mat to raw - moving and fixed
mat2raw(fixed,tempFile,'fixed')
mat2raw(moving,tempFile,'moving')



% run ELASTIX

NewPath = [pwd filesep tempFile filesep];
ParPath = [pwd filesep 'parameter_files_cobolaci' filesep];
CMD = ['elastix\elastix -f ' NewPath 'fixed.mhd -m ' NewPath 'moving.mhd -out ' NewPath ' -p '  ParPath 'Parameters_Rigid.txt'];
status = system(CMD)
CMD = ['elastix\elastix -in ' NewPath 'moving.mhd -m ' NewPath 'moving.mhd -tp ' NewPath ' -tp '  ParPath 'TransformParameters.0.txt'];
status = system(CMD)

% read resulting RAW a save to variable - registered

registered = raw2mat([NewPath 'result.0.mhd']);



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
