w0 = 0.057;
T = 2*pi/w0;

D = importdata('laser',' ',6);
data = D.data;

t = data(:,2);
Ex = data(:,3)+data(:,6);
Ey = data(:,4)+data(:,7);

figure;
subplot(211)
plot(t/T, Ex, t/T, Ey);
subplot(212)
plot3(t/T, Ex, Ey);

