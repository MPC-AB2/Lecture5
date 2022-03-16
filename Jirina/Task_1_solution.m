%% registration elastix-2D
clear all
close all
clc

addpath('D:\mpa-ab2\Lecture5')

load data1.mat

figure
subplot(1,3,1)
imshow(fixed,[])
title('Refer')
subplot(1,3,2)
imshow(moving,[])
title('Moving')


%% Registratio - RIGID AND AFFINE

% %%%% test nalezeni elastixu
% [~,elastix_version] = system('elastix\elastix --version')
% [~,help] = system('elastix\elastix --help')

NewPath = [pwd '\TempFile'];
try
    rmdir([pwd '\TempFile\'],'s');
end

mkdir(NewPath)

mat2raw(moving,NewPath,'moving')
mat2raw(fixed,NewPath,'fixed')

% % parametric file for rigid
% PF_name = '\\deza.feec.vutbr.cz\grp\UBMI\VYUKA\UCITEL\FABO2\2022\cviceni\Lecture5\parameter_files_jirina\Parameters_Rigid.txt';
% PF_name = '\\deza.feec.vutbr.cz\grp\UBMI\VYUKA\UCITEL\FABO2\2022\cviceni\Lecture5\parameter_files_stud\Parameters_Rigid.txt';

% % parametric file for afine
% PF_name = '\\deza.feec.vutbr.cz\grp\UBMI\VYUKA\UCITEL\FABO2\2022\cviceni\Lecture5\parameter_files_stud\Parameters_Affine.txt';
PF_name = [pwd '\parameter_files_jirina\Parameters_Affine.txt'];

tic
CMD = ['elastix\elastix -f ' [NewPath '\fixed.mhd']...  
    ' -m ' [NewPath '\moving.mhd'] ' -out ' ...
    [NewPath '\'] ' -p ' PF_name];

[~,result] = system(CMD)
toc

registered = raw2mat([NewPath,'\','result.0.mhd']);

% % % transform by transformix
% CMD = ['transformix -in '  [NewPath '\moving.mhd']   ' -out ' [NewPath '\']  ' -tp ' [NewPath,'\','TransformParameters.0.txt']   ];
% path_elastix = 'elastix\';
% system([path_elastix CMD])


registered(registered>(35000))=0;


%% transform by transformix and save the deformation field
% CMD = ['transformix -def all -in ' [NewPath '\moving.mhd'] ' -out ' [NewPath '\']  ' -tp ' [NewPath,'\','TransformParameters.0.txt']   ];
% path_elastix = 'elastix\';
% system([path_elastix CMD])


%% display
subplot(1,3,3)
imshow(registered,[])
title('Registered')

figure
subplot(1,2,1)
imshowpair(fixed,moving)
subplot(1,2,2)
imshowpair(fixed,registered)
