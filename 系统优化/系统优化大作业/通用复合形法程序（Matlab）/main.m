clc
clear
 
%%%%%%%%%%%%%%%%% 优化计算的参数设定%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=2;%问题维数，也就是自变量的个数，就是帖子里说的n

Numg=4; %约束的数目，就是帖子里说的m

KD=N+1;%复合形顶点数目（只要在N+1~2N之间就行，这里就不用去修改了）
x0=[-0.9;-0.5];%初始点，必须要满足所有约束条件！！！所以，请先确保：在您的问题中，可以比较容易地找到这样的初始点

x1(1)=-0.9;
x2(1)=-0.5;

AB=[-1 1;
    -1 1]; %自变量的估计区间。这是在找到符合要求的初始点x0后，自己定义的一个自变量的估计区间，例如：6在区间[5，10]内。

ebsn1=1e-6;%%精度，是自定义的


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%到此为止，以上都是用户自己定义，接下来的程序无需再修改了！！%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%% 开始计算%%%%%%%%%%%%%%%%%%%%%%


       
   gx=yueshu_g(x0);
   if(max(gx)>0);   %如果不满足约束条件
       'error,初始点x0为外点！！';
       return;
   end;
% 生成KD个顶点的复合形
 XFU=x0;
 
 for j=2:KD
     wai=1.0;
     while(wai>0)
       for i=1:N
         XFU(i,j)=AB(i,1)+rand(1,1)*(AB(i,2)-AB(i,1));
       end
       xj=XFU(:,j);
       gx=yueshu_g(xj);
       if(max(gx)<=0);
           wai=-1;
       end;
     end
 end
 


      

'ok 初始复合形正常';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%迭代开始

error1=100;



k=1;
 while(error1>ebsn1)
    
   
    k=k+1;
  % 比较各个顶点的函数值，找出最小的和最大的
  
  for j=1:KD
      xj=XFU(:,j);
      FX(j)=fun2(xj);
  end

     [fLx,n_xL]=min(FX);
     [fHx,n_xH]=max(FX);%找出最小、大函数值对应的函数值 与号码
     
     XL=XFU(:,n_xL);  %复合形的最优点
     
     x_opt=XFU(:,n_xL);
     fx_opt=FX(n_xL);
     
     
     if (mod(k,20)==0)%每迭代20次，输出一次结果
         k
     '当前最优解：'  
     x_opt=XFU(:,n_xL)
     fx_opt=FX(n_xL)
     end
     
     x1(k)=x_opt(1);
     x2(k)=x_opt(2);
     
     ee=0;
     for j=1:KD
       ee=ee+(FX(j)-fLx)^2;
     end
     error1=sqrt(1.0/(KD-1)*ee);
     if error1<ebsn1;
         break;
     end;% 收敛判断
 
    
     
     %% 求去除 最坏点 后的 形心，   
     Xc=x0;
     Xc(:)=0;
     
  for j=1:KD
     if (j<n_xH || j>n_xH); 
         Xc=Xc+XFU(:,j);
     end; %求形心Xc
  end
     Xc=Xc/(KD-1);
     gx_XC=yueshu_g(Xc);
       
     
     
  if(max(gx_XC)>0)%如果除去最坏点 的形心 在可行域外面，则重新形成复合形，否则进行变形计算
      
      AB(:,1)=XL;
      AB(:,2)=Xc;  %替换设计变量上下界
     for j=1:KD
       wai=1.0;
       while(wai>0)
         for i=1:N
           XFU(i,j)=AB(i,1)+rand(1,1)*(AB(i,2)-AB(i,1));
         end
         xj=XFU(:,j);
         gx=yueshu_g(xj);
         if(max(gx)<=0);wai=-1;end;
       end
     end
    
  else

     %'求反射点'
     alpha=1.3;
     while (alpha>1.0e-8)
       alpha;
       XR=Xc+alpha*(Xc-XFU(:,n_xH));
       gx_XR=yueshu_g(XR);
       f_XR=fun2(XR);
       if(max(gx_XR)>0 || f_XR>fHx); %如果反射点不可行 或者 反射点函数值比原最坏点函数值 还要大，则减小反射因子
           alpha=0.5*alpha;%缩小反射因子
       else
           break;%
       end; 
     end
   
      %% 如果 反射方向上找不到 函数更小的点，则更改反射方向 
     if (alpha<1.0e-8)
         FXP=FX;FXP(n_xH)=fLx; %定义新的函数数组，将原数组FX中的最大值去掉，以便寻找 第二大的值
         [fGx,n_xG]=max(FXP);%找出次坏点 
         Xc(:)=0; %% 求形心，去除 最坏点 
         for j=1:KD
             if (j<n_xG || j>n_xG);
                 Xc=Xc+XFU(:,j);
             end; %求去掉次坏点之后的形心XC
         end
         Xc=Xc/(KD-1);
       
         gx_XC=yueshu_g(Xc);
        if(max(gx_XC)>0);
           AB(:,1)=XL;
           AB(:,2)=Xc;
           for j=1:KD
              wai=1.0;
            while(wai>0)
              for i=1:N
                XFU(i,j)=AB(i,1)+rand(1,1)*(AB(i,2)-AB(i,1));
              end
              xj=XFU(:,j);
              gx=yueshu_g(xj);
              if(max(gx)<=0);wai=-1;end;
            end
           end
        else  %'求次坏点的反射点'
           alpha=1.3;
           while (alpha>1.0e-8)
              XR=Xc+alpha*(Xc-XFU(:,n_xH));
              gx_XR=yueshu_g(XR);
              f_XR=fun2(XR);
              if(max(gx_XR)>0 || f_XR>fHx); %如果反射点不可行或者 反射点函数值比 原最坏点函数值还要大，则减小反射因子
                 alpha=0.5*alpha;%缩小反射因子
              else
                break;%
              end;
           end 
        end
        

     end
       
  end
     
   XFU(:,n_xH)=XR;
   
       if k>10000;
           '强行终止';
           break;
       end;
 end


k;




    
  '最优解为：x*'
 x_opt=XL
  '最优值为： f(x*)'
 fx_opt=fun2(XL)
 
 

    figure;
    plot(x1,x2);
    
function gx=yueshu_g(X)
% 不等式约束函数，就是帖子里说的gi(x1,x2,...,xn)，这是根据您的实际情况需要修改的。
 
gx=[ -1-X(1);
    -1-X(2);
    X(1)-1;
    X(2)-1;];
end

function F=fun2(xk)
% 目标函数，就是帖子里说的f(x1,x2,...,xn)，这是根据您的实际情况需要修改的。
  

F=(xk(2)-xk(1))^4+12*xk(1)*xk(2)-xk(1)+xk(2)-3;
end
    