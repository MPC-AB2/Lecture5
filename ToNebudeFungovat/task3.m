%% registration elastix-2D
% chceme vytvořit masku kde bude prát ty body které bude porovnávat 


addpath('C:\Users\xsando01\Documents\AB2\Lecture5')
clear all
close all
clc

TempFile = 'TempFile';

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

try
    rmdir TempFile s
end

mkdir(TempFile)



%% Registratio - RIGID AND AFFINE

% save mat to raw - moving and fixed
path = 'C:\Users\xsando01\Documents\AB2\Lecture5\ToNebudeFungovat\TempFile'
mat2raw(fixed,path,'fixed')
mat2raw(moving,path,'moving')


% tvorka masky
movingMask = moving > 0;%(moving>95)&(moving<130);
fixedMask = fixed>0;

mat2rawMASK(fixedMask,path,'fixedM')
mat2rawMASK(movingMask,path,'movingM')

% run ELASTIX


% CMD = ['elastix\elastix -f ' path '\fixed.mhd -m ' path '\moving.mhd -out ' path ' -p '  ...
%     'C:\Users\xsando01\Documents\AB2\Lecture5\ToNebudeFungovat\parameter_files_stud_1\Parameters_Affine.txt'...
%      ' -fMask ' path '\fixedM.mhd -mMask ' path '\movingM.mhd' ];
CMD = ['elastix\elastix -f ' path '\fixed.mhd -m ' path '\moving.mhd -out ' path ' -p '  'C:\Users\xsando01\Documents\AB2\Lecture5\ToNebudeFungovat\parameter_files_stud_1\Parameters_Affine.txt'];

status = system(CMD);

moving2 = raw2mat([path '\result.0.mhd']);

mat2raw(moving2,path,'moving2')


CMD = ['elastix\elastix -f ' path '\fixed.mhd -m ' path '\moving2.mhd -out ' path ' -p '  'C:\Users\xsando01\Documents\AB2\Lecture5\ToNebudeFungovat\parameter_files_stud_1\Parameters_Affine.txt'];

% CMD = ['elastix\elastix -f ' path '\fixed.mhd -m ' path '\moving2.mhd -out ' path ' -p '  ...
%     'C:\Users\xsando01\Documents\AB2\Lecture5\ToNebudeFungovat\parameter_files_stud_1\Parameters_BSpline.txt'...
%      ' -fMask ' path '\fixedM.mhd -mMask ' path '\movingM.mhd' ];


% CMD = ['elastix\elastix -f ' path '\fixed.mhd -m ' path '\moving.mhd -out ' path ' -p '  'C:\Users\xsando01\Documents\AB2\Lecture5\ToNebudeFungovat\parameter_files_stud_1\Parameters_Affine.txt'];
status = system(CMD);




% read resulting RAW a save to variable - registered

registered = raw2mat([path '\result.0.mhd']);



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




registered1 = im2double(registered);

registered1 =uint8(registered1.*2^8);

addpath('C:\Users\xsando01\Documents\AB2\Lecture5')
[evalLung, evalOther] = Eval_Lung2D(registered1)







