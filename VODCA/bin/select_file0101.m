%FUNCTION SELECT FILE
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [PATH,job]=select_file0101();

[job,PATH] = uigetfile('*.mat','Select Stereo Calibration parameters');

[~,name_file,~] = fileparts(job);

end