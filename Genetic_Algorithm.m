clc;
clear all;

i1=input('Escreva o custo de oportunidade: ');
%i1=0.09;
n1=input('Escreva o número de períodos: ');
%n1=10;
I=input('Escreva o investimento inicial: ');
%I=30;
gen=input('Escreva o número de gerações: ');
%gen=40; %trocar
n=input('Escreva o número dos genes: ');
%n=10;
pob=input('Escreva o número da população inicial: ');
%pob=5; %trocar
pc_2=input('Probabilidade de cruzamento [1 9]: ');
%pc_2=5;
pc=pc_2*0.1;
probMut_2=input('Probabilidade de mutação [1 9]: ');
%probMut_2=5;
probMut=probMut_2*0.01;

format shortg; %digitos de 5 caracteres
%Tempo de processamento
tic  %toc
%Geramos números aleatórios para definir a População Inicial de pop*n
A=[];
for i=1:pob
    for j=1:n
        A(i,j)=round(rand); 
    end
end

hold on;
%Começamos gerações de evolução
for g=1:gen
    fprintf('Geração %d\n',g);
    fprintf('Pob. inicial\n');disp(A);
    
    %Conversão de binário para decimal em X
    X=[];
    for i=1:pob
        X(i)=bin2dec(num2str(A(i,:))); %convertemos vetor numérico para 
                           %string e isso do sistema binário para decimal
    end
    fprintf('X= ');disp(X);
    
    %Avaliação de aptidão
    fX=[]; sumatoria=0;
    for i=1:pob
        fX(i)=0;
        for k=1:n1
        fX(i)=fX(i) + (X(i))/((1+i1)^k); %fitness
        end
        fX(i)=fX(i)-I;
    sumatoria=sumatoria+fX(i); %obtemos a somatória
    end
    fprintf('fX= ');disp(fX);
    
    %Representamos graficamente
    title('Evolução da População')
    xlabel('Gerações da população')
    ylabel('Valor de fitness')
    if g==1
        plot(X,fX,'^k','LineWidth',2);
    else
        plot(X,fX,'vb','LineWidth',2);        
    end
       
    %Obtemos a probabilidade de seleção
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
    
    %Obtemos os valores aleatórios de R
    R=[];
    for i=1:pob
        R(i)=rand;
    end
    fprintf('R= ');disp(R);
    
    %Seleção por roleta
    pobRol=[];
    for i=1:pob
        for j=1:pob
            if probCum(j)>R(i) %Se prob.Acum(j)>r(i) pegamos o ind. se 
                                %não aumentamos j
                pobRol(i,:)=A(j,:); %Atribuímos na posição i (de r) o 
                                    %novo indivíduo da posição j
                break;
            end
        end
    end
    fprintf('População da roleta \n');disp(pobRol);
    
    %Temos a prob. de Cruzamento, se for menor, cruzamos, além de obter o 
    %ponto de cruzamento e obtemos a geração cruzada
    pobCruz=[];
    if (mod(pob,2)~=0)%Se for impar a população
        pobCruz(pob,:)=pobRol(pob,:); %Atribuímos o último elemento 
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
            if i==pob-2 %Se a população é ímpar e estamos no penúltimo 
                        %elemento (de 2 a 2), quebramos
                break;
            end
        end
    end
    fprintf('População Cruzada\n');disp(pobCruz);
    
    %Obtemos a mutação
    probMut=0.06;
    pobMut=[];
    for i=1:pob
        for j=1:n
            mutacion=rand;
            if(mutacion<probMut)
                fprintf (['Se houver uma mutação na iteração i=%d,j=%d;' ... 
                'a mutacao foi=%f\n'],i,j,mutacion);
                pobMut(i,j)=(pobCruz(i,j)-1)^2; %Obtemos o oposto do 
                                                %binário 0=1 y 1=0
            else
                pobMut(i,j)=pobCruz(i,j); %Se não passamos assim
            end
        end
    end
    fprintf('População mutada\n');disp(pobMut);
    A=pobMut;
    
    %Conversão de binário para decimal em X
    X=[];
    for i=1:pob
        X(i)=bin2dec(num2str(A(i,:)));%%convertemos vetor numérico para 
                           %string e isso do sistema binário para decimal
    end
    fprintf('X= ');disp(X);
    
    %Avaliação de aptidão
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

%Temos o melhor da última geração
hold on
mayor=0;
for i=1:pob
    if fX(i)>=mayor
        mayor=fX(i);
    end
end
fprintf('O melhor da última geração é: %f',mayor);

%Representamos graficamente
mayor1=0;
for i=1:pob
    if X(i)>=mayor1
        mayor1=X(i);
    end
end
legend({'População inicial','População de todas as gerações'},...
       'Location','northwest')
plot(mayor1,mayor,'or','LineWidth',2,'DisplayName','O melhor da ultima geração');
grid;
hold off;
toc;
