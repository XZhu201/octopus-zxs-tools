% put the codes in a subdirectory of the main directory that contains inp

% density_hole = density_0 - denstity_t

% The code also calculates the difference between the td density and the td
% density at t=0:  rho_diff = rho_t - rho_t0

% call f_readcube_volume.m & fig2mov.m

mkdir svMovie

%% input
list_num = 0:15:60 ;     % list of index number to be read
Nhead = 12 ;

isovalue = 0.1;
isovalue_hole = 0.01;
isovalue_diff = 0.005;

str_filename = 'density.cube';    % name of the file to load

%% parallel computation
pc = parcluster('local');
disp('Information of local parcluster:')
disp(pc); 

try
    parpool(pc.NumWorkers);
catch ME
    fprintf('Error from try: %s \n',ME.message);
end

%% load the time
str_title = '../td.general/laser';
D = importdata(str_title,' ',6);
data = D.data;

t = data(:,2);
clear D data;

%% read the initial density den_0
str_title = ['../static/', str_filename];

[x,y,z,rho_0] = f_readcube_volume(str_title, Nhead);

figure; isosurface(x,y,z,rho_0,isovalue); hold on;  isosurface(x,y,z,rho_0,-isovalue); hold off;
xlabel('x')
ylabel('y')
zlabel('z')
alpha(0.5)
colorbar
colormap(jet)
xlim([-15 15]); ylim([-15 15]); zlim([-15 15]);
saveas(gcf,'./svMovie/surface_3D.png')
close all;

%% read the td density at t=0
str_title = sprintf('../output_iter/td.%07d/%s',0,str_filename)

[~,~,~,rho_t0] = f_readcube_volume(str_title, Nhead);      % save as rho_t0


%% read the td density and calculate the hole density, output figure
Lt = length(list_num);


parfor n=1:Lt
% for n=1:Lt

    frameNo = list_num(n);
    str_title = sprintf('../output_iter/td.%07d/%s',frameNo,str_filename);
    
    [~,~,~,rho_t] = f_readcube_volume_v2(str_title, Nhead);
    
    hole = rho_0 - rho_t;
    
    
   % difference between t=t and t=0
   rho_diff = rho_t - rho_t0;
    
    % save figure of hold dynamics
    figure; isosurface(x,y,z,hole,isovalue_hole); hold on;  isosurface(x,y,z,hole,-isovalue_hole); hold off;
    xlabel('x')
    ylabel('y')
    zlabel('z')
    alpha(0.5)
    colorbar
    colormap(jet)
    xlim([-5 5]); ylim([-5 5]); zlim([-5 5]); 
    title(['t=',num2str(t(frameNo+1))])        % +1 because the index of t begins from 0
    
    str_savetitle = ['./svMovie/hole',num2str(frameNo)];    
    saveas(gcf,str_savetitle,'jpg')
    close all;
    
   % save figure of density difference
   figure; isosurface(x,y,z,rho_diff,isovalue_diff); hold on;  isosurface(x,y,z,rho_diff,-isovalue_diff); hold off;
   xlabel('x')
   ylabel('y')
   zlabel('z')
   alpha(0.5)
   colorbar
   colormap(jet)
   xlim([-5 5]); ylim([-5 5]); zlim([-5 5]); 
   title(['t=',num2str(t(frameNo+1))])
    
   str_savetitle = ['./svMovie/dens_diff',num2str(frameNo)];
   saveas(gcf,str_savetitle,'jpg')
   close all;

end % end of for

%% make movie
% movie for the hold density
fig2mov(list_num,'./svMovie/hole','.jpg');

% movie for the density difference
fig2mov(list_num,'./svMovie/dens_diff','.jpg');
