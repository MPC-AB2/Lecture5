%% registration elastix-2D
clear all
close all
clc

addpath('D:\mpa-ab2\Lecture5')

load('data3.mat')

figure
subplot(1,3,1)
imshow(fixed,[])
title('Refer')
subplot(1,3,2)
imshow(moving,[])
title('Moving')

figure(2)
subplot(1,2,1)
imshowpair(fixed,moving)


%% Registratio - RIGID AND AFFINE

% %%%% test nalezeni elastixu
% [~,elastix_version] = system('elastix\elastix --version')
% [~,help] = system('elastix\elastix --help')

NewPath = [pwd '\TempFile'];
try
    rmdir([pwd '\TempFile\'],'s');
end
mkdir(NewPath)

% % Bez masky -- nemelo by fungovat
fMask = true(size(fixed));
mMask = true(size(moving));

% % S maskou -- uz bude fungovat
fMask=fixed>100;
fMask = logical(abs(fMask - imfill(fMask,'holes')));
% fMask = imfill(fMask,'holes');
% fMask = bwareafilt(fMask,2);
mMask=moving>100;
mMask = logical(abs(mMask - imfill(mMask,'holes')));
% mMask = imfill(mMask,'holes');
% mMask = bwareafilt(mMask,2);

mat2raw(moving,NewPath,'moving')
mat2raw(fixed,NewPath,'refer')

mat2rawMASK(mMask,NewPath,'mMask')
mat2rawMASK(fMask,NewPath,'fMask')

% % registrace
PF_name = [pwd '\parameter_files_jirina\Parameters_BSpline.txt'];
% PF_name = ['\\deza.feec.vutbr.cz\grp\UBMI\VYUKA\UCITEL\FABO2\2022\cviceni\Lecture5\parameter_files_stud\Parameters_BSpline.txt'];

CMD = ['elastix -f ' [NewPath '\refer.mhd']  ' -m ' [NewPath '\moving.mhd'] ' -out ' [NewPath '\'] ' -p ' [PF_name] ' -fMask ' [NewPath '\fMask.mhd'] ' -mMask ' [NewPath '\mMask.mhd']];
path_elastix = 'elastix\';
[~,~] = system([path_elastix CMD]);

registered = raw2mat([NewPath,'\','result.0.mhd']);

registered(registered>(35000))=0;

registered = (single(registered)./(2^15));

% [registered] = elastix2D(fixed, moving, fMask, mMask, PF);

registered = uint8((registered).*(2^8));

%% display
figure(1)
subplot(1,3,3)
imshow(registered,[])
title('Registered')

figure(2)
subplot(1,2,2)
imshowpair(fixed,registered)

%% evaluation

% [evalLung, evalOther] = Eval_Lung2D(fixed)
% [evalLung, evalOther] = Eval_Lung2D(moving)
[evalLung, evalOther] = Eval_Lung2D(registered)

