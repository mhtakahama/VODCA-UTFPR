% FUNCTION Pick in square color
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%15 novembro 2017

function [color_pick,sens_filtro]=pick_sqr_color0503(crop_target)
close all
gcf=figure
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize window plot
imshow(crop_target)
title(['\fontsize{16}Please select the colors picking 4 points' ]);

for i=1:4
    [pick_y(i),pick_x(i)] = ginput(1); %pick 4 points in the window to square target
    pick_x(i)=round(pick_x(i));
    pick_y(i)=round(pick_y(i));
    if i>=2
        line([pick_y(i-1),pick_y(i)],[pick_x(i-1),pick_x(i)]);
    end
end
target_rectangle=[min(pick_y) min(pick_x) max(pick_y)-min(pick_y) max(pick_x)-min(pick_x)];
crop_color=imcrop(crop_target,target_rectangle);
max_colors=[max(max(crop_color(:,:,1))) max(max(crop_color(:,:,2))) max(max((crop_color(:,:,3))))];
min_colors=[min(min(crop_color(:,:,1))) min(min(crop_color(:,:,2))) min(min(crop_color(:,:,3)))];
mean_color=[mean(mean(crop_color(:,:,1))) mean(mean(crop_color(:,:,2))) mean(mean((crop_color(:,:,3))))];
sens_filtro=[std2(crop_color(:,:,1)) std2(crop_color(:,:,2)) std2((crop_color(:,:,3)))];

dlg_title = 'Do you want this parameters?';
prompt = {'color red','color green ','color blue','red sensibility','green sensibility','Blue sensibility'};
num_lines = 1;
defaultans = {num2str(mean_color(1)),num2str(mean_color(2)),num2str(mean_color(3)),num2str(sens_filtro(1)),num2str(sens_filtro(2)),num2str(sens_filtro(3))};
N=50; %this will control the width of the inputdlg
answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);

color_pick(1)=str2num(answer{1});
color_pick(2)=str2num(answer{2});
color_pick(3)=str2num(answer{3});
sens_filtro=[str2num(answer{4}) str2num(answer{5}) str2num(answer{6})];
end
