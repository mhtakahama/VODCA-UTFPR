%FUNCTION SELECT FILE
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [name_file,PATH,job]=pick_file0101(text,extensao)

[job,PATH] = uigetfile(extensao,text,text);
fid = fopen(job,'rt');

[~,name_file,~] = fileparts(job);
% 
% if fid(1)<1
%     warndlg('Couldnt be possible open the file, please put this algoritm in the same folder',...
%         '!! Warning !!')
%     return
% end

end