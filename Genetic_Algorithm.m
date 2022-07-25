clc;
clear all;

i1=input('Escreva o custo de oportunidade: ');
%i1=0.09;
n1=input('Escreva o n�mero de per�odos: ');
%n1=10;
I=input('Escreva o investimento inicial: ');
%I=30;
gen=input('Escreva o n�mero de gera��es: ');
%gen=40; %trocar
n=input('Escreva o n�mero dos genes: ');
%n=10;
pob=input('Escreva o n�mero da popula��o inicial: ');
%pob=5; %trocar
pc_2=input('Probabilidade de cruzamento [1 9]: ');
%pc_2=5;
pc=pc_2*0.1;
probMut_2=input('Probabilidade de muta��o [1 9]: ');
%probMut_2=5;
probMut=probMut_2*0.01;

format shortg; %digitos de 5 caracteres
%Tempo de processamento
tic  %toc
%Geramos n�meros aleat�rios para definir a Popula��o Inicial de pop*n
A=[];
for i=1:pob
    for j=1:n
        A(i,j)=round(rand); 
    end
end

hold on;
%Come�amos gera��es de evolu��o
for g=1:gen
    fprintf('Gera��o %d\n',g);
    fprintf('Pob. inicial\n');disp(A);
    
    %Convers�o de bin�rio para decimal em X
    X=[];
    for i=1:pob
        X(i)=bin2dec(num2str(A(i,:))); %convertemos vetor num�rico para 
                           %string e isso do sistema bin�rio para decimal
    end
    fprintf('X= ');disp(X);
    
    %Avalia��o de aptid�o
    fX=[]; sumatoria=0;
    for i=1:pob
        fX(i)=0;
        for k=1:n1
        fX(i)=fX(i) + (X(i))/((1+i1)^k); %fitness
        end
        fX(i)=fX(i)-I;
    sumatoria=sumatoria+fX(i); %obtemos a somat�ria
    end
    fprintf('fX= ');disp(fX);
    
    %Representamos graficamente
    title('Evolu��o da Popula��o')
    xlabel('Gera��es da popula��o')
    ylabel('Valor de fitness')
    if g==1
        plot(X,fX,'^k','LineWidth',2);
    else
        plot(X,fX,'vb','LineWidth',2);        
    end
       
    %Obtemos a probabilidade de sele��o
    probSel=[];
    for i=1:pob
        probSel(i)=fX(i)/sumatoria;
    end
    fprintf('Prob. Sel.= ');disp(probSel);
    
    %Obtemos a probabilidade cumulativa
    probCum=[]; probCum(1)=probSel(1);
    for i=2:pob
        probCum(i)=probCum(i-1)+probSel(i);
    end
    fprintf('Prob. Acu.= ');disp(probCum);
    
    %Obtemos os valores aleat�rios de R
    R=[];
    for i=1:pob
        R(i)=rand;
    end
    fprintf('R= ');disp(R);
    
    %Sele��o por roleta
    pobRol=[];
    for i=1:pob
        for j=1:pob
            if probCum(j)>R(i) %Se prob.Acum(j)>r(i) pegamos o ind. se 
                                %n�o aumentamos j
                pobRol(i,:)=A(j,:); %Atribu�mos na posi��o i (de r) o 
                                    %novo indiv�duo da posi��o j
                break;
            end
        end
    end
    fprintf('Popula��o da roleta \n');disp(pobRol);
    
    %Temos a prob. de Cruzamento, se for menor, cruzamos, al�m de obter o 
    %ponto de cruzamento e obtemos a gera��o cruzada
    pobCruz=[];
    if (mod(pob,2)~=0)%Se for impar a popula��o
        pobCruz(pob,:)=pobRol(pob,:); %Atribu�mos o �ltimo elemento 
                                      %diretamente
    end
    for i=1:2:pob
        probCruz=rand; %Obtemos a probabilidade de cruzamento
        fprintf('Prob. cruzada=%f %f\n',probCruz,pc);
        if(probCruz<pc) %Se for menos fazemos o cruzamento
            ptoC=round(rand*n); %obtemos o ponto de cruzamento 
                                %aleatoriamente >1 & <n
            while ptoC>n-1 || ptoC<1
                ptoC=round(rand*n);
            end
            fprintf('Ponto de cruz.=%d\n',ptoC);
            for j=1:n
                if j>ptoC
                    pobCruz(i,j)=pobRol(i+1,j);
                    pobCruz(i+1,j)=pobRol(i,j);
                else
                    pobCruz(i,j)=pobRol(i,j);
                    pobCruz(i+1,j)=pobRol(i+1,j);
                end
            end
        else
            pobCruz(i,:)=pobRol(i,:);
            pobCruz(i+1,:)=pobRol(i+1,:);
        end
        if (mod(pob,2)~=0)
            if i==pob-2 %Se a popula��o � �mpar e estamos no pen�ltimo 
                        %elemento (de 2 a 2), quebramos
                break;
            end
        end
    end
    fprintf('Popula��o Cruzada\n');disp(pobCruz);
    
    %Obtemos a muta��o
    probMut=0.06;
    pobMut=[];
    for i=1:pob
        for j=1:n
            mutacion=rand;
            if(mutacion<probMut)
                fprintf (['Se houver uma muta��o na itera��o i=%d,j=%d;' ... 
                'a mutacao foi=%f\n'],i,j,mutacion);
                pobMut(i,j)=(pobCruz(i,j)-1)^2; %Obtemos o oposto do 
                                                %bin�rio 0=1 y 1=0
            else
                pobMut(i,j)=pobCruz(i,j); %Se n�o passamos assim
            end
        end
    end
    fprintf('Popula��o mutada\n');disp(pobMut);
    A=pobMut;
    
    %Convers�o de bin�rio para decimal em X
    X=[];
    for i=1:pob
        X(i)=bin2dec(num2str(A(i,:)));%%convertemos vetor num�rico para 
                           %string e isso do sistema bin�rio para decimal
    end
    fprintf('X= ');disp(X);
    
    %Avalia��o de aptid�o
    fX=[]; sumatoria=0;
    for i=1:pob
        fX(i)=0;
        for k=1:n1
        fX(i)=fX(i) + (X(i))/((1+i1)^k); %fitness
        end
        fX(i)=fX(i)-I;
    end
    fprintf('fX= ');disp(fX);
end
hold off;

%Temos o melhor da �ltima gera��o
hold on
mayor=0;
for i=1:pob
    if fX(i)>=mayor
        mayor=fX(i);
    end
end
fprintf('O melhor da �ltima gera��o �: %f',mayor);

%Representamos graficamente
mayor1=0;
for i=1:pob
    if X(i)>=mayor1
        mayor1=X(i);
    end
end
legend({'Popula��o inicial','Popula��o de todas as gera��es'},...
       'Location','northwest')
plot(mayor1,mayor,'or','LineWidth',2,'DisplayName','O melhor da ultima gera��o');
grid;
hold off;
toc;
