% FUNCTION CROP TARGET IN RECTANGLE
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [target_rectangle]=crop_target_questdlg0300(data,name_objects)

loop=0;
while loop==0
    close all
    gcf=figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize window plot
    imshow(data)
    title(['\fontsize{16}Please crop the target from camera ' name_objects ' picking 4 points' ]);
    
    for i=1:4
    [pick_y(i),pick_x(i)] = ginput(1); %pick 4 points in the window to square target
    pick_x(i)=round(pick_x(i));
    pick_y(i)=round(pick_y(i));
    if i>=2
    line([pick_y(i-1),pick_y(i)],[pick_x(i-1),pick_x(i)]);
    end
    end
    target_rectangle=[min(pick_y) min(pick_x) max(pick_y)-min(pick_y) max(pick_x)-min(pick_x)];
    
    %% plotagem
    crop_target = insertShape(data,'Rectangle',target_rectangle,...
        'Color', {'blue'},'Opacity',0.7);
    imshow(crop_target)
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize window plot
    title(['\fontsize{16}Accept selection of the target ?']);
    
    %% check while
    answer_loop = questdlg(['accept target cut?'],['The target cut'],...
        'yes','no','yes');
    % Handle response
    switch answer_loop
        case 'yes'
            loop = 1;
            close all
        case 'no'
            loop = 0;
     end
end

end