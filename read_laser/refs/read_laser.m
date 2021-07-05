
w0 = 0.057;
T = 2*pi/w0;

D = importdata('laser');
data = D.data;

t = data(:,2);
Ex = data(:,3);
Ey = data(:,7);

figure;
subplot(211)
plot(t/T, Ex, t/T, Ey);
subplot(212)
plot3(t/T, Ex, Ey);

