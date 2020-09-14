clear;clc;close all;

%%遗传参数设置
NUMPOP=100;%初始种群大小
irange_l=-1; %问题解区间
irange_r=2;
LENGTH=22; %二进制编码长度
ITERATION = 10000;%迭代次数
CROSSOVERRATE = 0.7;%杂交率
SELECTRATE = 0.8;%选择率
VARIATIONRATE = 0.001;%变异率

%初始化种群
pop=m_InitPop(NUMPOP,irange_l,irange_r);
pop_save=pop;
%绘制初始种群分布
x=linspace(-1,2,1000);
y=m_Fx(x);
plot(x,y);
hold on
for i=1:size(pop,2)
    plot(pop(i),m_Fx(pop(i)),'ro');
end
hold off
title('初始种群');

%开始迭代
for time=1:ITERATION
    %计算初始种群的适应度
    fitness=m_Fitness(pop);
    %选择
    pop=m_Select(fitness,pop,SELECTRATE);
    %编码
    binpop=m_Coding(pop,LENGTH,irange_l);
    %交叉
    kidsPop = crossover(binpop,NUMPOP,CROSSOVERRATE);
    %变异
    kidsPop = Variation(kidsPop,VARIATIONRATE);
    %解码
    kidsPop=m_Incoding(kidsPop,irange_l);
    %更新种群
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
title('终止种群');

disp(['最优解：' num2str(max(pop))]);
disp(['最优值：' num2str(max(m_Fx(pop)))]);
disp(['最大适应度：' num2str(max(m_Fitness(pop)))]);   
    
function y=m_Fx(x)
%% 要求解的函数
    y=-15*sin(2*x).^2-(x-2).^2+160;
end

function fitness=m_Fitness(pop)
%% Fitness Function
%y=xsin(3x)在[-1,2]上，最大值也不会超过2
%所以计算函数值到2的距离，距离最小时，即为最优解
%适应度函数为1/距离
for n=1:size(pop,2)
    fitness(n)=1/(160-m_Fx(pop(:,n)));
end

end

function pop=m_InitPop(numpop,irange_l,irange_r)
%% 初始化种群
%  输入：numpop--种群大小；
%       [irange_l,irange_r]--初始种群所在的区间
pop=[];
for i=1:numpop
    pop(:,i)=irange_l+(irange_r-irange_l)*rand;
end
end

%% 子函数
%
%题  目：Crossover
%
%%
%输   入：
%           parentsPop       上一代种群
%           NUMPOP           种群大小
%           CROSSOVERRATE    交叉率
%输   出：
%           kidsPop          下一代种群
%
%% 
function kidsPop = crossover(parentsPop,NUMPOP,CROSSOVERRATE)
kidsPop = {[]};n = 1;
while size(kidsPop,2)<NUMPOP-size(parentsPop,2)
    %选择出交叉的父代和母代
    father = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    mother = parentsPop{1,ceil((size(parentsPop,2)-1)*rand)+1};
    %随机产生交叉位置
    crossLocation = ceil((length(father)-1)*rand)+1;
    %如果随即数比交叉率低，就杂交
    if rand<CROSSOVERRATE
        father(1,crossLocation:end) = mother(1,crossLocation:end);
        kidsPop{n} = father;
        n = n+1;
    end
end
end

function binPop=m_Coding(pop,pop_length,irange_l)
%% 二进制编码（生成染色体）
% 输入：pop--种群
%      pop_length--编码长度
pop=round((pop-irange_l)*10^6);
for n=1:size(pop,2) %列循环
    for k=1:size(pop,1) %行循环
        dec2binpop{k,n}=dec2bin(pop(k,n));%dec2bin的输出为字符向量；
                                          %dec2binpop是cell数组
        lengthpop=length(dec2binpop{k,n});
        for s=1:pop_length-lengthpop %补零
            dec2binpop{k,n}=['0' dec2binpop{k,n}];
        end
    end
    binPop{n}=dec2binpop{k,n};   %取dec2binpop的第k行
end
end

function pop=m_Incoding(binPop,irange_l)
%% 解码
popNum=1;
popNum = 1;%染色体包含的参数数量
for n=1:size(binPop,2)
    Matrix = binPop{1,n};
    for num=1:popNum
        pop(num,n) = bin2dec(Matrix);
    end
end
pop = pop./10^6+irange_l;
end

function parentPop=m_Select(matrixFitness,pop,SELECTRATE)
%% 选择
% 输入：matrixFitness--适应度矩阵
%      pop--初始种群
%      SELECTRATE--选择率

sumFitness=sum(matrixFitness(:));%计算所有种群的适应度

accP=cumsum(matrixFitness/sumFitness);%累积概率
%轮盘赌选择算法
for n=1:round(SELECTRATE*size(pop,2))
    matrix=find(accP>rand); %找到比随机数大的累积概率
    if isempty(matrix)
        continue
    end
    parentPop(:,n)=pop(:,matrix(1));%将首个比随机数大的累积概率的位置的个体遗传下去
end
end

%% 子函数
%
%题  目：Variation
%
%
%输   入：
%           pop              种群
%           VARIATIONRATE    变异率
%输   出：
%           pop              变异后的种群
%% 
function kidsPop = Variation(kidsPop,VARIATIONRATE)
for n=1:size(kidsPop,2)
    if rand<VARIATIONRATE
        temp = kidsPop{n};
        %找到变异位置
        location = ceil(length(temp)*rand);
        temp = [temp(1:location-1) num2str(~temp(location))...
            temp(location+1:end)];
       kidsPop{n} = temp;
    end
end
end
