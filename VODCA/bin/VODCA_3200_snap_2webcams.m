%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ALGORITMO PARA SALVAR FOTOS E CALIBRAR AS WEBCAMS BASEADO EM PAR DE
%IMAGENS
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paran� (UTFPR)
%Campus Corn�lio Proc�pio
%Laborat�rio Tecnol�gico de Vibra��es Mec�nicas
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
%contributions for the elaboration of this algorithm: Marcos Hiroshi Takahama 2017 (atual), Jos� Eduardo 2018 (atual)
%07/02/2017
function []=VODCA_3200_snap_2webcams()
global answer
%% 0 Propriedades de aquisi��o da webcam
%informa��es do driver
caminf  = imaqhwinfo;
mycam = char(caminf.InstalledAdaptors()); %mostra os drivers instalados onde deve aparecer o 'winvideo'
%armazena resolu��es da webcam
cam_number=webcamlist; %enumera webcams dispon�veis

% informa��o de cada cam
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
mkdir(['snapshots\2webcams\' paste_name '\snap_left']);
mkdir(['snapshots\2webcams\' paste_name '\snap_right']);

%% 1 - set properties from image aquisition
loop=0;
while loop==0
    
    %% configura��es de filmagem
    
    position={'northwest' 'northeast' 'southeast' 'southwest'};
    for i=1:length(cam_number)
        barra(i)=warndlg(sprintf(' %s \n', cam_resolution{i,:}), ['Cam' num2str(i) 'Resolutions']);
        movegui(barra(i),position{rem(i,4)});
    end
    
    barra_cam_inst=warndlg(sprintf(' %s \n', cam_number{:} ),'Cams in install order');
    movegui(barra_cam_inst,'north')
    
    %input parameters
    prompt = {'Number cam left','Number cam right','Resolution of cam left','Resolution of cam right','number of snapshots','Exposure mode','Focus mode ','White Balance(no available)','Focus Left','Focus Right','Exposure Left','Exposure Right'};
    %     prompt = {'Resolution','Gain','Saturation','White Balance','Sharpness','Brightness','BacklightCompesation','Contrast'};
    dlg_title = 'Configura��o de v�deo';
    num_lines = 1;
    defaultans = {'1','2','640x480','640x480','150','manual','manual','manual','0','0','-7','-7'};
    N=50; %this will control the width of the inputdlg
    answer = inputdlg(prompt,dlg_title,[1, length(dlg_title)+N],defaultans);
    %input
    close all force
    clear cam
    cam1=webcam(str2num(answer{1}));
    cam2=webcam(str2num(answer{2}));
    set(cam1,'Resolution',answer{3});
    set(cam2,'Resolution',answer{4});
    
        cam1.ExposureMode='auto';
        cam2.ExposureMode='auto';
        
        cam1.ExposureMode=answer{6};
        cam2.ExposureMode=answer{6};
        
        cam1.Exposure=str2num(answer{11});
        cam2.Exposure=str2num(answer{12});
        
        cam1.FocusMode='auto';
        cam2.FocusMode='auto';
        
        cam1.FocusMode=answer{7};
        cam2.FocusMode=answer{7};
                     
        cam1.Focus=str2num(answer{9});
        cam2.Focus=str2num(answer{10});
    %
    %     set(cam1,'WhiteBalanceMode',answer{8});
    %     set(cam2,'WhiteBalanceMode',answer{8});
    
    % Set video input object properties for this application.
    %% preview das cameras
    prev_right=preview(cam2);
    movegui(prev_right,'northwest')
    prev_left=preview(cam1);
    movegui(prev_left,'northeast')
    %% check while
    answer_loop = questdlg('Aceitar qualidade da imagem?','Configura��es',...
        'sim','n�o','sim');
    % Handle response
    switch answer_loop
        case 'sim'
        max_cont=str2num(answer{5});
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
                    img2=snapshot(cam2);
                    
                    imwrite(img1, ['snapshots\2webcams\' paste_name '\snap_left\cam_left_num_' num2str(cont) '.bmp']);
                    imwrite(img2, ['snapshots\2webcams\' paste_name '\snap_right\cam_right_num_' num2str(cont) '.bmp']);
                    
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
        case 'n�o'
        clear prev_right prev_left cam1 cam2
        close all force
        loop = 0;
    end
end

warndlg(sprintf(' Tudo pronto '));
end