%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
echo off; close all force; clc; format long;
% VODCA.m  Create a main menu for Visual Object Detector by Computer Analysis (VODCA)
% links wi  th all modules for the VODCA software.
% The modules are in:
addpath('bin','bin\signal_calc_ace','bin\img','bin\stereo_image_proccess');
global answer
% global status j point3d barra interface
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      version may/2018
%Next Implementation
%modulates 3D image process DIC
%image filter in the crop image
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interface principal
% '  ___  ___  _________  ________ ________  ________                 ________  ________';...
% ' |\  \|\  \|\___   ___\\  _____\\   __  \|\   __  \               |\   ____\|\   __  \';...
% ' \ \  \\\  \|___ \  \_\ \  \__/\ \  \|\  \ \  \|\  \  ____________\ \  \___|\ \  \|\  \';...
% '  \ \  \\\  \   \ \  \ \ \   __\\ \   ____\ \   _  _\|\____________\ \  \    \ \   ____\';...
% '   \ \  \\\  \   \ \  \ \ \  \_| \ \  \___|\ \  \\  \\|____________|\ \  \____\ \  \___|';...
% '    \ \_______\   \ \__\ \ \__\   \ \__\    \ \__\\ _\               \ \_______\ \__\';...
% '     \|_______|    \|__|  \|__|    \|__|     \|__|\|__|               \|_______|\|__|';...
% '  ___   _________  ___      ___ _____ ______';...
% ' |\  \ |\___   ___\\  \    /  /|\   _ \  _   \';...
% ' \ \  \\|___ \  \_\ \  \  /  / | \  \\\__\ \  \';...
% '  \ \  \    \ \  \ \ \  \/  / / \ \  \\|__| \  \';...
% '   \ \  \____\ \  \ \ \    / /   \ \  \    \ \  \';...
% '    \ \_______\ \__\ \ \__/ /     \ \__\    \ \__\';...
% '     \|_______|\|__|  \|__|/       \|__|     \|__|';...
s={'\fontsize{35}Visual Object Detector by Computational Analysis - VODCA';
    '\fontsize{20}Federal University of Technology - Paraná (UTFPR) - Campus Cornélio Procópio';
    '\fontsize{15}Master''s Degree in Mechanical Engineering - PPGEM';...
    'Technological Laboratory of Mechanical Vibrations and Maintenance';...
    'Masters'' Degree Student: Marcos H. Takahama';...
    '\fontsize{15}Professor: Adailton Silva Borges';...
    '';...
    '\fontsize{12}Contributions for the elaboration of this algorithm: José Eduardo Simão (actual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha';...
    'Special Thanks to: João Antônio Pereira (Professor from UNESP - Ilha Solteira), Adriano Silva Borges (UTFPR-CP), Wanderlei Malaquias (UTFPR-CP).'};

hF=figure;
set(hF,'color',[1 1 1])
hA=axes;
set(hA,'color',[1 1 1],'visible','off')
% set(hA,'color',[1 1 1],'visible','on')
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
set(gcf,'Name','VODCA ver 2.0',...
    'MenuBar','none',...
    'NumberTitle','off');

logo_capes=imread('img\logo_capes.jpg');
logo_ltvm=imread('img\logo_ltvm.jpg');
logo_utfpr=imread('img\logo_utfpr.jpg');

hold on
image('CData',logo_capes,'XData',[0 0.2],'YData',[0.35 0])
hold on
image('CData',logo_ltvm,'XData',[0.3 0.6],'YData',[0.5 0])
hold on
image('CData',logo_utfpr,'XData',[0.7 1],'YData',[0.3 0])

text(0,0.83,s)
axis([0 1 0 1])

%% 1 - File Menu
i=1;

menu(i)= uimenu(gcf,'Label','File','Accelerator','P');

