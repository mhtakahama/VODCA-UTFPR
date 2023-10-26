close all force; clear all; 
clc; format long
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITM TO FIND DISPLACEMENT 3D IN THE TIME FOR N TARGETs
%USING A CAMERA THOUGHT OF THE IMAGE PROCESSING
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paraná (UTFPR)
%Campus Cornélio Procópio
%Laboratório Tecnológico de Vibrações Mecânicas e Manuntenção
% ___  ___  _________  ________ ________  ________                 ________  ________
% |\  \|\  \|\___   ___\\  _____\\   __  \|\   __  \               |\   ____\|\   __  \
% \ \  \\\  \|___ \  \_\ \  \__/\ \  \|\  \ \  \|\  \  ____________\ \  \___|\ \  \|\  \
%  \ \  \\\  \   \ \  \ \ \   __\\ \   ____\ \   _  _\|\____________\ \  \    \ \   ____\
%   \ \  \\\  \   \ \  \ \ \  \_| \ \  \___|\ \  \\  \\|____________|\ \  \____\ \  \___|
%    \ \_______\   \ \__\ \ \__\   \ \__\    \ \__\\ _\               \ \_______\ \__\
%     \|_______|    \|__|  \|__|    \|__|     \|__|\|__|               \|_______|\|__|
%  ___   _________  ___      ___ _____ ______
% |\  \ |\___   ___\\  \    /  /|\   _ \  _   \
% \ \  \\|___ \  \_\ \  \  /  / | \  \\\__\ \  \
%  \ \  \    \ \  \ \ \  \/  / / \ \  \\|__| \  \
%   \ \  \____\ \  \ \ \    / /   \ \  \    \ \  \
%    \ \_______\ \__\ \ \__/ /     \ \__\    \ \__\
%     \|_______|\|__|  \|__|/       \|__|     \|__|
%Student: Marcos Takahama
%Orientador: Adailton Silva Borges
%23 Abril 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Last implementation
%Actual Implementation
%% Para este algoritmo é necessário os arquivos:
% Stereoparams.mat (Calibração das cameras)
% tempo.mat        (vetor tempo da gravação)
% direita.avi      (gravação da camera esquerda) suporta outros formatos
% esquerda.avi     (gravação da camera direita)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function []=VODCA_6200_stereo_parameters()
% global shuttleVideo1 shuttleVideo2
%% 1 - Select file

%1.1 Select Videos
[name_file,PATH_camera1,vid_name1]=pick_file0101('Select the video from left camera','*.avi');
shuttleVideo1 = VideoReader([PATH_camera1 '\' vid_name1]);%Leitura do arquivo
addpath(PATH_camera1);

[name_file,PATH_camera2,vid_name2]=pick_file0101('Select the video from right camera','*.avi');
shuttleVideo2 = VideoReader([PATH_camera2 '\' vid_name2])%Leitura do arquivo
addpath(PATH_camera2);

frames_total(1)=ceil(shuttleVideo1.duration*shuttleVideo1.FrameRate);
frames_total(2)=ceil(shuttleVideo2.duration*shuttleVideo2.FrameRate);

if frames_total(1)==frames_total(2)
    warndlg(sprintf('The videos are loaded \n'));
else
    warndlg(sprintf('The videos are not loaded because are difference between the numbers of frames\n'));
    return
end

%1.2 Select Stereo Camera Calibration
[name_file,PATH_calibrator,job]=pick_file0101('Select Stereo Calibration parameters','*.mat');
load([PATH_calibrator '\' job]) %load stereo parameters for webcam
addpath(PATH_calibrator);

clear job name_file PATH_camera frames_total
frames_total=ceil(shuttleVideo1.duration*shuttleVideo1.FrameRate);
%% 2 - Initial frame and final frame
[fi,ff]=processing_parameters_questdlg0200(frames_total,shuttleVideo1,shuttleVideo2);

%% 3 - Select an frame for TEST

data1=read(shuttleVideo1,round(fi)); %imagem original do frame de teste inicial
data2=read(shuttleVideo2,round(fi)); %imagem original do frame de teste inicial
data1=undistortImage(data1,stereoParams.CameraParameters1);%%%Retirar distorções da imagem (Através da calibração)
data2=undistortImage(data2,stereoParams.CameraParameters2);%%%Retirar distorções da imagem (Através da calibração)
%% 3.1 - cut target

[target_rectangle(1,:)]=crop_target_questdlg0300(data1,'left'); %select rectangle for crop the target
[target_rectangle(2,:)]=crop_target_questdlg0300(data2,'right'); %select rectangle for crop the target
crop_target1=imcrop(data1,target_rectangle(1,:));
crop_target2=imcrop(data2,target_rectangle(2,:));
%% 4 - Filter TEST

% [gage_filter,gage_bin1,gage_bin2]=color_filter_gage0400(crop_gage1,crop_gage2); %Color filter High in the gage
%% 4.2 - Pick Color and filter then in the target (dynamic color filter)
color_pick=[255 255 255; 255 255 255]; % set a anything initial values
sens_filtro=[50 25 25; 50 25 25];

[color_pick(1,:),target_bin1,sens_filtro(1,:)]=color_filter_target0500(crop_target1,sens_filtro(1,:),color_pick(1,:),'left'); %set dynamic color filter in the target cropped
[color_pick(2,:),target_bin2,sens_filtro(2,:)]=color_filter_target0500(crop_target2,sens_filtro(2,:),color_pick(2,:),'right'); %set dynamic color filter in the target cropped
%% 5 small objects filter, erode and rode process in the image TEST (noise filter)
medfilt_option=[0 0];  % set a anything initial values
bwareopen_option=[2 2];
imerode_option=[0 0];
imdilate_option=[0 0];
strel_option={'disk' 'disk'};

[medfilt_option(1),bwareopen_option(1),imerode_option(1),imdilate_option(1),strel_option{1},prev_f4t1]=noise_filter_option0600(crop_target1,target_bin1,medfilt_option(1),bwareopen_option(1),imerode_option(1),imdilate_option(1),strel_option{1}); %set parameters for the noise filter
[medfilt_option(2),bwareopen_option(2),imerode_option(2),imdilate_option(2),strel_option{2},prev_f4t2]=noise_filter_option0600(crop_target2,target_bin2,medfilt_option(2),bwareopen_option(2),imerode_option(2),imdilate_option(2),strel_option{2}); %set parameters for the noise filter

%% 6 Index the points to orgazine the targets in a vector

[prev_centroids1,target_count1]=locate_centroids0602(prev_f4t1);
[prev_centroids2,target_count2]=locate_centroids0602(prev_f4t2);
  
%% save parameters
paste_name= datestr(now,'yyyymmddTHHMMSS');
mkdir([PATH_camera1 '\' paste_name]);
save([PATH_camera1 '\' paste_name '\parameters.mat']);
warndlg(sprintf(' Tudo pronto '));

% end
