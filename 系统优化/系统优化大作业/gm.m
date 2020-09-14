clear;clc;close all;

%%�Ŵ���������
NUMPOP=100;%��ʼ��Ⱥ��С
irange_l=-1; %���������
irange_r=2;
LENGTH=22; %�����Ʊ��볤��
ITERATION = 10000;%��������
CROSSOVERRATE = 0.7;%�ӽ���
SELECTRATE = 0.8;%ѡ����
VARIATIONRATE = 0.001;%������

%��ʼ����Ⱥ
pop=m_InitPop(NUMPOP,irange_l,irange_r);
pop_save=pop;
%���Ƴ�ʼ��Ⱥ�ֲ�
x=linspace(-1,2,1000);
y=m_Fx(x);
plot(x,y);
hold on
for i=1:size(pop,2)
    plot(pop(i),m_Fx(pop(i)),'ro');
end
hold off
title('��ʼ��Ⱥ');

%��ʼ����
for time=1:ITERATION
    %�����ʼ��Ⱥ����Ӧ��
    fitness=m_Fitness(pop);
    %ѡ��
    pop=m_Select(fitness,pop,SELECTRATE);
    %����
    binpop=m_Coding(pop,LENGTH,irange_l);
    %����
    kidsPop = crossover(binpop,NUMPOP,CROSSOVERRATE);
    %����
    kidsPop = Variation(kidsPop,VARIATIONRATE);
    %����
    kidsPop=m_Incoding(kidsPop,irange_l);
    %������Ⱥ
    pop=[pop kidsPop];
end
figure
x=linspace(-1,2,1000);
y=m_Fx(x);
plot(x,y);
hold on
for i=1:size(pop,2)
    plot(pop(i),m_Fx(pop(i)),'ro');
end
hold off
title('��ֹ��Ⱥ');

disp(['���Ž⣺' num2str(max(pop))]);
disp(['����ֵ��' num2str(max(m_Fx(pop)))]);
disp(['�����Ӧ�ȣ�' num2str(max(m_Fitness(pop)))]);   
    
function y=m_Fx(x)
%% Ҫ���ĺ���
    y=-15*sin(2*x).^2-(x-2).^2+160;
end

function fitness=m_Fitness(pop)
%% Fitness Function
%y=xsin(3x)��[-1,2]�ϣ����ֵҲ���ᳬ��2
%���Լ��㺯��ֵ��2�ľ��룬������Сʱ����Ϊ���Ž�
%��Ӧ�Ⱥ���Ϊ1/����
for n=1:size(pop,2)
    fitness(n)=1/(160-m_Fx(pop(:,n)));
end

end

function pop=m_InitPop(numpop,irange_l,irange_r)
%% ��ʼ����Ⱥ
%  ���룺numpop--��Ⱥ��С��
%       [irange_l,irange_r]--��ʼ��Ⱥ���ڵ�����
pop=[];
for i=1:numpop
    pop(:,i)=irange_l+(irange_r-irange_l)*rand;
end
end

%% �Ӻ���
%
%��  Ŀ��Crossover
%
%%
%��   �룺
%           parentsPop       ��һ����Ⱥ
%           NUMPOP           ��Ⱥ��С
%           CROSSOVERRATE    ������
%��   ����
%           kidsPop          ��һ����Ⱥ
%
%% 
function kidsPop = crossover(parentsPop,NUMPOP,CROSSOVERRATE)
kidsPop = {[]};n = 1;
while size(kidsPop,2)<NUMPOP-size(parentsPop,2)
    %ѡ�������ĸ�����ĸ��
    father = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    mother = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    %�����������λ��
    crossLocation = ceil((length(father)-1)*rand)+1;
    %����漴���Ƚ����ʵͣ����ӽ�
    if rand<CROSSOVERRATE
        father(1,crossLocation:end) = mother(1,crossLocation:end);
        kidsPop{n} = father;
        n = n+1;
    end
end
end

function binPop=m_Coding(pop,pop_length,irange_l)
%% �����Ʊ��루����Ⱦɫ�壩
% ���룺pop--��Ⱥ
%      pop_length--���볤��
pop=round((pop-irange_l)*10^6);
for n=1:size(pop,2) %��ѭ��
    for k=1:size(pop,1) %��ѭ��
        dec2binpop{k,n}=dec2bin(pop(k,n));%dec2bin�����Ϊ�ַ�������
                                          %dec2binpop��cell����
        lengthpop=length(dec2binpop{k,n});
        for s=1:pop_length-lengthpop %����
            dec2binpop{k,n}=['0' dec2binpop{k,n}];
        end
    end
    binPop{n}=dec2binpop{k,n};   %ȡdec2binpop�ĵ�k��
end
end

function pop=m_Incoding(binPop,irange_l)
%% ����
popNum=1;
popNum = 1;%Ⱦɫ������Ĳ�������
for n=1:size(binPop,2)
    Matrix = binPop{1,n};
    for num=1:popNum
        pop(num,n) = bin2dec(Matrix);
    end
end
pop = pop./10^6+irange_l;
end

function parentPop=m_Select(matrixFitness,pop,SELECTRATE)
%% ѡ��
% ���룺matrixFitness--��Ӧ�Ⱦ���
%      pop--��ʼ��Ⱥ
%      SELECTRATE--ѡ����

sumFitness=sum(matrixFitness(:));%����������Ⱥ����Ӧ��

accP=cumsum(matrixFitness/sumFitness);%�ۻ�����
%���̶�ѡ���㷨
for n=1:round(SELECTRATE*size(pop,2))
    matrix=find(accP>rand); %�ҵ������������ۻ�����
    if isempty(matrix)
        continue
    end
    parentPop(:,n)=pop(:,matrix(1));%���׸������������ۻ����ʵ�λ�õĸ����Ŵ���ȥ
end
end

%% �Ӻ���
%
%��  Ŀ��Variation
%
%
%��   �룺
%           pop              ��Ⱥ
%           VARIATIONRATE    ������
%��   ����
%           pop              ��������Ⱥ
%% 
function kidsPop = Variation(kidsPop,VARIATIONRATE)
for n=1:size(kidsPop,2)
    if rand<VARIATIONRATE
        temp = kidsPop{n};
        %�ҵ�����λ��
        location = ceil(length(temp)*rand);
        temp = [temp(1:location-1) num2str(~temp(location))...
            temp(location+1:end)];
       kidsPop{n} = temp;
    end
end
end
