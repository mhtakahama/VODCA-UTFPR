%Use os comandos para parar as cams:
% stop(cam_right); delete(cam_right); stop(cam_left); delete(cam_left)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITMO para sobreposição de sinal pelo metodo de Agulhari
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paraná (UTFPR)
%Campus Cornélio Procópio
%Laboratório Tecnológico de Vibrações Mecânicas
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
%Professor: Adailton Silva Borges, Cristiano Marcos Agulhari
%contributions for the elaboration of this algorithm: José Eduardo Simão 2017 (atual) ,Marcos Hiroshi Takahama 2017 (atual)
%07/02/2017
% function []=VODCA_5100_movie_using_1webcam()
% global answer
close all; clear all;clc
%% 0 Propriedades de aquisição da webcam
%informações do driver
caminf  = imaqhwinfo;
mycam = char(caminf.InstalledAdaptors()); %mostra os drivers instalados onde deve aparecer o 'winvideo'
%armazena resoluções da webcam
cam_number=webcamlist; %enumera webcams disponíveis

% informação de cada cam
for i=1:length(cam_number)
vid(i) = imaqhwinfo('winvideo', i);
end
% resolução de cada cam

for i=1:length(cam_number) %matlab cannot support increase the length of matrix in a for loop
    dummy=vid(i).SupportedFormats;
    for j=1:length(dummy)
        cam_resolution(i,j)=dummy(1,j);
    end
end

