function [xo, fo] = MinValue_Gold(func, a, b, eps)
if nargin < 3
   error('输入参数不足！');
end
if nargin == 3
   eps = 1e-6;
end
% 初始情况
a1 = a + 0.382*(b - a);
a2 = a + 0.618*(b - a);
f1 = func(a1);
f2 = func(a2);
ite = 0;
while abs(b - a) >= eps
   if f1 < f2
      b = a2;
      a2 = a1;
      f2 = f1;
      a1 = a + 0.382*(b - a);
      f1 = func(a1);
   else
      a = a1;
      a1 = a2;
      f1 = f2;
      a2 = a + 0.618*(b - a);
      f2 = func(a2);
   end
   ite = ite + 1;
end
xo = 0.5*(a + b);
fo = func(xo);