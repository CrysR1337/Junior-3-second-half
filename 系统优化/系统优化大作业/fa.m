clear;clc;close all;
%% 外点惩罚函数法-等式约束
syms x1 x2
f=3*x1.^2+2*x2.^2;
hx=[x1+x2-3];%列
 
x0=[3;0];
M=0.01;
C=2;
eps=1e-6;
[x,result]=waidian_EQ(f,x0,hx,M,C,eps)
 
function [x,result]=waidian_EQ(f,x0,hx,M,C,eps)
% f 目标函数
% x0 初始值
% hx 约束函数
% M 初始罚因子
% C 罚因子放大系数
% eps 容差
 
%计算惩罚项
CF=sum(hx.^2);  %chengfa
 
while 1
    F=matlabFunction(f+M*CF);%目标函数，使用之前的牛顿法，需要转换成句柄
    x1=Min_Newton(F,x0,eps,100);
    if norm(x1-x0)<eps
        x=x1;
        result=double(subs(f,symvar(f),x'));
        break;
    else
        M=M*C;
        x0=x1;
    end
end
end
%牛顿法
function [X,result]=Min_Newton(f,x0,eps,n)
%f为目标函数
%x0为初始点
%eps为迭代精度
%n为迭代次数
TiDu=gradient(sym(f),symvar(sym(f)));% 计算出梯度表达式
Haisai=jacobian(TiDu,symvar(sym(f)));
Var_Tidu=symvar(TiDu);
Var_Haisai=symvar(Haisai);
Var_Num_Tidu=length(Var_Tidu);
Var_Num_Haisai=length(Var_Haisai);
TiDu=matlabFunction(TiDu);
flag = 0;
if Var_Num_Haisai == 0  %也就是说海塞矩阵是常数
    Haisai=double((Haisai));
    flag=1;
end
%求当前点梯度与海赛矩阵的逆
f_cal='f(';
TiDu_cal='TiDu(';
Haisai_cal='Haisai(';
for k=1:length(x0)
    f_cal=[f_cal,'x0(',num2str(k),'),'];
    
    for j=1: Var_Num_Tidu
        if char(Var_Tidu(j)) == ['x',num2str(k)]
            TiDu_cal=[TiDu_cal,'x0(',num2str(k),'),'];
        end
    end
    
    for j=1:Var_Num_Haisai
        if char(Var_Haisai(j)) == ['x',num2str(k)]
            Haisai_cal=[Haisai_cal,'x0(',num2str(k),'),'];
        end
    end
end
Haisai_cal(end)=')';
TiDu_cal(end)=')';
f_cal(end)=')';
switch flag
    case 0
        Haisai=matlabFunction(Haisai);
        dk='-eval(Haisai_cal)^(-1)*eval(TiDu_cal)';
    case 1
        dk='-Haisai^(-1)*eval(TiDu_cal)';
        Haisai_cal='Haisai';
end
i=1;
while i < n 
    if abs(det(eval(Haisai_cal))) < 1e-6
        disp('逆矩阵不存在！');
        break;
    end
    x0=x0(:)+eval(dk);
    if norm(eval(TiDu_cal)) < eps
        X=x0;
        result=eval(f_cal);
        return;
    end
    i=i+1;
end
disp('无法收敛！');
X=[];
result=[];
end