% This is fast and good~
% extract the data from the .cube file
% the inporated data are named data

clc
clear

%% input
str_title = 'px.xsf';
natom = 1;                 % number of atom

isovalue = 0.05;

%% read file
Nhead = 9+natom;

D=importdata(str_title,' ',Nhead);
data = D.data;
head = D.textdata;

%% read the parameters from the head
begin_gridinfo = 5+natom;

% number of grids, like  "101    121     81"
head0 = head(begin_gridinfo);

templine = split(head0);
Nwords = length(templine);

Nx = str2double(templine{Nwords-2})   % use {} instead of () for cell !!
Ny = str2double(templine{Nwords-1})
Nz = str2double(templine{Nwords})   

% xmax
head2 = head(begin_gridinfo+2);

templine = split(head2);
Nwords = length(templine);
Rx = str2double(templine{Nwords-2})/2      % don't forget /2

% ymax
head3 = head(begin_gridinfo+3);

templine = split(head3);
Nwords = length(templine);
Ry = str2double(templine{Nwords-1})/2

% zmax
head4 = head(begin_gridinfo+4);

templine = split(head4);
Nwords = length(templine);
Rz = str2double(templine{Nwords})/2

% x,y,z and dx,dy,dz
x = linspace(-Rx,Rx,Nx);
y = linspace(-Ry,Ry,Ny);
z = linspace(-Rz,Rz,Nz);

dx = 2*Rx/(Nx-1)
dy = 2*Ry/(Ny-1)
dz = 2*Rz/(Nz-1)

%% check the number of data
if Nx*Ny*Nz ~= length(data)
    error('Nx*Ny*Nz ~= length(data) !!');
end

%% data to the matrix

% # The data of .xsf is organized as:
% # C-syntax:
% #  for (k=0; k<nz; k++)
% #  for (j=0; j<ny; j++)
% #  for (i=0; i<nx; i++)
% #  printf("%f",value[i][j][k]);
% 
% # So it change x value first, then y, then z.
% # Note that, in matlab, the m-th row corresponds to y=m, the n-th column corresponse to x=n
% # I would like to make the matrxi like that in Matlab

psi_xyz = reshape(data,Nz,Ny,Nx);    % the order of dimentions may be wrong !!!!

% % we need to swap x and y
psi_xyz = permute(psi_xyz,[2,1,3]);

norm =  sum(sum(sum( abs(psi_xyz).^2 ))) .* dx*dy*dz
% norm =  sum(sum(sum( psi_xyz ))) .* dx*dy*dz/(0.53)^3 

%%%%% plot and save %%%%%
figure; pcolor( x,y,psi_xyz( :,:,round(Nz/2)-10 ) ); 
xlabel('x')
ylabel('y')
shading interp;
saveas(gcf,'plot_xy.png')

figure; isosurface(x,y,z,(psi_xyz),isovalue); hold on;  isosurface(x,y,z,(psi_xyz),-isovalue); hold off;
xlabel('x')
ylabel('y')
zlabel('z')
alpha(0.5)
saveas(gcf,'surface_3D.png')

save my_psi_xyz.mat psi_xyz norm   % textdata;