%%2- Propriedades do arquivo de vídeo salvo
paste_name= datestr(now,'yyyymmddTHHMMSS');
mkdir(['movie\2webcams_agm\' paste_name]);
Vid_odd = VideoWriter(['movie\2webcams_agm\' paste_name '\' 'odd_video.avi'],'Uncompressed AVI');
Vid_even = VideoWriter(['movie\2webcams_agm\' paste_name '\' 'even_video.avi'],'Uncompressed AVI');

tic;
delay_response=toc;
% pause_time=1/60-delay_response;
%% 2 - set properties from image aquisition
loop=0;
while loop==0
    
    %% configurações de filmagem
    
    position={'northwest' 'northeast' 'southeast' 'southwest'};
    for i=1:length(cam_number)
        barra(i)=warndlg(sprintf(' %s \n', cam_resolution{i,:}), ['Cam' num2str(i) 'Resolutions']);
        movegui(barra(i),position{rem(i,4)});
    end
    
    barra_cam_inst=warndlg(sprintf(' %s \n', cam_number{:} ),'Cams in install order');
    movegui(barra_cam_inst,'north')
    
    %input parameters
    prompt = {'Number cam left','Number cam right','Resolution','Max Time out','ReturnedColorSpace','FrameGrabInterval','max Frames in the trigger','Total Frames to analyze','Focus left','Focus right','Exposure left','Exposure right'};
    %     prompt = {'Resolution','Gain','Saturation','White Balance','Sharpness','Brightness','BacklightCompesation','Contrast'};
    dlg_title = 'Configuração de vídeo (Time = Frames to analyze/30)';
    num_lines = 1;
    defaultans = {'1','2','MJPG_640x480','Inf','rgb','1','2001','500','0','0','-7','-7'};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    %input
    close all force
    
    cam_odd = videoinput('winvideo', str2num(answer{1}), answer{3});
    cam_even = videoinput('winvideo', str2num(answer{2}), answer{3});
    src1 = getselectedsource(cam_odd);
    src2 = getselectedsource(cam_even);
    src1.FocusMode = 'auto';
    src2.FocusMode = 'auto'  ;
    src1.FocusMode = 'manual';
    src2.FocusMode = 'manual';
    src1.Focus = str2num(answer{9});
    src2.Focus = str2num(answer{10});
    src1.ExposureMode = 'auto';
    src2.ExposureMode = 'auto'  ;
    src1.ExposureMode = 'manual';
    src2.ExposureMode = 'manual';
    src1.Exposure = str2num(answer{11});
    src2.Exposure = str2num(answer{12});
    
    res = regexp(answer{3},'\d*','Match');
    
    set(cam_odd,'Timeout',str2num(answer{4}));
    set(cam_even,'Timeout',str2num(answer{4}));
    
    % Set video input object properties for this application.
    
    set(cam_odd,'ReturnedColorSpace',answer{5});   
    set(cam_even,'ReturnedColorSpace',answer{5});
    
    set(cam_odd,'FrameGrabInterval',str2num(answer{6}));
    set(cam_even,'FrameGrabInterval',str2num(answer{6}));
     
    set(cam_odd,'FramesPerTrigger', str2num(answer{7}));
    set(cam_even,'FramesPerTrigger', str2num(answer{7}));
    %% preview das cameras
    prev_left=preview(cam_odd);
    movegui(prev_left,'northwest')
    
    prev_right=preview(cam_even);
    movegui(prev_right,'northeast')

    %% check while
    answer_loop = questdlg('Aceitar qualidade da imagem?','Configurações',...
        'sim','não','sim');
    % Handle response
    if answer_loop=='sim'
        
        answer_preview= questdlg('Ver preview durante aquisição? (taxa de quadros cai em 4x)','preview',...
            'sim','não','não');
        if answer_preview=='sim'
            loop = 1;
        else
            close all force
            loop = 1;
        end
    else
        stop(cam_even)
        delete(cam_even)
        stop(cam_odd)
        delete(cam_odd)
        close all force
        loop = 0;
    end
end

%alocate size memory for the movie
data=zeros(str2num(res{2}),str2num(res{1}),3,str2num(answer{8}),'uint8');

%%3- Start acquiring frames.
start([cam_odd cam_even]);

i=0;
tic
while(i<str2num(answer{8}))  % Stop after i frames
    i=i+1;
    tempo(i)=toc;data(:,:,:,i) = [getdata(cam_odd,1)];
    flushdata(cam_odd);% limpa o cache das cameras do ultimo frame
%     pause(pause_time)
    i=i+1;
    tempo(i)=toc;data(:,:,:,i) = [getdata(cam_even,1)];
    flushdata(cam_even); 
end
%% Parar Webcams
stop(cam_even)
delete(cam_even)
stop(cam_odd)
delete(cam_odd)

cont=0;
for j=1:2:i
    cont=cont+1;
    M_odd(cont)=im2frame(data(:,1:str2num(res{1}),:,j));
    M_even(cont)=im2frame(data(:,1:str2num(res{1}),:,j+1));
end
%% 4 - parar as cams e plot de estatisticas
%salva vetor de tempo menos o delay de tempo de leitura da linha
tempo=tempo-delay_response;
tempo=tempo-min(tempo);
save(['movie\2webcams_agm\' paste_name '\' 'tempo.mat'],'tempo');

FPS_MEDIA=length(tempo)/tempo(end);
TEMPO_MAX=tempo(end);
warndlg(sprintf(' %s \n',FPS_MEDIA,'Media FPS'));
warndlg(sprintf(' %s \n',TEMPO_MAX,'Tempo de aquisição'));


%% 5 - Preview
loop=0;
while loop==0
    answer_loop = questdlg('DESEJA VER UM PREVIEW?','VISUALIZAR PREVIEW?',...
        'sim','não','sim');
    % Handle response
    if answer_loop=='sim'
        movie(M_odd);
        movie(M_even);
       loop = 1;
    else
        loop = 1;
    end
end

%% salva o video
loop=0;
while loop==0
    answer_loop = questdlg('SALVAR VIDEO AGORA?','DESEJA SALVAR?',...
        'sim','não','sim');
    % Handle response
    if answer_loop=='sim'
        open(Vid_even);
        writeVideo(Vid_even, M_even);
        close(Vid_even);
        open(Vid_odd);
        writeVideo(Vid_odd, M_odd);
        close(Vid_odd);
        loop = 1;
    else
        close all force
        loop = 1;
    end
end
% end
