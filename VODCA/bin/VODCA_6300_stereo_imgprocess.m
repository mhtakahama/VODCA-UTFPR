% close all force; clear all;
clear all; clc; format long; echo off
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITM TO FIND DISPLACEMENT 3D IN THE TIME FOR N TARGETs
%USING A CAMERA THOUGHT OF THE IMAGE PROCESSING
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paraná (UTFPR) - Brazil
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
%Professor: Adailton Silva Borges
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
% function []=VODCA_6300_stereo_imgprocess()
global status j point3d barra interface PATH_camera1 PATH_camera2

[name_file,PATH,job]=pick_file0101('Select parameters','*.mat');
load([PATH '\' job]) %load stereo parameters for webcam
addpath(PATH);

%
% shuttleVideo1 = VideoReader([PATH_camera1 '\' vid_name1]);%Leitura do arquivo
% shuttleVideo2 = VideoReader([PATH_camera2 '\' vid_name2]);%Leitura do arquivo
%1.1 Select Videos
[name_file,PATH_camera1,vid_name1]=pick_file0101('Select the video from left camera','*.avi');
shuttleVideo1 = VideoReader([PATH_camera1 vid_name1]);%Leitura do arquivo
addpath(PATH_camera1);

[name_file,PATH_camera2,vid_name2]=pick_file0101('Select the video from right camera','*.avi');
shuttleVideo2 = VideoReader([PATH_camera2 vid_name2])%Leitura do arquivo
addpath(PATH_camera2);;

frames_total(1)=ceil(shuttleVideo1.duration*shuttleVideo1.FrameRate);
frames_total(2)=ceil(shuttleVideo2.duration*shuttleVideo2.FrameRate);

if frames_total(1)==frames_total(2)
    warndlg(sprintf('The videos are loaded \n'));
else
    warndlg(sprintf('The videos are not loaded because are difference between the numbers of frames\n'));
    return
end
%% 1 - Interface for image processing
tempo_inicial= datestr(now,'HH:MM:SS.FFF');

% close all force;
interface=figure;
interface=set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
interface=set(gcf,'Name',['Initial Time' num2str(tempo_inicial)],'NumberTitle','off');
% barra=waitbar(0,'PROCESSING...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% setappdata(barra,'canceling',0);

j=0;  %start frame count
%% 1.1 - Visual interface for target and image processing
tic;
for i=fi:1:ff%shuttleVideo.NumberOfFrames
    %%Call windows status
    %     if getappdata(barra,'canceling')
    %         break;
    %     end
    j=j+1;
    
    if rem(j,20)==0 % clear plot each 20 frames to free memory ram
        clf('reset')
    end
    %% 7 - Loop check if no targets have been lost
    chk_target=0;
    while chk_target==0
        %%  2 - normal image in the plot 1
        data1=read(shuttleVideo1,i); %pegar o frame determinado do video
        data2=read(shuttleVideo2,i); %pegar o frame determinado do video
        
        data1=undistortImage(data1,stereoParams.CameraParameters1);%%%Retirar distorções da imagem (Através da calibração)
        data2=undistortImage(data2,stereoParams.CameraParameters2);%%%Retirar distorções da imagem (Através da calibração)
        
        %% 4 - Color filter in the plot 4
        %alvo
        [~,~,target_bin1]=color_filter_dynamic0501(color_pick(1,:),sens_filtro(1,:),data1);
        [~,~,target_bin2]=color_filter_dynamic0501(color_pick(2,:),sens_filtro(2,:),data2);
        
        %%      Dummy to cut and keep the command triangulate in the full image
        
        dummy_cut1=imcrop(target_bin1,target_rectangle(1,:));%especifica o retangulo de corte[Xmin Ymin Width(L) Height(A)]
        dummy_cut2=imcrop(target_bin2,target_rectangle(2,:));%especifica o retangulo de corte[Xmin Ymin Width(L) Height(A)]
        data1_cut=imcrop(data1,target_rectangle(1,:));%especifica o retangulo de corte[Xmin Ymin Width(L) Height(A)]
        data2_cut=imcrop(data2,target_rectangle(2,:));%especifica o retangulo de corte[Xmin Ymin Width(L) Height(A)]
        
        target_bin1=target_bin1*0;
        target_bin2=target_bin2*0;

        for k=1:(target_rectangle(1,3))
            for l=1:(target_rectangle(1,4))
                target_bin1(target_rectangle(1,2)+l-1,target_rectangle(1,1)+k)=dummy_cut1(l,k);
            end
        end
        
        for k=1:(target_rectangle(2,3))
            for l=1:(target_rectangle(2,4))
                target_bin2(target_rectangle(2,2)+l-1,target_rectangle(2,1)+k)=dummy_cut2(l,k);
            end
        end
        %% 5 - small objects filter, erode and rode process in the image
        
        [~,~,~,filt4_target1]=noise_filter0601(target_bin1,medfilt_option(1),bwareopen_option(1),imerode_option(1),imdilate_option(1),strel_option{1});
        [~,~,~,filt4_target2]=noise_filter0601(target_bin2,medfilt_option(2),bwareopen_option(2),imerode_option(2),imdilate_option(2),strel_option{2});
        
        %% 7 - Check if no targets have been lost
        index_areas1=bwlabel(filt4_target1); %index areas from target
        index_areas2=bwlabel(filt4_target2); %index areas from target
        chk_target_count1=max(index_areas1(:)); % count the numbers of targets actual
        chk_target_count2=max(index_areas2(:)); % count the numbers of targets actual
        
        if chk_target_count1==target_count1 && chk_target_count2==target_count2
            chk_target=1;
        else
            warndlg(sprintf('Detected Right %s targets and Left %s targets  \n',num2str(chk_target_count1),num2str(chk_target_count2)));
            [medfilt_option(1),bwareopen_option(1),imerode_option(1),imdilate_option(1),strel_option{1},~]=noise_filter_option0600(data1_cut,dummy_cut1,medfilt_option(1),bwareopen_option(1),imerode_option(1),imdilate_option(1),strel_option{1}); %set parameters for the noise filter
            [medfilt_option(2),bwareopen_option(2),imerode_option(2),imdilate_option(2),strel_option{2},~]=noise_filter_option0600(data1_cut,dummy_cut2,medfilt_option(2),bwareopen_option(2),imerode_option(2),imdilate_option(2),strel_option{2}); %set parameters for the noise filter
            chk_target=0;
            
            close all force
            gcf=figure;
            set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
            %             barra=waitbar(0,'PROCESSING...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            %             setappdata(barra,'canceling',0);
        end
    end
    %% 6.1 Locate centroids
    [centroids1,points1]=locate_centroids0602(filt4_target1);
    [centroids2,points2]=locate_centroids0602(filt4_target2);
    
    %% 6.2 Index centroids based in the previous binary image
    [centroids1,n_index1]=organize_centroids0603(centroids1,filt4_target1,prev_centroids1); %Function to locazile the targets based in the previous centroids in actual frame
    centroids_index1(j,:)=n_index1;
    
    for m = 1:points1       %%%% Storage the targets
        X1(j,m)=centroids1(m,1);
        Y1(j,m)=centroids1(m,2);
    end
    prev_centroids1=centroids1; %storage the previous centroids to index the point correctly
    
    [centroids2,n_index2]=organize_centroids0603(centroids2,filt4_target2,prev_centroids2); %Function to locazile the targets based in the previous centroids in actual frame
    centroids_index2(j,:)=n_index2;
    
    for m = 1:points2       %%%% Storage the targets
        X2(j,m)=centroids2(m,1);
        Y2(j,m)=centroids2(m,2);
    end
    prev_centroids1=centroids2; %storage the previous centroids to index the point correctly
    
    %% Calculate depth distance in pixels and plots 1 and 2
    
    point3d(j,:) = triangulate([centroids1(1,1) centroids1(1,2)],[centroids2(1,1) centroids2(1,2)], stereoParams);
    distanceInpixel(j) = norm(point3d(j,:));
    distanceAsString = sprintf('%0.2f milimeters', distanceInpixel(j));
    I1 = insertObjectAnnotation(data1,'rectangle',target_rectangle(1,:),distanceAsString,'FontSize',50);
    I2 = insertObjectAnnotation(data2,'rectangle',target_rectangle(2,:), distanceAsString,'FontSize',50);
    I1 = insertShape(I1,'FilledRectangle',target_rectangle(1,:));
    I2 = insertShape(I2,'FilledRectangle',target_rectangle(2,:));
    hold on, subplot(3,4,1);imshow(I1);title(['\fontsize{16} Frame ' num2str(i) ' in left camera']); %actual frame from total
    hold on, subplot(3,4,2);imshow(I2);title(['\fontsize{16} Frame ' num2str(i) ' in right camera']); %actual frame from total
    
    %% 6.1 - Target with centroid in the plot 5 and 6
    
    zoom_data1_cut=imcrop(filt4_target1,target_rectangle(1,:));%especifica o retangulo de corte[Xmin Ymin Width(L) Height(A)]
    zooom_data2_cut=imcrop(filt4_target2,target_rectangle(2,:));%especifica o retangulo de corte[Xmin Ymin Width(L) Height(A)]
    
    %     distanceAsString = sprintf('%0.2f X, %0.2f Y, %0.2f Z, Distance', point3d(j,1), point3d(j,2), point3d(j,3));
    %     I1 = insertObjectAnnotation(uint8(filt4_target1),'rectangle', target_rectangle(1,:),distanceAsString,'FontSize',25);
    %     I2 = insertObjectAnnotation(uint8(filt4_target2),'rectangle',target_rectangle(2,:), distanceAsString,'FontSize',25);
    %      hold on, subplot(2,2,3); imshow(I1); title(['\fontsize{20} Target Processed in left camera']);
    %     hold(imgca,'on')
    hold on, subplot(2,2,3); imshow(zoom_data1_cut); title(['\fontsize{20} Target Processed in left camera']);
    hold(imgca,'on')
    %     plot(imgca,centroids1(:,1), centroids1(:,2), 'b*')%plot centroid target
    %     hold on, subplot(2,2,4); imshow(I2); title(['\fontsize{20} Target Processed in right camera']);
    %     hold(imgca,'on')
    hold on, subplot(2,2,4); imshow(zooom_data2_cut); title(['\fontsize{20} Target Processed in right camera']);
    hold(imgca,'on')
    %     plot(imgca,centroids2(:,1), centroids2(:,2), 'b*')%plot centroid target
    
    %% 6.2 - Gage with centroid in the plot 3 and 4
    
    subplot(3,4,3); imshow (data1_cut); title(['\fontsize{20} Target Processed in left camera']);
    %     [centroids1]=locate_centroids0602(filt2_gage1);
    %     hold(imgca,'on')
    %     plot(imgca,centroids1(:,1), centroids1(:,2), 'r*')%plot centroid for gage
    %     gage_area1(j)=bwarea(filt2_gage1);%area calc for gage
    
    subplot(3,4,4); imshow (data2_cut); title(['\fontsize{20} Target Processed in right camera']);
    %     [centroids2]=locate_centroids0602(filt2_gage2);
    %     hold(imgca,'on')
    %     plot(imgca,centroids2(:,1), centroids2(:,2), 'r*')%plot centroid for gage
    %     gage_area2(j)=bwarea(filt2_gage2);%area calc for gage
    
%     saveas(gcf,[PATH_camera1  paste_name '_frame_' num2str(i) '.jpg']) %
%     salva frame processado

    %% janela de progresso
    status= (j-1)/(ff-fi)*100;%shuttleVideo.NumberOfFrames*100;
    %     barra=waitbar((j-1)/(ff-fi),barra,sprintf('Progress: %2.1f%%',status));
    interface=set(gcf,'Name',['Time elapsed ' num2str(toc/60) ' minutes and Progress are: ' num2str(status) '%'],'NumberTitle','off');
end
% delete (barra)
% delete shuttleVideo1 shuttleVideo2 I1 I1 data1 data2 gage_bin1 gage_bin2 index_areas1 index_areas2 target_bin1 target_bin2
%% Conversão de unidades
[L,N]=size(point3d);

%% Save bkp
mkdir([PATH_camera1 '\' paste_name]);
save([PATH_camera1  paste_name '\results.mat']);% save a backup for results
save([PATH_camera1  paste_name '\parameters.txt'], 'color_pick', 'sens_filtro', 'medfilt_option', 'bwareopen_option', 'imerode_option', 'imdilate_option', '-ascii')
warndlg(sprintf(' Tudo pronto '));

% end

