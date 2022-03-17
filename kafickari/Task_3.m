%% registration elastix-2D

clear all
close all
clc
tempFile = 'TempFile';
addpath('C:\Users\xschne08\Documents\mpc_ab2\Lecture5')


% try
%     rmdir(tempFile);
% end


%%



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

%% mask
BW = zeros(size(fixed));
BW(fixed<80) = 1;
BW = imfill(BW);
imshow(BW,[])
pom = zeros(size(BW));
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
BW(CC.PixelIdxList{idx}) = 0;
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
pom(CC.PixelIdxList{idx}) = 1;
BW(CC.PixelIdxList{idx}) = 0;
CC = bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
pom(CC.PixelIdxList{idx}) = 1;
imshow(pom)

mask_LUNG = pom;

%% Registratio - RIGID AND AFFINE

% save mat to raw - moving and fixed
mat2raw(fixed,tempFile,'fixed')
mat2raw(moving,tempFile,'moving')

% create mask
movingMask = moving>0;
fixwedMask = fixed>0;

mat2rawMASK(mask_LUNG,tempFile,'fixedM')
mat2rawMASK(movingMask,tempFile,'movingM')


NewPath = [pwd filesep tempFile];
ParPath = [pwd filesep 'parameter_files_kafickari']


% run ELASTIX
CMD = ['elastix\elastix -f ' NewPath '\fixed.mhd -m ' NewPath...
    '\moving.mhd -out ' NewPath ' -p '  ParPath '\Parameters_BSpline.txt -fMask ' NewPath '\fixedM.mhd -mMask ' NewPath '\movingM.mhd']; %elastix

%% from zoo
% CMD = ['elastix\elastix -f ' NewPath '\fixed.mhd -m ' NewPath '\moving.mhd -fMask ' NewPath '\fixedM.mhd -out ' NewPath ' -p ' ParPath '\params.txt']; %elastix

% 
% CMD = ['elastix\transformix -def all -in ' NewPath '\moving.mhd -out ' NewPath ' -tp ' NewPath '\TransformParameters.0.txt'];
status = system(CMD)



% read resulting RAW a save to variable - registered

registered = raw2mat([NewPath filesep 'result.0.mhd']);



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

%% evalution
registered1 = uint8(im2double(registered).*(2^8));
