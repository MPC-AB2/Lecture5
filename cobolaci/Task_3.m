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
mat2raw(fixed,tempFile,'fixed')
mat2raw(moving,tempFile,'moving')


% create mask,
movingMask = moving>90;
fixedMask = fixed>90;
mat2rawMASK(fixedMask,tempFile,'fixedm')
mat2rawMASK(movingMask,tempFile,'movingm')

NewPath = [pwd filesep tempFile filesep];
ParPath = [pwd filesep 'parameter_files_cobolaci' filesep];
% 
% elastix -f FixedImage_i.mhd -m MovingImage_j.mhd -p Rigid-TransforTotal -out outputdir
% elastix -f FixedImage_i.mhd -m MovingImage_j.mhd -p Rigid-TransforROI -t0 resultsfromabove -fmask selectedroiregion -out outputdir


CMD = ['elastix\elastix -f ' NewPath 'moving.mhd -m ' NewPath 'fixed.mhd -out ' NewPath ' -p '  ParPath 'Par0054_sstvd.txt'];

status = system(CMD)
 registered = raw2mat([NewPath 'result.0.R1.mhd']);
 
 registered(registered>(35000)) =0;
 
 
 %% display
subplot(1,3,3)
imshow(registered,[])
title('Registered')

figure
subplot(1,2,1)
imshowpair(fixed,moving)
subplot(1,2,2)
imshowpair(fixed,registered)


%% evaulation
registered1 = uint8(im2double(registered).*2^8);
[evalLung, evalOther] = Eval_Lung2D(registered1)