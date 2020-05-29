% %% xDAWN�㷨ʵ��
% % x = D*A*W+N
% % ����D����
% % x��QR�ֽ⣺x=Qx*Rx
% % �����Rx�����������Ǿ���ȡ�����ǲ��ֹ��ɷ���
% % D��QR�ֽ⣺D=Qd*Rd
% % ��MΪQd'*Qx������M��svd�ֽ�SVD
% % ȡu��v��ǰ3��
% % W = inv(Rx)*Si; 
% % A = inv(Rd)*Ui*Vi;
% % S = x*W
% %%test
% clc;
% clear all;
% close all;
% signal = rand(100,64);
% [outSignal,W,A]=xDAWN(signal,100,0,1,0.2,0.4,0.5,20);
%% xDAWN
% parameters��
%    'f'    ���źŵĲ���Ƶ��
%'starttime'����ʼʱ����Ӧ�̼������ʱ��
% 'endtime' ������ʱ����Ӧ�̼�����Ӧʱ��
%    'p'    ��Ti����ʼʱ��
%    't'    ��Ti�ĳ���ʱ��
%    'Ne'   ��evoke�Ĺ۲�ʱ��
%    'n'    ����n���ɷ�
% out��
% 'outSignal'���˲�����ź�
%    'W'    ���ռ��˲���
%    'A'    ��Ԥ���evoke�ź�
function [outSignal,W,A]=xDAWN(signal,f,starttime,endtime,p,t,Ne,n)
% N��ֵ��Ϊ����ֵ
N = n;
% signal = rand(100,64);%����Ƶ��100
x = signal;
%����x��qr�ֽ�
[Qx,Rx]=qr(x,0);
% D = createD(100,0,1,0.2,0.4,0.5);
D = createD(f,starttime,endtime,p,t,Ne);
%����D��qr�ֽ�
[Qd,Rd]=qr(D,0);
M = Qd'*Qx;
% M��svd������ֵ������ǽ���
[U,V,S]=svd(M);
% ȡǰn��ֵ��Ϊ����ֵ
Ui = U(:,1:N);
Si = S(:,1:N);
Vi = V(1:N,1:N);
% �����˲���W�͹���evoke�ź�A
% W = Rx'*Si;�������д���
W = inv(Rx)*Si;
A = inv(Rd)*Ui*Vi;
% �����˲��������ź�
outSignal = x*W;
end
%% ����D����
% parameters��
%    'f'    ���źŵĲ���Ƶ��
%'starttime'����ʼʱ����Ӧ�̼������ʱ��
% 'endtime' ������ʱ����Ӧ�̼�����Ӧʱ��
%    'p'    ��Ti����ʼʱ��
%    't'    ��Ti�ĳ���ʱ��
%    'Ne'   ��evoke�Ĺ۲�ʱ��
% out��
%    'D'    �������D����
function [D] = createD(f,starttime,endtime,p,t,Ne)
len = (endtime-starttime)*f;
tStart = p*f;
tEnd = tStart+t*f;
firstColumn = zeros(1,len);
for i=1:len
    if i>=tStart&&i<=tEnd
        firstColumn(i) = 1;
    end
end
%�����������Ⱦ���D
D = zeros(len,Ne*f);
D(:,1)=firstColumn';
for j=2:Ne*f
   for i=2:len
     D(i,j) = D(i-1,j-1);
   end
end
end

