%matlab 程序实现 模拟退火算法程序 函数求极值（引用后修改，感谢 ARMYLAU）

%使用模拟退火法求函数f(x,y) = 3*cos(xy) + x + y2的最小值
%解：根据题意，我们设计冷却表进度表为：
%即初始温度为30
%衰减参数为0.95
%马可夫链长度为10000
%Metropolis的步长为0.02
%结束条件为根据上一个最优解与最新的一个最优解的之差小于某个容差。
%使用METROPOLIS接受准则进行模拟, 程序如下

%* 日期:2012－11-29
%* 作者:steven
%*　EMAIL:hxs2004@126.com
%* 结束条件为两次最优解之差小于某小量

function [BestX,BestY]=SimulateAnnealing1
clear;
clc;
%// 要求最优值的目标函数,搜索的最大区间
 a = 5
  XMAX = a;
  YMAX = a;
%冷却表参数
 MarkovLength = 10000; %// 马可夫链长度
 DecayScale = 0.95; %// 衰减参数
 StepFactor = 0.02; %// 步长因子
 Temperature=30; %// 初始温度
 Tolerance = 1e-8; %// 容差
AcceptPoints = 0.0; %// Metropolis过程中总接受点
rnd =rand;

% 随机选点 初值设定
PreX = -XMAX * rand ;
PreY = -YMAX * rand;
PreBestX  = PreX;
PreBestY = PreY;

PreX = -XMAX * rand ;
PreY = -YMAX * rand;
BestX = PreX;
 BestY = PreY;
% 每迭代一次退火一次(降温), 直到满足迭代条件为止
mm=abs( ObjectFunction( BestX,BestY)-ObjectFunction (PreBestX, PreBestY));
while mm > Tolerance

Temperature=DecayScale*Temperature;
AcceptPoints = 0.0;
% 在当前温度T下迭代loop(即MARKOV链长度)次
for i=0:MarkovLength:1
% 1) 在此点附近随机选下一点
p=0;
while p==0
    NextX = PreX + StepFactor*XMAX*(rand-0.5);
    NextY = PreY + StepFactor*YMAX*(rand-0.5);
    if p== (~(NextX >= -XMAX && NextX <= XMAX && NextY >= -YMAX && NextY <= YMAX && NextX >= -3 && NextY <= 3))
       p=1;
    end
end

% 2) 是否全局最优解
if (ObjectFunction(BestX,BestY) > ObjectFunction(NextX,NextY))
% 保留上一个最优解
PreBestX =BestX;
PreBestY = BestY;
% 此为新的最优解
BestX=NextX;
BestY=NextY;
end
% 3) Metropolis过程

if( ObjectFunction(PreX,PreY) - ObjectFunction(NextX,NextY) > 0 )
  %// 接受, 此处lastPoint即下一个迭代的点以新接受的点开始
PreX=NextX;
PreY=NextY;
AcceptPoints=AcceptPoints+1;
else
 changer = -1 * ( ObjectFunction(NextX,NextY) - ObjectFunction(PreX,PreY) ) / Temperature ;
rnd=rand;
p1=exp(changer);
double (p1);

if p1 > rand            %// 不接受, 保存原解
   PreX=NextX;
   PreY=NextY;
   AcceptPoints=AcceptPoints+1;
end
end
end
mm=abs( ObjectFunction( BestX,BestY)-ObjectFunction (PreBestX, PreBestY));
end

disp(['最小值在点:' num2str(BestX)]);
BestX
disp(['最小值在点:' num2str(BestY)]);
BestY
disp(['最小值为:' num2str(ObjectFunction(BestX, BestY))]);

end

 

%子函数，目标函数值计算

 

function  value=ObjectFunction(x,y)
         value=-3*(1-x)^2*exp(-x^2-(y+1)^2)+10*(x/5-x^3-y^5)*exp(-x^2-y^2)+exp(-(x+1)^2-y^2)/3;
end