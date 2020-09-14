clc; clear;

f = @(x) 100*(x(2)-x(1).^2)^2+(1-x(1))^2; %待求函数，x1,x2,x3...
% f = @(x) x(1).^2+2*x(2).^2;
paraNum = 2; %函数参数的个数，x1,x2,x3...的个数
x0 = [-2,2]; %初始值
tol = 1e-4; %迭代容忍度
flag = inf; %结束条件
error = []; %函数变化

while flag > tol
% for i =1:1
    p = g(f,x0,paraNum); %列向量    
    if norm(p) < tol
            buChang = 0;
    else
        buChang = argmin(f,x0,p,paraNum); %求步长，line search：argmin function
    end
    x1 = x0-buChang.*p';
    flag = norm(x1-x0);
    error = [error,flag];
    x0 = x1;
end
plot(0:length(error)-1,error)
disp('结果如下：best_x =')
disp(x0)
disp(subs(f,findsym(f),x0))

function [f_grad] = g(f,x0,paraNum)
temp = sym('x',[1,paraNum]);
f1=f(temp);
Z = gradient(f1);
f_grad = double(subs(Z,temp,x0));
end

% function [x] = argmin(f,paraNum)
% %求步长
% t = zeros(1,paraNum);
% options = optimset('Display','off');
% [x,~] = fminunc(f,t,options);
% end

function [x] = argmin(f,x0,p,num)
% 求步长
% for i=1:paraNum
%     syms(['x',num2str(i)]);
% end
temp = sym('x',[1,num]);
f1=f(x0 - temp.*p');
for i = 1:num
    temp(i) = diff(f1,temp(i));
end
jieGuo = solve(temp);
jieGuo = struct2cell(jieGuo);
x = zeros(1,num);
for i = 1:num
    x(i) = double(jieGuo{i});
end
end