%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITMO PARA SALVAR FOTOS E CALIBRAR AS WEBCAMS BASEADO EM PAR DE
%IMAGENS
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
%contributions for the elaboration of this algorithm: Marcos Hiroshi Takahama 2017 (atual), José Eduardo 2018 (atual)
%07/02/2017
function []=VODCA_3100_calib_stereo_1webcam()
global answer
%% 0 Propriedades de aquisição da webcam
%informações do driver
caminf  = imaqhwinfo;
mycam = char(caminf.InstalledAdaptors()); %mostra os drivers instalados onde deve aparecer o 'winvideo'
%armazena resoluções da webcam
cam_number=webcamlist; %enumera webcams disponíveis

% informação de cada cam
for i=1:length(cam_number)
    cam(i)= webcam(i);
end

for i=1:length(cam_number) %matlab cannot support increase the length of matrix in a for loop
    dummy=cam(i).AvailableResolutions;
    for j=1:length(dummy)
        cam_resolution(i,j)=dummy(1,j);
    end
end

paste_name= datestr(now,'yyyymmddTHHMMSS');
mkdir(['snapshots\1webcam\' paste_name]);

%% 1 - set properties from image aquisition
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
    prompt = {'Number cam ','Resolution of cam left','number of snapshots','Exposure mode','Focus mode ','White Balance(no available)','Focus','Exposure (beteween -1 to -7)'};
    %     prompt = {'Resolution','Gain','Saturation','White Balance','Sharpness','Brightness','BacklightCompesation','Contrast'};
    dlg_title = 'Configuração de vídeo';
    num_lines = 1;
    defaultans = {'2','640x480','50','manual','manual','manual','0','-1'};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    %input
    close all
    clear cam barra
    cam1=webcam(str2num(answer{1}));
    set(cam1,'Resolution',answer{2});
    
        cam1.ExposureMode='auto';
        
        cam1.ExposureMode=answer{4};
        
        cam1.Exposure=str2num(answer{8});
        
        cam1.FocusMode='auto';
        
        cam1.FocusMode=answer{5};
                     
        cam1.Focus=str2num(answer{7});
    %
    %     set(cam1,'WhiteBalanceMode',answer{8});
    %     set(cam2,'WhiteBalanceMode',answer{8});
    
    % Set video input object properties for this application.
    %% preview das cameras
    prev_right=preview(cam1);
    movegui(prev_right,'northwest')
    %% check while
    answer_loop = questdlg('Aceitar qualidade da imagem?','Configurações',...
        'sim','não','sim');
    % Handle response
    switch answer_loop
        case 'sim'
        max_cont=str2num(answer{3});
        cont=1;
        i=0;
        loop2=0;
        while loop2==0
            answer_preview= questdlg(['Take snapshot number ' num2str(cont) ' now?'],'SNAPSHOT',...
                'ok','stop','ok');
            switch answer_preview
                case 'ok'
                    close all
                    i=i+1;
                    img1=snapshot(cam1);
                    
                    imwrite(img1, ['snapshots\1webcam\' paste_name '\snap_' num2str(cont) '.bmp']);
                    
%                     figure
%                     gcf=imshow(img1);
%                     movegui(gcf,'southwest')
%                     figure
%                     gcf=imshow(img2);
%                     movegui(gcf,'southeast')
                    cont=cont+1;
                case 'stop'
                    cont=max_cont+1;
            end
            if cont==max_cont+1
                clear prev_right prev_left cam1 cam2
                close all force
                loop2=1;
                loop=1
            end
        end
        case 'não'
        clear prev_right prev_left cam1 cam2
        close all force
        loop = 0;
    end
end

warndlg(sprintf(' Tudo pronto '));
end