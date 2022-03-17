%% registration elastix-2D

clear all
close all
clc
tempFile = 'TempFile';

addpath('C:\Users\xpirkl04\Documents\mpc_ab2\Lecture5')

try
    rmdir(tempFile);
end

mkdir(tempFile);

load data3.mat

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
mat2raw(fixed,tempFile,'fixed');
mat2raw(moving,tempFile,'moving');

%create masks
movingMask = moving>0;
fixedMask = fixed>0;
mat2rawMASK(fixedMask,tempFile,'fixedM');
mat2rawMASK(movingMask,tempFile,'movingM');

% run ELASTIX

NewPath = [pwd filesep tempFile];
ParPath = [pwd filesep 'parameter_files_kafickari'];

%elastix
CMD = ['elastix\elastix -f ' NewPath '\fixed.mhd -m ' NewPath '\moving.mhd -out ' NewPath ' -p ' ParPath '\Parameters_BSpline.txt'];

%transformix
% CMD = ['elastix\transformix -def all -in ' NewPath '\moving.mhd -out ' NewPath ' -tp ' NewPath '\TransformParameters.0.txt'];

status = system(CMD);


% read resulting RAW a save to variable - registered
registered = raw2mat([NewPath '\result.0.mhd']);

registered(registered>(35000))=0;
registered_u8 = uint8(im2double(registered).*(2^8));
%% display
subplot(1,3,3)
imshow(registered,[])
title('Registered')

figure
subplot(1,2,1)
imshowpair(fixed,moving)
subplot(1,2,2)
imshowpair(fixed,registered)
%%
[evalLung, evalOther] = Eval_Lung2D(registered_u8)