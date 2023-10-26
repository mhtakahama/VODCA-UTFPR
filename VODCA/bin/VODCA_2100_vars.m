%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FUNCTION Display all vars
%% Master's Degree in Mechanical Engineering - PPGEM
%Federal University of Technology - Paraná (UTFPR)
%Campus Cornélio Procópio
%Laboratório Tecnológico de Vibrações Mecânicas e Manuntençãoo
%Student: Marcos Takahama
%Orientador: Adailton Silva Borges
%23 Abril 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Last implementation: some bug in yourdata variable
%Actual Implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function VODCA_2100_vars
global yourdata
echo on
oq=whos;
[M,N]=size(oq);

for i=1:M
nome{i} = getfield(oq(i,:), 'name');
end

for i=1:M
tamanho{i} = char(mat2str(getfield(oq(i,:), 'size')));
end

for i=1:M
espaco{i} = char(mat2str(getfield(oq(i,:), 'bytes')));
end

checkbox1={false;false;false};
yourdata ={nome' tamanho' espaco'}; 
yourdata = [yourdata{:}];
% cell2mat(yourdata)
columnname =   {'name', 'size', 'bytes'};
columnformat = {'char', 'char', 'char'};
columneditable =  [true true true]; 

hF=figure; 
set(hF,'color',[1 1 1]);
hA=axes; set(hA,'color',[1 1 1],'visible','off');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);%Maximiza a janela
set(gcf,'Name','List of vars',...  
        'MenuBar','none',...
        'NumberTitle','off');
    
t = uitable('Units','normalized','Position',...
          [0.1 0.1 0.9 0.9], 'Data', yourdata,... 
          'ColumnName', columnname,...
          'ColumnFormat', columnformat,...
          'ColumnEditable', columneditable,...
          'RowName',[] ,'BackgroundColor',[.7 .9 .8],'ForegroundColor',[0 0 0]);
      
end