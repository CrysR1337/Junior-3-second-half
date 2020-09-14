A=[1 -1;1 1];
b=[3 6]';
N=length(b);    %解向量的维数
fprintf('库函数计算结果：');
x=inv(A)*b      %库函数计算结果
x=zeros(N,1);%迭代近似向量
eps=0.0000001;%精度
r=b-A*x;d=r;
for k=0:N-1
    fprintf('第%d次迭代：',k+1);
    a=(norm(r)^2)/(d'*A*d)
    x=x+a*d
    rr=b-A*x;    %rr=r(k+1)
    if (norm(rr)<=eps)||(k==N-1)
        break;
    end
    B=(norm(rr)^2)/(norm(r)^2);
    d=rr-B*d;
    r=rr;
end