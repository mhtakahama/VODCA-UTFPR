% FUNCTION Objects filter
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%15 novembro 2017

function [filt1_target,filt2_target,filt3_target,filt4_target]=noise_filter0601(color_filter,medfilt_option,bwareopen_option,imerode_option,imdilate_option,strel_option)

    %% 5.1 - remove small objects
    if medfilt_option==0  %sem medifilt
        %% 5.1.1 - medfilt2
        filt1_target=color_filter;%filtro medio da vizinhança 5x5g
%         filt1_gage=gage_bin;%filtro medio da vizinhança 5x5g
        %% 5.1.2 - bwareaopen
        filt2_target=bwareaopen(filt1_target,(bwareopen_option));%remove pequenos objetos
%         filt2_gage= bwareaopen(filt1_gage,round(lessthen_option/100*sqrt(bwarea(filt1_gage))));%remove pequenos objetos
        %% 5.2 - erosão
        se=strel(strel_option,imerode_option);%set strel form
        filt3_target = imerode(filt2_target,se);%erosao
        %% 5.3 - dilatação
        sd=strel(strel_option,imdilate_option);%set strel form
        filt4_target = imdilate(filt3_target,sd);%dilatação
        
        if  bwareopen_option==0 %sem bwareopen
            
            filt2_target=color_filter;%remove pequenos objetos
%             filt2_gage=gage_bin;%remove pequenos objetos
            %% 5.2 - erosão
            filt3_target = imerode(filt2_target,se);%erosao
            %% 5.3 - dilatação
            filt4_target = imdilate(filt3_target,sd);%dilatação
            if imerode_option==0 %sem erosão
                
                %% 5.2 - erosão
                filt3_target =color_filter;%erosao
                %% 5.3 - dilatação
                filt4_target = imdilate(filt3_target,sd);%dilatação
                if imdilate_option==0 %sem dilatação
                    filt4_target = color_filter;%dilatação
                end
            end
        end
    else
        %% 5.1.1 - medfilt2
        filt1_target= medfilt2(color_filter, [medfilt_option medfilt_option]);%filtro medio da vizinhança 5x5g
%         filt1_gage= medfilt2(gage_bin, [medfilt_option medfilt_option]);%filtro medio da vizinhança 5x5g
        %% 5.1.2 - bwareaopen
        filt2_target=bwareaopen(filt1_target,(bwareopen_option));%remove pequenos objetos
%         filt2_gage= bwareaopen(filt1_gage,round(lessthen_option/100*sqrt(bwarea(filt1_gage))));%remove pequenos objetos
        %% 5.2 - erosão
        se=strel(strel_option,imerode_option);%set strel form
        filt3_target = imerode(filt2_target,se);%erosao
        %% 5.3 - dilatação
        sd=strel(strel_option,imdilate_option);%set strel form
        filt4_target = imdilate(filt3_target,sd);%dilatação
    end
    
end