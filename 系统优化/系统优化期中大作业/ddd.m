A=[1 -1;1 1];
b=[3 6]';
N=length(b);    %��������ά��
fprintf('�⺯����������');
x=inv(A)*b      %�⺯��������
x=zeros(N,1);%������������
eps=0.0000001;%����
r=b-A*x;d=r;
for k=0:N-1
    fprintf('��%d�ε�����',k+1);
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