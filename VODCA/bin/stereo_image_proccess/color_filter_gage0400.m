% FUNCTION COLOR FILTER IN THE GAGE OPTION
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [gage_filter,gage_bin1,gage_bin2]=color_filter_gage0400(crop_gage1,crop_gage2)

close all
gcf=figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize window plot

loop=0;
while loop==0
    subplot(2,2,1);
    imshow(crop_gage1);
    title('Gage Block in left camera')
    
    hold on
    subplot(2,2,2)
    imshow(crop_gage2)
    title('Gage Block in right camera')
    
    %% 4.1 - Histograma da densidade de cores do bloco padrão
    colorRGB={'Red','Green','Blue'};
    for i=1:length(colorRGB)
        hold on
        subplot(2,2,3); %densidade de cada cor
        [ycolor, pick_x] = imhist(crop_gage1(:,:,i));
        plot(pick_x, ycolor,'color',colorRGB{i});
    end
        xlim([100 255]);
        title('Graph of quantity of color ')
        xlabel('Color Intensity')
        ylabel('Density of points')
        
    for i=1:length(colorRGB)
        hold on
        subplot(2,2,4); %densidade de cada cor
        [ycolor, pick_x] = imhist(crop_gage2(:,:,i));
        plot(pick_x, ycolor,'color',colorRGB{i});
    end
        xlim([100 255]);
        title('Graph of quantity of color ')
        xlabel('Color Intensity')
        ylabel('Density of points')
    
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    % set filter of the gage
    prompt = {'R left','G left ','B left','R right','G right','B right'};
    dlg_title = 'Color filter intensity for gage block';
    num_lines = 1;
    defaultans = {'205','205','205','205','205','205'};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    gage_filter(1,:)=[str2num(answer{1}) str2num(answer{2}) str2num(answer{3})]; %intensity of filter color of the gage
    gage_filter(2,:)=[str2num(answer{4}) str2num(answer{5}) str2num(answer{6})]; %intensity of filter color of the gage

    [gage_bin1]=gage_filter0401(crop_gage1,gage_filter(1,:));    
    [gage_bin2]=gage_filter0401(crop_gage2,gage_filter(2,:));    
    gcf=figure;
    title(['\fontsize{20} Color filter R' answer{1} '  G' answer{2} '  B' answer{3}]);
    subplot(1,2,1); 
    imshow(gage_bin1);
    title('Left camera gage binarized');
    subplot(1,2,2); 
    imshow(gage_bin2);
    title('Right camera gage binarized');
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    
    answer_loop = questdlg('Did the application of the filter is work?','Do you want continue?',...
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