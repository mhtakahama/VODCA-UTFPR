close all force; 
clear all; clc; format long
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITM TO FIND DISPLACEMENT 3D IN THE TIME FOR N TARGETs
%USING A CAMERA THOUGHT OF THE IMAGE PROCESSING
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paran� (UTFPR)
%Campus Corn�lio Proc�pio
%Laborat�rio Tecnol�gico de Vibra��es Mec�nicas e Manunten��o
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
%% Para este algoritmo � necess�rio os arquivos:
% Stereoparams.mat (Calibra��o das cameras)
% tempo.mat        (vetor tempo da grava��o)
% direita.avi      (grava��o da camera esquerda) suporta outros formatos
% esquerda.avi     (grava��o da camera direita)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function []=VODCA_7200_plot2webcams()

%1.2 Select Stereo Camera Calibration
[name_file,PATH,job]=pick_file0101('Select the results' , '*.mat');
load([PATH '\' job]) %load stereo parameters for webcam
addpath(PATH);

[name_file,PATH,job]=pick_file0101('Select the tempo' , '*.mat');
load([PATH '\' job]) %load stereo parameters for webcam
addpath(PATH);

clear job PATH name_file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tratamento do sinal e plot
plot_number=0; %controle para identificar o numero do plot

tempo=tempo(fi:ff); % Uniformly-Sampled Time Vector
tempo=tempo-tempo(1); % Uniformly-Sampled Time Vector

%plot original signal
% for i=1:N
%     art=1;%corte de dados no deslocamento se necessario
%     gcf=figure;
%     plot_number=plot_number+1;
%     set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
%     set(gcf,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
%     graph_plot=plot(tempo(art:length(tempo)),point3d(art:length(tempo),i));
%     grid on
%     title(['Target eixo ' {i} '  displacement x time original signal']);
%     xlabel('time(s)')
%     ylabel('displacement (mm)')
% end

%% Find FFT of a non-uniformly sampled data

%Euclidean
for i=1:L
    point3d(i,N+1)=norm(point3d(i,:));
end

[desl]=normaliza_coluna_0102(point3d);



%plot do sinal normalizado
% for i=1:N+1
%     art=1;%corte de dados no deslocamento se necessario
%     gcf=figure;
%     plot_number=plot_number+1;
%     set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
%     set(gcf,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
%     graph_plot=plot(tempo(art:length(tempo)),desl(art:length(tempo),i));
%     grid on
%     title(['Target eixo ' {i} '  displacement x time norm signal']);
%     xlabel('time(s)')
%     ylabel('displacement (mm)')
% end

tr = linspace(min(tempo), max(tempo), length(tempo)); 
tr=tr-tr(1); % Uniformly-Sampled Time Vector
Ts = mean(diff(tr));                                        % Sampling Interval
Fs = 1/Ts;                                                  % Sampling Frequency
Fn = Fs/2;                                                  % Nyquist Frequency
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                         % Frequency Vector


for i=1:N+1
[vr(:,i)] = resample(desl(:,i), tempo,Fs);% Resampled Signal Vector
end

%%
%plot do sinal recondicionado
for i=1:N+1
    art=1;%corte de dados no deslocamento se necessario
    gcf=figure;
    plot_number=plot_number+1;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    set(gcf,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
    graph_plot=plot(tempo(art:length(desl)),desl(art:length(desl),i));
    hold on
    graph_plot=plot(tr(art:length(vr)),vr(art:length(vr),i)); %sinal interpolado
    grid on
    title(['Axis ' {i} '  acceleration x time recondicional signal']);
    xlabel('time(s)')
    ylabel('displacement (mm)')
    legend('Sinal original','Sinal Interpolado')
end

for i=1:N+1 %FFT for every signal
    FTvr(:,i)=Fast_fourier1001(vr(:,i),L);
end

for i=1:N+1
    art=1;%corte de dados no deslocamento se necessario
    gcf=figure;
    plot_number=plot_number+1;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    set(gcf,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
    plot(Fv(art:length(Fv)), abs(FTvr((art:length(Fv)),i)));
    grid on
    title(['Axis ' {i} '  Frequency Spectrum recondicional signal']);
    xlabel('frequency(Hz)')
    ylabel('acceleration (mm)')
end

%% Separa��o dos par�metros e FFT

for i=1:N+1
    %% Filtro Butterworth
    art=1;%corte de dados no deslocamento
    %
    order=3;
    %Low pass
    % [bf,af]=butter(6,fc/(fs/2));
    % freqz(bf,af);
    %High pass
    [bf af]=butter(order,[1/(max(tr)) 0.9], 'bandpass');
    figure
    freqz(bf,af)

%     [bf af]=butter(order,[3 10]/Fn, 'bandpass');
    fvtool(bf,af);%Ver filtro projetado
    %
    dataIn(:,i)=vr(:,i); 
    desl_butter(:,i)=filtfilt(bf,af,dataIn(:,i));
    %% Janelamento
    np=length(tr)-1;
   
%     exp_jan_order=10;
%     for j=1:np %janelamento exponencial
%         jan(j) = exp(-j/(exp_jan_order*Fs));
%     end
    %     jan=1; %retangular
                  jan=hanning(np); %janelamento hanning
    %           jan = triang(np);
    %               jan = hamming(np);
    %                   jan=kaiser(np,2.5);
    %                       jan=tukeywin(np,0.1); %janelamento tukey
    
    gcf=figure;
    plot_number=plot_number+1;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    set(gcf,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
    graph_plot=plot(jan*max(desl_butter(:,i)));
    hold on
    graph_plot=plot(desl_butter(art:length(desl_butter),i));
    grid on
    title(['Window kind in signal ' {i}]);
    xlabel('Point')
    ylabel('Amplitude')
  
    desl_jan(:,i)=jan.*desl_butter(1:end-1,i);
    
    % Plot filtro de sinal e janelamento
    gcf=figure;
    plot_number=plot_number+1;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    set(gcf,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
    graph_plot=plot(tempo(art:length(desl)),desl(art:length(desl),i));
    hold on
    graph_plot=plot(tr(art:length(vr)),vr(art:length(vr),i)); %sinal interpolado
    hold on
    graph_plot=plot(tr(art:length(desl_butter)),desl_butter(art:length(desl_butter),i));
    hold on
    graph_plot=plot(tr(art:length(desl_jan)),desl_jan(art:length(desl_jan),i));
    grid on
    title(['Axis ' {i} '  displacement x time']);
    xlabel('time(s)')
    ylabel('acceleration (mm)')
    legend('Sinal original','Sinal Interpolado','Sinal Filtrado','Sinal janelado')
    %
    %% FFT Janelada
    [FTdesl_jan(:,i)]=Fast_fourier1001(desl_jan(:,i),L);
    %% Plotagem dos resultados
    gcf2=figure;
    plot_number=plot_number+1;
    set(gcf2, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
    set(gcf2,'Name',['Plot number ' num2str(plot_number)],'NumberTitle','off');
    subplot (3,1,1)
    %     graph_plot=plot(t(art:length(t)),Y(art:length(Y),i));
    graph_plot=plot(tr(art:length(desl_jan)),desl_jan(art:length(desl_jan),i));
    grid on
    hold on
    title(['Axis ' {i} '  displacement x time']);
    xlabel('time(s)')
    ylabel('acceleration (mm)')
    
    subplot (3,1,2);
    %     graph_plot=plot(f(art:(length(f)-1)),abs(Y2(art:(ceil(length(Y2)/2)),i))*cp);
    graph_plot=plot(Fv(art:(length(FTdesl_jan))),abs(FTdesl_jan(:,i)));
    grid on
    hold on
    title('Frequency Spectrum')
    xlabel('frequency(Hz)')
    ylabel('acceleration (mm)')
    
    subplot (3,1,3);
    %     graph_plot=plot(f(art:(length(f)-1)),abs(Y2(art:(ceil(length(Y2)/2)),i))*cp);
    graph_plot=plot(Fv(art:(length(FTdesl_jan))),20*log10(abs(FTdesl_jan(:,i))));
    grid on
    title('Frequency Spectrum')
    xlabel('frequency(Hz)')
    ylabel('acceleration (dB mm)')
end
% end
warndlg(sprintf(' Tudo pronto '));

