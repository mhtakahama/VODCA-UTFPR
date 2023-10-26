% FUNCTION Fast Fourier Transform
%% Mestrado em Engenharia Mecânica PPGEM
%Universidade Tecnológica Federal do Paraná
%Campus Cornélio Procópio
%Orientador: Adailton Silva Borges
%Contribuições para elaboração deste algoritmo: Marcos Takahama (atual), Henrique Sidney Rissá, Jomar Berton, Danilo Montilha
%17 jan 2018

function [P1]=Fast_fourier1001(S,L)
Y = fft(S);
P2 = abs(Y/(L));
P1 = P2(1:L/2+1);
P1(2:end-1) = P1(2:end-1);
end
% 
% PUDIM DE LEITE CONDENSADO
% INGREDIENTES
% PUDIM:
% 1 lata de leite condensado
% 1 lata de leite (medida da lata de leite condensado)
% 3 ovos inteiros
% CALDA:
% 1 xícara (chá) de açúcar
% 2 xícaras de água
% 
% MODO DE PREPARO
% PUDIM:
% Primeiro, bata bem os ovos no liquidificador
% Acrescente o leite condensado e o leite, e bata novamente
% CALDA:
% Derreta o açúcar na panela até ficar moreno, acrescente a água e deixe engrossar
% Coloque em uma forma redonda e despeje a massa do pudim por cima
% Asse em forno médio por 45 minutos, com a assadeira redonda dentro de uma maior com água
% Espete um garfo para ver se está bem assado
% Deixe esfriar e desenforme