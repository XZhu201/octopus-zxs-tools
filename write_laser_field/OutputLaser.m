%Output laser
clc
clear
jiajiao = 45;


Ix=1.5e14;
lambda=800;

ev_flag = 3; % 0 : 1; 1: sin2 ; 2:Trap ; 3:sin2+Trap
Tmax = 7;
Tup= 1 ;
dt=0.05;



E0=sqrt(Ix)*1e-8/1.873766;
omega=2*pi*2.9979*2.418884/lambda;
T0=2*pi/omega;        % one optical cycel.
tmax=Tmax*T0;
%tmax=round(tmax/dt)*dt;
t=0:dt:tmax;
tup=Tup*T0;
 Lt = length(t);
%  if mod(Lt,2) == 1
%    Lt=Lt+1;
%    t=linspace(0,tmax,Lt);
%   dt=t(2)-t(1)
% else
%      t=linspace(0,tmax,Lt);
%  	 dt=t(2)-t(1)
%  end


%% Ponderomotive radius (linear field)
RR = E0/omega/omega

str_date = date;
text = sprintf('The Ponderomotive radius (linear field) is: \n\n %f a.u. \n\n @ %s',RR,str_date);

fid = fopen('Ponderomotive_radius.txt','w');
fprintf(fid,text)

%% 
switch ev_flag

    case 0
        ft = 1;
    case 1
        ft = sin(t*pi/tmax).^2;
    case 2
        ft = 1/tup*t.*(t<= tup)+(t>tup).*(t<(tmax-tup))+(1)/tup*(tmax-t).*(t>= (tmax-tup)).*(t<= tmax);
    case 3
        tdown=tmax-tup;
        ft = sin(t*pi/2/tup).^2.*(t<= tup)+(t>tup).*(t<(tmax-tup))+sin((t-tdown-tup)*pi/2/tup).^2.*(t>= (tmax-tup)).*(t<= tmax);
end
figure
plot(t/T0,ft)



%% ---------------- linearly polarization ------------------
varphi=jiajiao*pi/180;
Ex=cos(varphi)*E0*ft.*sin(omega*t);
Ey=sin(varphi)*E0*ft.*sin(omega*t);




% dft = gradient(ft,dt)
% figure
% plot(t/T0,dft);
% dft2 = del2(ft,dt);
% figure
% plot(t/T0,dft2)

% pha_x1 = 0;         % the initial phase,  unit: degree
% pha_x2 = 0;         % the initial phase,  unit: degree
% pha_y1 = -90*pi/180;       % the initial phase,  unit: degree
% pha_y2 = 90*pi/180;        % the initial phase,  unit: degree


% Ex1= (E0*cos(omega*t+pha_x1)+E0*cos(2*omega*t+pha_x2));
% Ey1= (E0*cos(omega*t+pha_y1)+E0*cos(2*omega*t+pha_y2));
% elli=0.25
% elly=elli/sqrt(1+elli^2);
% ellx=1/sqrt(1+elli^2);
% 
% Ex= ellx*ft.*E0.*sin(omega*t);
% Ey=elly*ft*E0.*cos(omega*t);
% Ex1= ft.*(E0*cos(omega*t)+E0*cos(2*omega*t));
% Ey1= ft.*(E0*sin(omega*t)-E0*sin(2*omega*t));




 %% rotation the electric field around z axis ----------------
% theta1=90*pi/180;
% 
%  Ex=cos(theta1)*Ex1-sin(theta1)*Ey1;
%  Ey=sin(theta1)*Ex1+cos(theta1)*Ey1;

 
 %%  rotation the electric field around x axis ----------------
 
 
 
 
 
 
 
 
figure
plot(t,Ex,t,Ey)


Exr= Ex;
Exi= 0*t;
Eyr = Ey;
Eyi = 0*t;
Ext_real = Exr';
Ext_imag = Exi';

Eyt_real = Eyr';
Eyt_imag = Eyi';

figure
plot3(t,Ext_real,Eyt_real)

figure
plot3(t/T0,Ext_real,Eyt_real)
ylabel('x')
zlabel('y')
% Ext=[t',Ext_real,Ext_imag];
% Eyt =[t',Eyt_real,Eyt_imag];

% save Ex_sin2Trap Ext -ascii -double
% save Ey_sin2Trap Eyt -ascii -double

t1=t';


%% --------- Ext ------------------
fid1 = fopen('ExField','w');
for ii=1:Lt
    fprintf(fid1,'%.12e   %.12e   %.12e\n',t1(ii),Ext_real(ii),Ext_imag(ii));
end
fclose(fid1)

%% --------- Eyt -----------------
fid2 = fopen('EyField','w');
for ii=1:Lt
    fprintf(fid2,'%.12e   %.12e   %.12e\n',t1(ii),Eyt_real(ii),Eyt_imag(ii));
end
fclose(fid2)

