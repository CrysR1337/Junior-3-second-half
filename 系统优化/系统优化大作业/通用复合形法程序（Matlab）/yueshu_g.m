function gx=yueshu_g(X)
% 不等式约束函数，就是帖子里说的gi(x1,x2,...,xn)，这是根据您的实际情况需要修改的。
 
gx=[ -1-X(1);
    -1-X(2);
    X(1)-1;
    X(2)-1;];