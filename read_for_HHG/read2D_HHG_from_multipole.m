str_head = 'svFigs';
mkdir(str_head);

%% read data

D = importdata('multipoles',' ',16);
multipoles = D.data;

DD = importdata('laser');
laser = DD.data;

%
N = length(multipoles(1:end,3));
str = '';

if  mod(N,2)~=0
    N = N + 1
end

w0 = 45.6/800; 
T0 = 2*pi/w0;

t = multipoles(1:end,2);      
dt= t(2)-t(1);

Ex = laser(1:end, 3);
Ey = laser(1:end, 4);

figure;     % E(t)
subplot(121)
plot(t/T0, Ex, t/T0, Ey, '--');
legend('Ex','Ey');
xlabel('t/T')

title(strcat(str,'laser'))

subplot(122)
plot3(t/T0, Ex, Ey);
xlabel('t/T'); ylabel('Ex'); zlabel('Ey');
grid on;

saveas(gcf,'./svFigs/laser','fig')
saveas(gcf,'./svFigs/laser','png')

%% plot multiples
pol_x = multipoles(1:end,4);
pol_y = multipoles(1:end,5);

figure;     % dipole
subplot(121)
plot(t/T0, pol_x, t/T0, pol_y, '--');
legend('Ex','Ey');
xlabel('t/T')

title(strcat(str,'dipole'))

subplot(122)
plot3(t/T0, pol_x, pol_y);
xlabel('t/T'); ylabel('dipole x'); zlabel('dipole y');
grid on;

saveas(gcf,'./svFigs/dipole','fig')
saveas(gcf,'./svFigs/dipole','png')

%% acc in xy
acc_x = 4*del2(pol_x);
acc_y = 4*del2(pol_y);

figure;     % dipole
subplot(121)
plot(t/T0, acc_x, t/T0, acc_y, '--');
legend('acc x','acc y');
xlabel('t/T')

title(strcat(str,'acc'))

subplot(122)
plot3(t/T0, acc_x, acc_y);
xlabel('t/T'); ylabel('acc x'); zlabel('acc y');
grid on;

saveas(gcf,'./svFigs/acc','fig')
saveas(gcf,'./svFigs/acc','png')


%% acc in +-
acc_p = (acc_x - 1i*acc_y)/sqrt(2);
acc_m = (acc_x + 1i*acc_y)/sqrt(2);

figure;     % dipole
plot(t/T0, acc_p, t/T0, acc_m, '--');
legend('acc +','acc -');
xlabel('t/T')

title(strcat(str,'acc in +-'))

saveas(gcf,'./svFigs/acc_in_pm','fig')
saveas(gcf,'./svFigs/acc_in_pm','png')


%% HHS in xy
fft_x = fft(acc_x)*dt;  fft_x=fft_x(1:N/2);
fft_y = fft(acc_y)*dt;  fft_y=fft_y(1:N/2);

HHS_x = abs(fft_x).^2;  
HHS_y = abs(fft_y).^2;  
HHS = abs(fft_x).^2+abs(fft_y).^2;  

% grid of omega
wmax=2*pi/dt;
wmax=wmax/2;
w=linspace(0,wmax,N/2);

% plot
figure;     % »­Ð³²¨Æ×
semilogy(w/w0,HHS_x, w/w0, HHS_y, '--', w/w0, HHS, '-.');
title(strcat(str,'HHS in xy'));
legend('x','y','x+y');
xlim([0,60])
xlabel('Harmonic order')

saveas(gcf,'./svFigs/HHS_xy','fig')
saveas(gcf,'./svFigs/HHS_xy','png')

% ---- phase ----
phase_x = angle(fft_x)/pi;
phase_y = angle(fft_y)/pi;
diff = phase_x - phase_y;

figure;
plot(w/w0,phase_x, w/w0, phase_y, '--', w/w0, diff, '-.');
xlim([0,60]);
xlabel('Harmonic order')
ylabel('phase [\pi]')
title(strcat(str,'phase vs. \omega in xy'));
legend('x','y','diff');

saveas(gcf,'./svFigs/phase_w_xy','fig')
saveas(gcf,'./svFigs/phase_w_xy','png')


%% HHS in +-
fft_p = (fft_x - 1i*fft_y)/sqrt(2);
fft_m = (fft_x + 1i*fft_y)/sqrt(2);

HHS_p = abs(fft_p).^2;  
HHS_m = abs(fft_m).^2;  
HHS = abs(fft_p).^2+abs(fft_m).^2; 

% plot
figure;     % »­Ð³²¨Æ×
semilogy(w/w0,HHS_p, w/w0, HHS_m, '--', w/w0, HHS, '-.');
title(strcat(str,'HHS in +-'));
legend('+','-','+ & -');
xlim([0,60])

saveas(gcf,'./svFigs/HHS_xy','fig')
saveas(gcf,'./svFigs/HHS_xy','png')

% ---- phase ----
phase_p = angle(fft_p)/pi;
phase_m = angle(fft_m)/pi;
diff = phase_p - phase_m;

figure;
plot(w/w0,phase_p, w/w0, phase_m, '--', w/w0, diff, '-.');
xlim([0,60]);
xlabel('Harmonic order')
ylabel('phase [\pi]')
title(strcat(str,'phase vs. \omega in +-'));
legend('+','-','+ & -');

saveas(gcf,'./svFigs/phase_w_pm','fig')
saveas(gcf,'./svFigs/phase_w_pm','png')


%% sp
dw = w(2)-w(1);
Gabor_fft(w0,3,dt,dw,acc_x,0,80,'x');
Gabor_fft(w0,3,dt,dw,acc_y,0,80,'y');

Gabor_fft(w0,3,dt,dw,acc_p,0,80,'p');
Gabor_fft(w0,3,dt,dw,acc_m,0,80,'m');

%% save
save Ar.mat t w0 *_x *_y *_p *_m HHS