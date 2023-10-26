% FUNCTION ORGANIZE CENTROIDS
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%22 novembro 2017

function [centroids,n_index]=organize_centroids0603(centroids,filt4_target,prev_centroids)
[points,~]=size(prev_centroids);
index_areas=bwlabel(filt4_target);
for i=1:points
    n_index(i)=index_areas(round(prev_centroids(i,2)),round(prev_centroids(i,1)));
    if n_index(i)==0
        for j=1:points
            distance(j)=sqrt((centroids(j,2)-prev_centroids(i,2)).^2 + (centroids(j,1)-prev_centroids(i,1)).^2);
        end
        [M,p] = min(distance);
        n_index(i)=p;
    end
    dummy_centroids(i,:)=centroids(n_index(i),:);
end

centroids=dummy_centroids;
end