clc
clear
 
%%%%%%%%%%%%%%%%% �Ż�����Ĳ����趨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=2;%����ά����Ҳ�����Ա����ĸ���������������˵��n

Numg=4; %Լ������Ŀ������������˵��m

KD=N+1;%�����ζ�����Ŀ��ֻҪ��N+1~2N֮����У�����Ͳ���ȥ�޸��ˣ�
x0=[-0.9;-0.5];%��ʼ�㣬����Ҫ��������Լ���������������ԣ�����ȷ���������������У����ԱȽ����׵��ҵ������ĳ�ʼ��

x1(1)=-0.9;
x2(1)=-0.5;

AB=[-1 1;
    -1 1]; %�Ա����Ĺ������䡣�������ҵ�����Ҫ��ĳ�ʼ��x0���Լ������һ���Ա����Ĺ������䣬���磺6������[5��10]�ڡ�

ebsn1=1e-6;%%���ȣ����Զ����


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ϊֹ�����϶����û��Լ����壬�������ĳ����������޸��ˣ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%% ��ʼ����%%%%%%%%%%%%%%%%%%%%%%


       
   gx=yueshu_g(x0);
   if(max(gx)>0);   %���������Լ������
       'error,��ʼ��x0Ϊ��㣡��';
       return;
   end;
% ����KD������ĸ�����
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
 


      

'ok ��ʼ����������';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ʼ

error1=100;



k=1;
 while(error1>ebsn1)
    
   
    k=k+1;
  % �Ƚϸ�������ĺ���ֵ���ҳ���С�ĺ�����
  
  for j=1:KD
      xj=XFU(:,j);
      FX(j)=fun2(xj);
  end

     [fLx,n_xL]=min(FX);
     [fHx,n_xH]=max(FX);%�ҳ���С������ֵ��Ӧ�ĺ���ֵ �����
     
     XL=XFU(:,n_xL);  %�����ε����ŵ�
     
     x_opt=XFU(:,n_xL);
     fx_opt=FX(n_xL);
     
     
     if (mod(k,20)==0)%ÿ����20�Σ����һ�ν��
         k
     '��ǰ���Ž⣺'  
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
     end;% �����ж�
 
    
     
     %% ��ȥ�� ��� ��� ���ģ�   
     Xc=x0;
     Xc(:)=0;
     
  for j=1:KD
     if (j<n_xH || j>n_xH); 
         Xc=Xc+XFU(:,j);
     end; %������Xc
  end
     Xc=Xc/(KD-1);
     gx_XC=yueshu_g(Xc);
       
     
     
  if(max(gx_XC)>0)%�����ȥ��� ������ �ڿ��������棬�������γɸ����Σ�������б��μ���
      
      AB(:,1)=XL;
      AB(:,2)=Xc;  %�滻��Ʊ������½�
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

     %'�����'
     alpha=1.3;
     while (alpha>1.0e-8)
       alpha;
       XR=Xc+alpha*(Xc-XFU(:,n_xH));
       gx_XR=yueshu_g(XR);
       f_XR=fun2(XR);
       if(max(gx_XR)>0 || f_XR>fHx); %�������㲻���� ���� ����㺯��ֵ��ԭ��㺯��ֵ ��Ҫ�����С��������
           alpha=0.5*alpha;%��С��������
       else
           break;%
       end; 
     end
   
      %% ��� ���䷽�����Ҳ��� ������С�ĵ㣬����ķ��䷽�� 
     if (alpha<1.0e-8)
         FXP=FX;FXP(n_xH)=fLx; %�����µĺ������飬��ԭ����FX�е����ֵȥ�����Ա�Ѱ�� �ڶ����ֵ
         [fGx,n_xG]=max(FXP);%�ҳ��λ��� 
         Xc(:)=0; %% �����ģ�ȥ�� ��� 
         for j=1:KD
             if (j<n_xG || j>n_xG);
                 Xc=Xc+XFU(:,j);
             end; %��ȥ���λ���֮�������XC
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
        else  %'��λ���ķ����'
           alpha=1.3;
           while (alpha>1.0e-8)
              XR=Xc+alpha*(Xc-XFU(:,n_xH));
              gx_XR=yueshu_g(XR);
              f_XR=fun2(XR);
              if(max(gx_XR)>0 || f_XR>fHx); %�������㲻���л��� ����㺯��ֵ�� ԭ��㺯��ֵ��Ҫ�����С��������
                 alpha=0.5*alpha;%��С��������
              else
                break;%
              end;
           end 
        end
        

     end
       
  end
     
   XFU(:,n_xH)=XR;
   
       if k>10000;
           'ǿ����ֹ';
           break;
       end;
 end


k;




    
  '���Ž�Ϊ��x*'
 x_opt=XL
  '����ֵΪ�� f(x*)'
 fx_opt=fun2(XL)
 
 

    figure;
    plot(x1,x2);
    
function gx=yueshu_g(X)
% ����ʽԼ������������������˵��gi(x1,x2,...,xn)�����Ǹ�������ʵ�������Ҫ�޸ĵġ�
 
gx=[ -1-X(1);
    -1-X(2);
    X(1)-1;
    X(2)-1;];
end

function F=fun2(xk)
% Ŀ�꺯��������������˵��f(x1,x2,...,xn)�����Ǹ�������ʵ�������Ҫ�޸ĵġ�
  

F=(xk(2)-xk(1))^4+12*xk(1)*xk(2)-xk(1)+xk(2)-3;
end
    