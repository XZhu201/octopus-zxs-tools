clear all;

Dimension =3; % 空间维数而不是周期性维数
w0 = 45.6/3000;
total_xyz = 1; % total:0; xyz:1





Curx = 0; Cury=0; Curz=0;
%%  读取数据
% 读取total_current文件
if Dimension == 1
    [Iter,t,Curx,Inx] = textread('total_current','%f%f%f%f','delimiter', '','headerlines', 4);
elseif Dimension == 2
    [Iter,t,Curx,Cury,Inx,Iny] = textread('total_current','%f%f%f%f%f%f','delimiter', '','headerlines', 4);
elseif Dimension == 3
    [Iter,t,Curx,Cury,Curz,Inx,Iny,Inz] = textread('total_current','%f%f%f%f%f%f%f%f','delimiter', '','headerlines', 4);
end
Size_x = length(Curx);
Cury=Cury.*ones(Size_x,1); Curz=Curz.*ones(Size_x,1);

% 读取laser文件(里面是矢势)并画出
data = importdata('.\laser');
laser = data.data;
[SIZE1,SIZE2] = size(laser);
t_A = laser(:,2)*w0/2/pi;
A = zeros(SIZE1,SIZE2); % 矢势数组
for i = 1:SIZE2-2;
   A(:,i)= laser(:,2+i);
end
clear laser data; %清除中间数据，节约内存
fprintf('plot vector potential\n');
figure; %矢势的编号从1开始
plot(t_A,A(:,1),'LineWidth',2.0,'Color','r');
set(gca,'FontName','Helvetica','FontSize',14,'FontWeight','bold');
set(gcf,'Color','w')
title('Vector Potential','FontSize',16,'FontWeight','bold');
xlabel('Time (optical cycle)','FontSize',14,'FontWeight','bold');
ylabel('A_t','FontSize',14,'FontWeight','bold');
hold on;
saveas(gcf,'VectorPotential.fig');  %save语句
    
    
    %%  处理数据
    dt = t(2)-t(1);%时间分辨率
    Curx_dif = gradient(Curx,dt);
    Cury_dif = gradient(Cury,dt);
    Curz_dif = gradient(Curz,dt);
       
        Curxfft = fft(Curx)*dt; 
        Curyfft = fft(Cury)*dt; 
        Curzfft = fft(Curz)*dt;     
        
        Curx_dif_fft = fft(Curx_dif)*dt; 
        Cury_dif_fft = fft(Cury_dif)*dt; 
        Curz_dif_fft = fft(Curz_dif)*dt; 
    
    hhg_x = abs(Curxfft).^2;
    hhg_x_dif = abs(Curx_dif_fft).^2;   
    hhg_y = abs(Curyfft).^2;
    hhg_y_dif = abs(Cury_dif_fft).^2;
    hhg_z = abs(Curzfft).^2;
    hhg_z_dif = abs(Curz_dif_fft).^2;        
   
    
    dw = 2*pi/max(t);

    N = length(Curxfft);   
    if  mod(N,2)~=0
        N = N + 1;
    end  
    wmax = 2*pi/dt;
    wmax=wmax/2;
    w = 0:dw:(N/2-1)*dw;
    
    hhg_x = hhg_x(1:N/2);
    hhg_x_dif = hhg_x_dif(1:N/2);
    hhg_y = hhg_y(1:N/2);
    hhg_y_dif = hhg_y_dif(1:N/2);
    hhg_z = hhg_z(1:N/2);
    hhg_z_dif = hhg_z_dif(1:N/2);
    
    hhg_xyz = hhg_x + hhg_y+ hhg_z;
    hhg_xyz_dif = hhg_x_dif + hhg_y_dif + hhg_z_dif;
    
   %%  
   if total_xyz ==0
        figure;semilogy(w/w0,((hhg_xyz)),'b');   xlim([0,70]); saveas(gcf,'hhg_total.fig');
        figure;semilogy(w,((hhg_xyz)),'b');  xlim([0,1]); saveas(gcf,'hhg_total_au.fig');
        figure;semilogy(w*27.211,((hhg_xyz)),'b');  xlim([0,30]); saveas(gcf,'hhg_total_eV.fig');
        
        figure;semilogy(w/w0,((hhg_xyz_dif)),'b'); xlim([0,70]); saveas(gcf,'hhg_total_dif.fig');
        figure;semilogy(w,((hhg_xyz_dif)),'b');  xlim([0,1]); saveas(gcf,'hhg_total_dif_au.fig');
        figure;semilogy(w*27.211,((hhg_xyz_dif)),'b');  xlim([0,30]); saveas(gcf,'hhg_total_dif_eV.fig');
    
   elseif total_xyz ==1       
        figure;semilogy(w/w0,((hhg_x)),w/w0,((hhg_y)),w/w0,((hhg_z)),w/w0,((hhg_xyz)));   xlim([0,70]); saveas(gcf,'hhg_xyz.fig');
        figure;semilogy(w,((hhg_x)),w,((hhg_y)),w,((hhg_z)),w,((hhg_xyz)));   xlim([0,70]); saveas(gcf,'hhg_xyz_au.fig');
        figure;semilogy(w*27.211,((hhg_x)),w*27.211,((hhg_y)),w*27.211,((hhg_z)),w*27.211,((hhg_xyz)));   xlim([0,70]); saveas(gcf,'hhg_xyz_eV.fig');
      
        figure;semilogy(w/w0,((hhg_x_dif)),w/w0,((hhg_y_dif)),w/w0,((hhg_z_dif)),w/w0,((hhg_xyz_dif)));   xlim([0,70]); saveas(gcf,'hhg_xyz_dif.fig');
        figure;semilogy(w,((hhg_x_dif)),w,((hhg_y_dif)),w,((hhg_z_dif)),w,((hhg_xyz_dif)));   xlim([0,70]); saveas(gcf,'hhg_xyz_dif_au.fig');
        figure;semilogy(w*27.211,((hhg_x_dif)),w*27.211,((hhg_y_dif)),w*27.211,((hhg_z_dif)),w*27.211,((hhg_xyz_dif)));   xlim([0,70]); saveas(gcf,'hhg_xyz_dif_eV.fig');
   end
    
    T0 = 2*pi/w0;
    figure;plot(t/T0,Curx,t/T0,Cury);
    saveas(gcf,'current.fig');
    
    
    save ReadCurrent