% FUNCTION Objects filter
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%15 novembro 2017

function [medfilt_option,bwareopen_option,imerode_option,imdilate_option,strel_option,filt4_target]=noise_filter_option0600(data_cut,color_filter,medfilt_option,bwareopen_option,imerode_option,imdilate_option,strel_option)
loop=0;
while loop==0
    
    prompt = {'medfilt2','bwareaopen ','imerode','imdilate','strel command form'};
    dlg_title = 'Small objects filters, rode and erode';
    num_lines = 1;
    defaultans = {num2str(medfilt_option),num2str(bwareopen_option),num2str(imerode_option),num2str(imdilate_option),strel_option};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    %
    medfilt_option=str2num(answer{1});
    bwareopen_option=str2num(answer{2});
%     lessthen_option=str2num(answer{3});
    imerode_option=str2num(answer{3});
    imdilate_option=str2num(answer{4});
    strel_option=answer{5};
    %noise filter application
    [filt1_target,filt2_target,filt3_target,filt4_target]=noise_filter0601(color_filter,medfilt_option,bwareopen_option,imerode_option,imdilate_option,strel_option);
    
%     [prev_centroids]=locate_centroids0602(filt4_target); % determine centroids
%     [centroids2]=locate_centroids0602(filt2_gage); % determine centroids

    %% plotagem das opções
    
    close all
    gcf=figure
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    
    hold on
    plt_n=1;
    subplot(3,2,plt_n)
    imshow (data_cut);
    title(['\fontsize{20} Original cut in the target']);
    
    
    hold on
    plt_n=plt_n+1;
    subplot(3,2,plt_n)
    imshow (filt1_target);
    title(['\fontsize{20} Medfilt2 level '  answer{1} ' in the target']);
%     
%     hold on
%     plt_n=plt_n+1;
%     subplot(4,1,plt_n)
%     imshow (filt1_gage);
%     title(['\fontsize{20} Medfilt2 level '  answer{1} ' in the gage']);
    
    hold on
    plt_n=plt_n+1;
    subplot(3,2,plt_n)
    imshow (filt2_target);
    title(['\fontsize{20} bwareaopen level '  answer{2} ' in the target']);
%     
%     hold on
%     plt_n=plt_n+1;
%     subplot(4,1,plt_n)
%     imshow (filt2_gage);
%     title(['\fontsize{20} bwareaopen level '  answer{3} '% in the gage']);
%     hold(imgca,'on')
%     plot(imgca,centroids2(:,1), centroids2(:,2), 'r*')%plot centroids gage
%     
    hold on
    plt_n=plt_n+1;
    subplot(3,2,plt_n)
    imshow (filt3_target);
    title(['\fontsize{20} imerode level '  answer{3} ' form: ' answer{5} ' in the target']);
    
    hold on
    plt_n=plt_n+1;
    subplot(3,2,plt_n)
    imshow (filt4_target);
    title(['\fontsize{20} imerode level '  answer{4} ' form: ' answer{5} ' in the target']);
%     hold(imgca,'on')
%     plot(imgca,prev_centroids(:,1), prev_centroids(:,2), 'b*')%plot centroids target
    %% loop
    answer_loop = questdlg('Did the filter application work?','Do you want continue?','sim','não','sim');
    % Handle response
    switch answer_loop
        case 'sim'
            loop = 1;
            close all force
        case 'nao'
            loop = 0;
    end
end