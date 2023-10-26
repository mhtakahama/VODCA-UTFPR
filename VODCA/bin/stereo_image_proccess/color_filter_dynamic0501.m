% FUNCTION color filter
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%15 novembro 2017
function [color_filter_high,color_filter_low,color_filter]=color_filter_dynamic0501(color_pick,sens_filtro,crop_target)

filt_r=[color_pick(1)+sens_filtro(1) color_pick(1)-sens_filtro(1)];
filt_g=[color_pick(2)+sens_filtro(2) color_pick(2)-sens_filtro(2)];
filt_b=[color_pick(3)+sens_filtro(3) color_pick(3)-sens_filtro(3)];

if (color_pick(1) >= color_pick(2)) && (color_pick(1) >= color_pick(3))
    color_filter_high=(crop_target(:,:,1)>=filt_r(2)&crop_target(:,:,2)<=filt_g(1)&crop_target(:,:,3)<=filt_b(1));
    color_filter_low=(crop_target(:,:,1)>=filt_r(2)&crop_target(:,:,2)>=filt_g(1)&crop_target(:,:,3)>=filt_b(1));
elseif (color_pick(2) >= color_pick(1)) && (color_pick(2) >= color_pick(3))
    color_filter_high=(crop_target(:,:,1)<=filt_r(1)&crop_target(:,:,2)>=filt_g(2)&crop_target(:,:,3)<=filt_b(1));
    color_filter_low=(crop_target(:,:,1)>=filt_r(1)&crop_target(:,:,2)>=filt_g(2)&crop_target(:,:,3)>=filt_b(1));
else
    color_filter_high=(crop_target(:,:,1)<=filt_r(1)&crop_target(:,:,2)<=filt_g(1)&crop_target(:,:,3)>=filt_b(2));
    color_filter_low=(crop_target(:,:,1)>=filt_r(1)&crop_target(:,:,2)>=filt_g(1)&crop_target(:,:,3)>=filt_b(2));
end

color_filter = imsubtract(color_filter_high, color_filter_low);
color_filter(color_filter==-1)=0; %NORMALIZAÇÂO DA MATRIZ, USAR SEMPRE APÓS IMSUBTRACT

end