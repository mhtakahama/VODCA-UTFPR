%NORMALIZA COLUNA DE GRANDEZAS
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%14 novembro 2017

function [desl]=normaliza_coluna_0102(signal)

[m,n]=size(signal);

mean_signal=mean(signal);

for i=1:m
    dummy(i,:)=signal(i,:)-mean_signal; %normalização do deslocamento
end

desl=dummy;
end