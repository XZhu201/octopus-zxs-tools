D = importdata('acceleration',' ',5);
acceleration = D.data;

DD = importdata('laser');
laser = DD.data;

% ------------------------2D-----------------------------------

N = length(acceleration(1:end,3));
str = 'H_2-2D-0deg-para-';
if  mod(N,2)~=0
    N = N + 1
end
w0 =  0.4305/6
t =  multipoles(1:end,2);        
dt= t(2)-t(1);

Ex = laser(1:end, 3);

accelerationx = acceleration(1:end,3);
accelerationy = acceleration(1:end,4);
accelerationxfft = fft(accelerationx)*dt;
accelerationyfft = fft(accelerationy)*dt;
accelerationfft = abs(accelerationxfft).^2+abs(accelerationyfft).^2;


figure;     % 画电场
plot(t, Ex);
title(strcat(str,'laser'))



figure;     % 画的偶极加速度
plot(t,accelerationx,t,accelerationy);
title(strcat(str,'acceleration-plot'));

wmax=2*pi/dt;
wmax=wmax/2;
w=linspace(0,wmax,N/2);
accelerationfft=accelerationfft(1:N/2);


figure;     % 画谐波谱
semilogy(w,accelerationfft);
title(strcat(str,'td-fft-acceleration'));
% saveas(gcf,strcat(str,'td-fft-acceleration.fig'));
figure;
hold on
plot(laser(1:end,2)*w0/2/pi,laser(1:end,3));
%plot(laser(1:end,2)*w0/2/pi,laser(1:end,7),'r');


% figure;         % 时频分析需谨慎
% spectrogram(accelerationx,200, 90, w, max(w)*2, 'yaxis' );
% title(strcat(str,'td-spectrogram-y'));
% saveas(gcf,[strcat(str) 'td-spectrogram-y.fig']);

% figure;         % 时频分析需谨慎
% subplot(211);
% plot(laser(1:end,2)*w0/2/pi,laser(1:end,3));
% subplot(212);
% spectrogram(accelerationx,200, 90, w, max(w)*2, 'yaxis' );