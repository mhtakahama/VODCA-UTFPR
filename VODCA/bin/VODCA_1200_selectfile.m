%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FUNCTION Save project
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paraná (UTFPR)
%Campus Cornélio Procópio
%Laboratório Tecnológico de Vibrações Mecânicas e Manuntençãoo
%Student: Marcos Takahama
%Orientador: Adailton Silva Borges
%23 Abril 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Last implementation
%Actual Implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function VODCA_1200_selectfile
global file_load

[file_name,PATH] = uigetfile('*.mat','*.bkp','Open file');
fid = fopen(file_name,'rt');

if fid(1)<1
    warndlg('Couldnt be possible open the file, please put this algoritm in the same folder',...
        '!! Warning !!')
    return
end
close all; clc;
load([PATH '\' file_name])
end