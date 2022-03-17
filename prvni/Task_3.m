%% registration elastix-2D

clear all
close all
clc
tempFile = 'TempFile';

try
    rmdir(tempFile, 's');
    mkdir(tempFile);
end

addpath('V:\mpc\ab2\Lecture5')

load data3.mat

figure
subplot(1,3,1)
imshow(fixed,[])
title('Fixed')
subplot(1,3,2)
imshow(moving,[])
title('Moving')


% [~,help] = system('elastix\elastix.exe --help')

% [~,elastix_version] = system('elastix\elastix.exe --version')


%% Registration - RIGID AND AFFINE

% save mat to raw - moving and fixed
mat2raw(fixed, tempFile, 'fixed')
mat2raw(moving, tempFile, 'moving')

% create mask
fixedMask = fixed>0;
movingMask = moving>0;

mat2rawMASK(fixedMask, tempFile, 'fixedM')
mat2rawMASK(movingMask, tempFile, 'movingM')

%% run ELASTIX
CMD = [
    'elastix\elastix.exe' ...
    ' -f TempFile/fixed.mhd' ...
    ' -m TempFile/moving.mhd' ...
    ' -out TempFile/' ...
    ' -p parameter_files_prvni/profi.txt' ...
    ' -fMask TempFile/fixedM.mhd' ...
    ' -mMask TempFile/movingM.mhd'
    ];

% run TRANSFORMIX
% CMD = [
%     'elastix\transformix.exe' ...
%     ' -def all' ...
%     ' -in TempFile/moving.mhd' ...
%     ' -tp TempFile/TransformParameters.0.txt' ...
%     ' -out TempFile/'
%     ];

status = system(CMD);

% read resulting RAW a save to variable - registered

registered = raw2mat('TempFile/result.0.mhd');

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

%%

registered = uint8(im2double(registered).*(2^8));
[evalLung, evalOther] = Eval_Lung2D(registered);

str_e = sprintf(' evalLung: %0.5f\n evalOther: %0.5f', evalLung, evalOther);
disp(str_e)
