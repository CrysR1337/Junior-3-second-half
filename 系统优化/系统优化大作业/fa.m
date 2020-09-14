clear;clc;close all;
%% ���ͷ�������-��ʽԼ��
syms x1 x2
f=3*x1.^2+2*x2.^2;
hx=[x1+x2-3];%��
 
x0=[3;0];
M=0.01;
C=2;
eps=1e-6;
[x,result]=waidian_EQ(f,x0,hx,M,C,eps)
 
function [x,result]=waidian_EQ(f,x0,hx,M,C,eps)
% f Ŀ�꺯��
% x0 ��ʼֵ
% hx Լ������
% M ��ʼ������
% C �����ӷŴ�ϵ��
% eps �ݲ�
 
%����ͷ���
CF=sum(hx.^2);  %chengfa
 
while 1
    F=matlabFunction(f+M*CF);%Ŀ�꺯����ʹ��֮ǰ��ţ�ٷ�����Ҫת���ɾ��
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
%ţ�ٷ�
function [X,result]=Min_Newton(f,x0,eps,n)
%fΪĿ�꺯��
%x0Ϊ��ʼ��
%epsΪ��������
%nΪ��������
TiDu=gradient(sym(f),symvar(sym(f)));% ������ݶȱ��ʽ
Haisai=jacobian(TiDu,symvar(sym(f)));
Var_Tidu=symvar(TiDu);
Var_Haisai=symvar(Haisai);
Var_Num_Tidu=length(Var_Tidu);
Var_Num_Haisai=length(Var_Haisai);
TiDu=matlabFunction(TiDu);
flag = 0;
if Var_Num_Haisai == 0  %Ҳ����˵���������ǳ���
    Haisai=double((Haisai));
    flag=1;
end
%��ǰ���ݶ��뺣���������
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
        disp('����󲻴��ڣ�');
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
disp('�޷�������');
X=[];
result=[];
end