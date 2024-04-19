%% input
index = 0:50:600 ;  %  0:50:77225

%% initialization
mkdir sv_snapshots_vks;      % figures are saved to this fold for further operation
Nindex = length(index);

%% run in loop
for nn = 1:Nindex
      
    formatSpec  = 'output_iter/td.%07d/vxc.y=0,z=0' ;
    str_filename = sprintf(formatSpec, index(nn))
    
    DD = importdata(str_filename, ' ', 1);
    data = DD.data;
    
    x = data(:,1);
    den = data(:,2);
    
    figure;
    plot(x,den); xlabel('x [a.u.]'); ylabel('density');
    title(str_filename);
    
    str_save = sprintf('sv_snapshots_vks/td%07d', index(nn));
    saveas(gcf,str_save,'png');  
    
    close;
    
end % end of nn