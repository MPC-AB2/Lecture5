%% registration elastix-2D

clear all
close all
clc
tempFile = 'TempFile';

addpath('C:\Users\xkanto13\Desktop\ABO2\Lecture5');


try 
    rmdir('TempFile')
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


mat2raw( moving, tempFile, 'moving')
mat2raw( fixed, tempFile, 'fixed')

% run ELASTIX
newPath = [pwd filesep tempFile filesep];
parPath = [pwd filesep 'Radio_param' filesep];
% ELAXIS
CMD = ['elastix\elastix -f ' newPath 'fixed.mhd -m ' newPath 'moving.mhd -out ' newPath ' -p ' parPath 'Parameters_zoo.txt'];

status = system(CMD);



% ELAXIS: 
registered = raw2mat([newPath 'result.0.mhd']);
% TRANSFORMIX:?
% registered = raw2mat([newPath 'result.mhd']);

registered(registered>(35000))=0;



% display
subplot(1,3,3)
imshow(registered,[])
title('Registered')

figure
subplot(1,2,1)
imshowpair(fixed,moving)
subplot(1,2,2)
imshowpair(fixed,registered)
% evaluace
registered = uint8(im2double(registered).*(2^8));
[evaluating, evalOther] = Eval_Lung2D(registered)
% %%
% moving_mask = imbinarize(moving);
% moving_mask = bwareafilt(moving_mask,1);
% moving_mask = imopen(moving_mask, SE);
% moving_mask = ~moving_mask;
% moving_mask = bwareafilt(moving_mask,2,'smallest');
% fixed_mask = imbinarize(fixed);
% fixed_mask = bwareafilt(fixed_mask,1);
% fixed_mask = imopen(fixed_mask, SE);
% fixed_mask = ~fixed_mask;
% fixed_mask = bwareafilt(fixed_mask,2,'smallest');
% 
% 
% 
% 
% % ulozit masky
% mat2rawMASK(moving_mask, tempFile, 'movingM')
% mat2rawMASK(fixed_mask, tempFile, 'fixedM')
% 
% mat2raw(registered, tempFile, 'newM');
% 
% 
% CMD = ['elastix\elastix -f ' newPath 'fixed.mhd -m ' newPath 'newM.mhd -out ' newPath ' -p ' parPath 'Parameters_zoo2.txt '...
%     '-fMask ' newPath 'fixedM.mhd -mMask ' newPath 'movingM.mhd'];
% status = system(CMD);
% 
% status = system(CMD);
% 
% 
% registered = raw2mat([newPath 'result.0.mhd']);
% % TRANSFORMIX:?
% % registered = raw2mat([newPath 'result.mhd']);
% 
% registered(registered>(35000))=0;
% 
% 
% 
% % display
% subplot(1,3,3)
% imshow(registered,[])
% title('Registered')
% 
% figure
% subplot(1,2,1)
% imshowpair(fixed,moving)
% subplot(1,2,2)
% imshowpair(fixed,registered)
% % evaluace
% registered = uint8(im2double(registered).*(2^8));
% [evaluating, evalOther] = Eval_Lung2D(registered)
% 
% 
% %% 
% % %%
% % % run ELASTIX
% % newPath = [pwd filesep tempFile filesep];
% % parPath = [pwd filesep 'Radio_param' filesep];
% % % ELAXIS
% % mat2raw(registered, tempFile, 'newM2');
% % CMD = ['elastix\elastix -f ' newPath 'fixed.mhd -m ' newPath 'newM2.mhd -out ' newPath ' -p ' parPath 'Parameters_zoo2.txt '...
% %     '-fMask ' newPath 'fixedM.mhd -mMask ' newPath 'movingM.mhd'];
% % status = system(CMD);