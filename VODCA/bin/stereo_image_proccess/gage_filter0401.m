% FUNCTION COLOR FILTER IN THE GAGE
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [gage_bin]=gage_filter0401(crop_gage,gage_filter)

gage_bin=(crop_gage(:,:,1)>gage_filter(1)&crop_gage(:,:,2)>gage_filter(2)&crop_gage(:,:,3)>gage_filter(3));


end