% FUNCTION localize targets
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%15 novembro 2017

function [centroids,points]=locate_centroids0602(filt4_target)
    bw = bwlabel(filt4_target);
    L = bwlabel(bw);
    s = regionprops(L, 'centroid');
    centroids = cat(1, s.Centroid);
    [points,~]=size(centroids);
end