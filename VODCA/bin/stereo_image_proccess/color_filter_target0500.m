% FUNCTION COLOR FILTER IN THE TARGET
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%15 novembro 2017

function [color_pick,color_filter,sens_filtro]=color_filter_target0500(crop_target,sens_filtro,color_pick,name_objects)
loop=0;
while loop==0
    
    input_color_option = questdlg(['in camera ' name_objects ' do you want input color by  '],'Select input color method',...
        'pick','input','square','pick');
    % Handle response
    switch input_color_option
        case 'pick'       
            [color_pick,sens_filtro]=pick_color0502(crop_target);
        case 'input'
            dlg_title = 'Input a value for this parameters';
            prompt = {'color red','color green ','color blue','red sensibility','green sensibility','Blue sensibility'};
            num_lines = 1;
            defaultans = {num2str(color_pick(1)),num2str(color_pick(2)),num2str(color_pick(3)),num2str(sens_filtro(1)),num2str(sens_filtro(2)),num2str(sens_filtro(3))};
            N=50; %this will control the width of the inputdlg
            answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
            %
            color_pick(1)=str2num(answer{1});
            color_pick(2)=str2num(answer{2});
            color_pick(3)=str2num(answer{3});
            sens_filtro=[str2num(answer{4}) str2num(answer{5}) str2num(answer{6})];
            
        case 'square'
            
            %%
            [color_pick,sens_filtro]=pick_sqr_color0503(crop_target);
    end
    %%
    [color_filter_high,color_filter_low,color_filter]=color_filter_dynamic0501(color_pick,sens_filtro,crop_target);
    
    gcf=figure
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    subplot(2,2,1);
    imshow(crop_target);
    title('\fontsize{20} Alvo');
    subplot(2,2,2);
    imshow(color_filter_high);
    title(['\fontsize{20} Color Picked R' num2str(color_pick(1)) '  G' num2str(color_pick(2)) '  B' num2str(color_pick(3))]);
    subplot(2,2,3);
    imshow(color_filter_low);
    title(['\fontsize{20} White Color ']);
    subplot(2,2,4);
    imshow (color_filter);
    title(['\fontsize{20} Subtract White Color from Color Picked']);
    
    answer_loop = questdlg('Did the application using color filter is work?','Do you want continue?',...
        'yes','no','yes');
    % Handle response
    switch answer_loop
        case 'yes'
            loop = 1;
            close all force
        case 'no'
            loop = 0;
            
    end
end

end