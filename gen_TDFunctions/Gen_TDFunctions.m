% Generate TDFunctions
clc
clear
angle = 30;   % in degree

%% laser parameters
Ix=1.5e14 * 2;
lambda=800;

ev_flag = 3; % 0 : 1; 1: sin2 ; 2:Trap ; 3:sin2+Trap
Tmax = 8;
Tup= 2 ;
dt=0.01;


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


%% Ponderomotive radius and Up/w0 (linear field)
RR = E0/omega/omega ;

Up = E0^2/4/omega/omega;

Up_div_w0 = 3.17*Up / omega;

str_date = date;
text = sprintf('The Ponderomotive radius (linear field) is: \n\n %f a.u. \n\n Up/w_0 = %f \n\n @ %s',RR,Up_div_w0,str_date);

fid0 = fopen('Ponderomotive.txt','w');
fprintf(fid0,text);

fclose(fid0);

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


%% ---------------- linearly polarization ------------------

% rotate the field
varphi=angle*pi/180;

ftx = E0*ft*cos(varphi);
fty = E0*ft*sin(varphi);

ftxi = 0.*t;    % imaginary part
ftyi = 0.*t;

% field
Ex=ftx.*cos(omega*t);
Ey=fty.*cos(omega*t);


 %% rotation the electric field around z axis ----------------
% theta1=90*pi/180;
% 
%  Ex=cos(theta1)*Ex1-sin(theta1)*Ey1;
%  Ey=sin(theta1)*Ex1+cos(theta1)*Ey1;

 
 %%  rotation the electric field around x axis ----------------

%% plot and check
figure;
subplot(221)
plot(t/T0,ftx,t/T0,fty); xlabel('t/T0'); ylabel('ft'); legend('x','y');

subplot(222)
plot(ftx,fty); xlabel('fx'); ylabel('fy');

subplot(223)
plot3(t/T0,Ex,Ey)
xlabel('t/T0'); ylabel('Ex'); zlabel('Ey');

subplot(224)
plot(Ex,Ey);
xlabel('Ex')
ylabel('Ey')
grid on;

saveas(gcf,'from_Gen_TDFunctions','png');
saveas(gcf,'from_Gen_TDFunctions','fig');

close;


%% --------- save envelope ------------------
t1=t';

% %
% fid1 = fopen('Envelope_x','w');
% for ii=1:Lt
%     fprintf(fid1,'%.12e   %.12e   %.12e\n',t1(ii),ftx(ii),ftxi(ii));
% end
% fclose(fid1);
% 
% fid2 = fopen('Envelope_y','w');
% for ii=1:Lt
%     fprintf(fid2,'%.12e   %.12e   %.12e\n',t1(ii),fty(ii),fty(ii));
% end
% fclose(fid2);

%% --------- save E(t) ------------------ 
Exi = 0.*t;
Eyi = 0.*t;

fid3 = fopen('Et_x','w');
for ii=1:Lt
    fprintf(fid3,'%.12e   %.12e   %.12e\n',t1(ii),Ex(ii),Exi(ii));
end
fclose(fid3);

fid4 = fopen('Et_y','w');
for ii=1:Lt
    fprintf(fid4,'%.12e   %.12e   %.12e\n',t1(ii),Ey(ii),Eyi(ii));
end
fclose(fid4);
