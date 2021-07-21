function [x,y,z,rho] = readcube_volume_v2( str_title, Nhead )

% This is fast and good~
% extract the data from the .cube file
% the inporated data are named data


% frameNo identifies which td results to be red

% extract the data from the .cube file
% the inporated data are named data

%% prepare file name
% str_title = 'density.cube';
% Nhead = 12;
% isovalue = 0.05;

%% avoid xx-xxx
% there is a bug in the output of .cube, xxE-101 could be written as xx-101
% https://blog.csdn.net/u013249853/article/details/101440962?utm_term=matlab%E4%B8%80%E8%A1%8C%E4%B8%80%E8%A1%8C%E8%AF%BB%E5%8F%96%E5%AD%97%E7%AC%A6&utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduweb~default-2-101440962&spm=3001.4430

fid = fopen(str_title);

nline = 0;
data = [];    % initialize the matrix data

fprintf('Reading file [%s] ... \n',str_title);

while(true)
    nline = nline + 1;
    tline = fgetl(fid);
    
    if ~ischar(tline)   % at the end of the file
        break;
    end
    
    if nline>Nhead          % skip the headlines, and work on the data
%                 disp(tline)
        
        if length(tline)<84     % if the line has 6 numbers, not only 1 number
            tline = [tline,repmat(' ',1,84-length(tline))];
        end
        
        if tline(81) ==  '-'
            tline(81:84) = 'E-99';
        end  % end of tline
        
        if tline(67) ==  '-'
            tline(67:70) = 'E-99';
        end  % end of tline
        
        if tline(53) ==  '-'
            tline(53:56) = 'E-99';
        end  % end of tline
        
        if tline(39) ==  '-'
            tline(39:42) = 'E-99';
        end  % end of tline
        
        if tline(25) ==  '-'
            tline(25:28) = 'E-99';
        end  % end of tline
        
        if tline(11) ==  '-'
            tline(11:14) = 'E-99';
        end  % end of tline
        
%         disp(tline);
        
        
        % transfer the str to number
        new_data = str2num(tline);
        
        if length(new_data)<6
%             new_data = [new_data, zeros(1,6-length(new_data))];
            new_data = [new_data, nan(1,6-length(new_data))];
        end
        
        data = [data; new_data];
%         disp(new_data)
        
    end % end of if nline>Nhead

end % end of while

fclose(fid);

%% read file
% for v2, read for head only
D=importdata(str_title,' ',Nhead);
data_check = D.data;
head = D.textdata;

%% read the parameters from the head
% for x,y,z_min
templine = split(head(3));
Nwords = length(templine);

xmin = str2double(templine{Nwords-2}) ;   % use {} instead of () for cell !!
ymin = str2double(templine{Nwords-1}) ;
zmin = str2double(templine{Nwords})  ;   

% for Nx,dx
templine = split(head(4));
Nwords = length(templine);
Nx = str2double(templine{Nwords-3}) ;
dx = str2double(templine{Nwords-2}) ;

% for Ny,dy
templine = split(head(5));
Nwords = length(templine);
Ny = str2double(templine{Nwords-3}) ;
dy = str2double(templine{Nwords-1}) ;

% for Nz,dz
templine = split(head(6));
Nwords = length(templine);
Nz = str2double(templine{Nwords-3}) ;
dz = str2double(templine{Nwords}) ;

disp('xmin,Nx,dx;ymin,Ny,dy;zmin,Nz,dz='),disp([xmin,Nx,dx;ymin,Ny,dy;zmin,Nz,dz])

% generate the grid
x = xmin : dx : xmin+(Nx-1)*dx ;                
y = ymin : dy : ymin+(Ny-1)*dy ;                
z = zmin : dz : zmin+(Nz-1)*dz ;                



%%%%% 在转为3D矩阵 %%%%%
rho = zeros(Nx,Ny,Nz);
m = 0;
disp('to 3D ...');
for i = 1:Nx
    for j = 1:Ny        
        for k = 1:Nz
            %%%
            m = m+1 ;       
            
            rr = fix( (m-1)/6 )+1 ;
            ll = mod(m-1,6)+1 ;
            dd = data(rr,ll) ;
            
            while ( isnan(dd) )       
                m = m+1 ;   % 不必担心m超出数据个数，因为在最后一个循环首先读到的必然是最后一个有效数据，而不是NaN
                            % 在实际使用中，发现还是需要通过判断跳过一些点
                
                rr = fix( (m-1)/6 )+1 ;
                ll = mod(m-1,6)+1 ;
                dd = data(rr,ll) ;
            end
            
            rho(i,j,k) = dd;

            %%%
        end
    end
end

norm_den =  sum(sum(sum( rho ))) .* dx*dy*dz ;
disp('sum of density='),disp(norm_den)



