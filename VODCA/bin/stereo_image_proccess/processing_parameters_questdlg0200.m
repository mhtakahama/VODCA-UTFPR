%FUNCTION PARAMETER FOR IMAGE PROCESSING
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [fi,ff]=processing_parameters_questdlg0200(frames_total,shuttleVideo1,shuttleVideo2)

loop=0;
while loop==0
    prompt = {'Initial Frame to analyze',['Final frame number to analyze in max ' num2str(frames_total)]};
    dlg_title = 'Vídeo paramaters';
    num_lines = 1;
    defaultans = {'1', num2str(frames_total-1)};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    
    fi=str2num(answer{1});% initial time to processing frames
    ff=str2num(answer{2});%tempo final do processamento de imagens

    %plot frame initial
    gcf=figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize window plot
    data_fi=read(shuttleVideo1,fi); %pegar o frame determinado do video
    subplot(2,2,1);
    imshow(data_fi);
    title(['\fontsize{16} Frame ' num2str(fi) ' Initial from left camera ']);
        
    %plot frame final
    data_ff=read(shuttleVideo1,ff); %pegar o frame determinado do video
    subplot(2,2,3);
    imshow(data_ff);
    title(['\fontsize{16} Frame ' num2str(ff) ' Final from left camera ' ]);
    
    %plot frame initial
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize window plot
    data_fi=read(shuttleVideo2,fi); %pegar o frame determinado do video
    subplot(2,2,2);
    imshow(data_fi);
    title(['\fontsize{16} Frame ' num2str(fi) ' Initial from right camera ']);
        
    %plot frame final
    data_ff=read(shuttleVideo2,ff); %pegar o frame determinado do video
    subplot(2,2,4);
    imshow(data_ff);
    title(['\fontsize{16} Frame ' num2str(ff) ' Final from right camera ']);
    %% check while
    answer_loop = questdlg(['Its OK this interval of frames?'],['The Frames interval'],...
        'yes','no','yes');
    % Handle response
    switch answer_loop
        case 'yes'
            loop = 1;
        case 'no'
            loop = 0;
    end
end

end