% FUNCTION PICK COLOR
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%17 novembro 2017

function [color_pick,sens_filtro]=pick_color0502(crop_target)
 
    prompt = {'Red Sensitivity ','Green Sensitivity ','Blue Sensitivity '};
    dlg_title = 'Insert a value to filters in the target between 5 (to black) and 50 (to white)';
    num_lines = 3;
    defaultans = [{'25'}, {'25'},{'25'}];
    N=10; %this will control the width of the inputdlg
    answer=inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    sens_filtro=[str2num(answer{1}), str2num(answer{2}), str2num(answer{3})];
    close all
    gcf=figure
    imshow(crop_target);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    title('\fontsize{16}Please Click in one point of the {\fontsize{20}\color{blue}TARGET} to Pick Color' );
    
    [pick_y,pick_x] = ginput(1);
    pick_x=round(pick_x);
    pick_y=round(pick_y);
    r_pick=crop_target(pick_x,pick_y,1);
    g_pick=crop_target(pick_x,pick_y,2);
    b_pick=crop_target(pick_x,pick_y,3);
    color_pick=[r_pick g_pick b_pick];
end