uimenu(menu(i),'Label','New Project','CallBack','VODCA_1100_newproject;');
uimenu(menu(i),'Label','Open','CallBack','VODCA_1200_selectfile;');
uimenu(menu(i),'Label','Save the project','CallBack','VODCA_1300_saveproject;');
uimenu(menu(i),'Label','Exit','CallBack','exit;'); %ok

i=i+1;
%% 2 - Control Menu
menu(i) = uimenu(gcf,'Label','Control','Accelerator','P');

uimenu(menu(i),'Label','See all vars','CallBack','VODCA_2100_vars'); %ok

i=i+1;
%% 3 - Snapshot Menu
menu(i) = uimenu(gcf,'Label','Snapshot','Accelerator','P');

uimenu(menu(i),'Label','1 webcam','CallBack','VODCA_3100_snap_1webcam;'); %ok
uimenu(menu(i),'Label','2 webcams','CallBack','VODCA_3200_snap_2webcams;'); %ok

i=i+1;
%% 4 - Calibrate Cameras Menu
menu(i) = uimenu(gcf,'Label','Calibrate','Accelerator','P');

uimenu(menu(i),'Label','1 camera','CallBack','cameraCalibrator;'); %ok
uimenu(menu(i),'Label','2 cameras','CallBack','stereoCameraCalibrator;'); %ok

i=i+1;
%% 5 - Movie
menu(i) = uimenu(gcf,'Label','Create a Movie','Accelerator','P');

uimenu(menu(i),'Label','1 webcam','CallBack','VODCA_5100_movie_using_1webcam;'); %Ok
uimenu(menu(i),'Label','2 webcams','CallBack','VODCA_5200_movie_using_2webcams;'); %ok
uimenu(menu(i),'Label','2 webcams Agulhari''s camera sobreposition','CallBack','VODCA_5300_agulhari;'); %ok
% uimenu(menu(i),'Label','triangulate face-detector using 2 webcams','CallBack','VODCA_5400_faceposition');
% uimenu(menu(i),'Label','2 webcams and daqmx','CallBack','VODCA_5400_movie_using_2webcams_daqmx;'); %ok

i=i+1;
%% 6 - Image procccess Menu
menu(i) = uimenu(gcf,'Label','Image Proccess','Accelerator','P');
%submenu File
uimenu(menu(i),'Label','Parameters by DIC with 2 webcams','CallBack','VODCA_6200_stereo_parameters;'); %ok
uimenu(menu(i),'Label','Image process by DIC with 2 webcams','CallBack','VODCA_6300_stereo_imgprocess;');%ok

i=i+1;
%% 7 - Plot Menu
menu(i) = uimenu(gcf,'Label','Plot','Accelerator','P');

% uimenu(menu(i),'Label','1 webcam','CallBack','VODCA_7100_;');
uimenu(menu(i),'Label','Plot image process by DIC with 2 webcam in acceleration','CallBack','VODCA_7200_plot2webcams;'); %ok
uimenu(menu(i),'Label','Compare plot with Signal Calc Ace in acceleration','CallBack','VODCA_7300_compareplot2webcams;'); 
uimenu(menu(i),'Label','Plot image process by DIC with 2 webcam in displacement','CallBack','VODCA_7400_plot_disp2webcams;'); %ok

i=i+1;
%% 8 - Measure  Menu
% menu(i) = uimenu(gcf,'Label','Measure','Accelerator','P');
%
% uimenu(menu(i),'Label','Measure 2D 1 webcam','CallBack','VODCA_8100_;');
%
% i=i+1;

%% 8 - Export  Menu
% menu(i) = uimenu(gcf,'Label','Export','Accelerator','P');
%
% uimenu(menu(i),'Label','Displacements','CallBack','VODCA_8100_;');
% uimenu(menu(i),'Label','Graphs','CallBack','VODCA_8200_;;');
%
% i=i+1;

% %% 9 - Help Menu
% menu(i) = uimenu(gcf,'Label','Help','Accelerator','P');
%
% uimenu(menu(i),'Label','About','CallBack','VODCA_9100_;');
