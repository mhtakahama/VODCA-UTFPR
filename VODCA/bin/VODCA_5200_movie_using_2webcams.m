%Use os comandos para parar as cams:
% stop(cam_right); delete(cam_right); stop(cam_left); delete(cam_left)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITMO PARA VIDEOS USANDO 2 WEBCAMS
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
%Professor: Adailton Silva Borges
%contributions for the elaboration of this algorithm: José Eduardo Simão 2017 (atual) ,Marcos Hiroshi Takahama 2017 (atual)
%07/02/2017
% function []=VODCA_5100_movie_using_1webcam()
global answer
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
mkdir(['movie\2webcams\' paste_name]);
Vid_right = VideoWriter(['movie\2webcams\' paste_name '\' 'direita.avi'],'Uncompressed AVI');
Vid_left = VideoWriter(['movie\2webcams\' paste_name '\' 'esquerda.avi'],'Uncompressed AVI');

tic;
delay_response=toc;

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
    defaultans = {'1','2','MJPG_640x480','Inf','rgb','1','1001','1000','0','0','-7','-2'};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    %input
    close all force
    
    cam_left = videoinput('winvideo', str2num(answer{1}), answer{3});
    cam_right = videoinput('winvideo', str2num(answer{2}), answer{3});
    src1 = getselectedsource(cam_left);
    src2 = getselectedsource(cam_right);
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
    
    set(cam_left,'Timeout',str2num(answer{4}));
    set(cam_right,'Timeout',str2num(answer{4}));
    
    % Set video input object properties for this application.
    
    set(cam_left,'ReturnedColorSpace',answer{5});   
    set(cam_right,'ReturnedColorSpace',answer{5});
    
    set(cam_left,'FrameGrabInterval',str2num(answer{6}));
    set(cam_right,'FrameGrabInterval',str2num(answer{6}));
     
    set(cam_left,'FramesPerTrigger', str2num(answer{7}));
    set(cam_right,'FramesPerTrigger', str2num(answer{7}));
    %% preview das cameras
    prev_left=preview(cam_left);
    movegui(prev_left,'northwest')
    
    prev_right=preview(cam_right);
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
        stop(cam_right)
        delete(cam_right)
        stop(cam_left)
        delete(cam_left)
        close all force
        loop = 0;
    end
end

%alocate size memory for the movie
data=zeros(str2num(res{2}),str2num(res{1})*2,3,str2num(answer{8}),'uint8');

%%3- Start acquiring frames.
start([cam_left cam_right]);

i=0;
tic
while(i<str2num(answer{8}))  % Stop after x frames
    i=i+1;
    data(:,:,:,i) = [getdata(cam_left,1) getdata(cam_right,1)];
    tempo(i)=toc;
    flushdata(cam_left);% limpa o cache das cameras do ultimo frame
    flushdata(cam_right); 
end
%% Parar Webcams
stop(cam_right)
delete(cam_right)
stop(cam_left)
delete(cam_left)

for j=1:i
    M_left(j)=im2frame(data(:,1:str2num(res{1}),:,j));
    M_right(j)=im2frame(data(:,str2num(res{1})+1:str2num(res{1})*2,:,j));
end
%% 4 - parar as cams e plot de estatisticas
%salva vetor de tempo menos o delay de tempo de leitura da linha
tempo=tempo-delay_response;
tempo=tempo-min(tempo);

save(['movie\2webcams\' paste_name '\' 'tempo.mat'],'tempo');

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
        movie(M_right);
        movie(M_left);
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
        open(Vid_right);
        writeVideo(Vid_right, M_right);
        close(Vid_right);
        open(Vid_left);
        writeVideo(Vid_left, M_left);
        close(Vid_left);
        loop = 1;
    else
        close all force
        loop = 1;
    end
end
% end
