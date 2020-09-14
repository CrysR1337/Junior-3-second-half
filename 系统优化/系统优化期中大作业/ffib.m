
function ffib
x0=1;
eps=1e-5;
syms x; 
fx=(2*x-1)^2+4*(4-1024*x)^4;
format long;
dfx=diff(fx); 
ddfx=diff(dfx);

tol=1;
k=0;

while tol>eps 
    %fprintf('第%d次迭代：',k);
    g=subs(dfx,symvar(dfx),x0);
    h=subs(ddfx,symvar(ddfx),x0);
    x1=x0-g/h;
    x1=vpa(x1,8);
    k=k+1;
    tol=abs(x1-x0);%tol=abs(dfx);
    x0=x1;
end 
disp('迭代次数：')
disp(k-1)
disp('结果如下：best_x =')
disp(x1)
disp(subs(fx,symvar(fx),x1))
format short;
end