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
mat2raw(fixed, tempFile, 'fixed')
mat2raw(moving, tempFile, 'moving')


% run ELASTIX
CMD = [
    'elastix\elastix.exe' ...
    ' -f TempFile/fixed.mhd' ...
    ' -m TempFile/moving.mhd' ...
    ' -out TempFile/' ...
    ' -p parameter_files_prvni/Parameters_Affine.txt'
    ];

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