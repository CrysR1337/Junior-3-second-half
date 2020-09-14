%x=-10:0.5.:10;  % x的取值范围【-1,2】；

%y=-15*sin(2*x).*sin(2*x)-(x-2).*(x-2)+160; 

%plot(x,y);

%%%%%%%%%f(x)=x+10sin(5x)+7cos(4x)%%%%%%%%%%
clear all;              %清除所有变量
close all;              %清图
clc;                    %清屏
x=-10:0.01:10;
y=-15*sin(2*x).*sin(2*x)-(x-2).*(x-2)+160;
plot(x,y)
xlabel('x')
ylabel('f(x)')
title('fun')
