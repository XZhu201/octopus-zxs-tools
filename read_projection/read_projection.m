% put the codes in a "td.general"

% All the data are saved in the structure struct_proj

% About the use of "dynamic expression" with structure, see:
% https://ww2.mathworks.cn/help/matlab/matlab_prog/string-evaluation.html
% https://ww2.mathworks.cn/help/matlab/matlab_prog/generate-field-names-from-variables.html

clc
clear

%% input
str_file = 'projections';
Nhead = 23;

Lsp = 2;      % the number of spin, 1 or 2 (1 means spin unpolarized)
Lstate = 8;  % the number of states

NE = [1,1,1,0,0,0,0,0;
    1,1,1,1,0,0,0,0];       % the number of electrons initially ocuping in respective states;
                    % 1st row for sp1, 2nd row for sp2
                    % columns for different staates, lower to higher
                    
if size(NE,1) ~= Lsp
    disp('No. of rows of block_NE does not equal to the No. of spin !!');
    error('No. of rows of block_NE does not equal to the No. of spin !!');
end

if size(NE,2) ~= Lstate
    disp('No. of columns of block_NE does not equal to the No. of states !!');
    error('No. of columns of block_NE does not equal to the No. of states !!');
end

%% read file
D=importdata(str_file,' ',Nhead);
data = D.data;
head = D.textdata;

%% read time
t = data(:,2);

%% extract the individual prjoections [nleft -> nright], raw data
% note the order of the states

col_real = 1;       % set the initial pointer for the column index
col_imag = 2;

temp_all_to_all = zeros(length(t),1);

for nsp = 1:Lsp
    for nleft = 1:Lstate
        for nright = 1:Lstate
            
            col_real = col_real + 2;  % shift two columns
            col_imag = col_imag + 2;
            
            % read data from the file
            data_real = data(:,col_real);
            data_imag = data(:,col_imag);
            data_abs2 = data_real.^2 + data_imag.^2;
                        
            %         figure; plot(t,data_real,t,data_imag,t,data_abs)
            %         figure; plot(t,data_abs)
            
            % save the results to the structure "struct_proj"
            str_name = ['real_sp',num2str(nsp),'_',num2str(nleft),'to',num2str(nright)]
            struct_proj.(str_name) = data_real;
            
            str_name = ['imag_sp',num2str(nsp),'_',num2str(nleft),'to',num2str(nright)]
            struct_proj.(str_name) = data_imag;
            
            str_name = ['abs2_sp',num2str(nsp),'_',num2str(nleft),'to',num2str(nright)]
            struct_proj.(str_name) = data_abs2;
            
        end % end of nright              
    end % end of nleft
end % end of nsp


%% calculate abs2 (population) all to n (nright)
str_legend = [];

for nsp = 1:Lsp
    
    for nright = 1:Lstate
        
        temp_all_to_n = zeros(length(t),1);
        
        for nleft = 1:Lstate
            
            str_name = ['abs2_sp',num2str(nsp),'_',num2str(nleft),'to',num2str(nright)];
            temp_all_to_n = temp_all_to_n +  struct_proj.(str_name) * NE(nsp,nleft) ;  % Note the use of NE
                     
        end % end of nleft
        
        str_name = ['abs2_sp',num2str(nsp),'_','allTo',num2str(nright)];
        struct_proj.(str_name) = temp_all_to_n;
        
        figure(100)
        hold on;
        plot(t,temp_all_to_n)
        
        str_legend = [str_legend  string(str_name)] ;
        % https://ww2.mathworks.cn/help/matlab/matlab_prog/create-string-arrays.html
        
        % all to all
        temp_all_to_all = temp_all_to_all + temp_all_to_n;
        
    end % end of nright
    
end % end of nsp

struct_proj.abs2_all_to_all = temp_all_to_all;

%% save
figure(100);
legend(str_legend);
xlabel('time [a.u.]')
ylabel('abs2 projections')
saveas(gcf,'abs2_all_to_n.png');
saveas(gcf,'abs2_all_to_n.fig');

figure(200);
plot(t,struct_proj.abs2_all_to_all)
legend('abs2-all-to-all');
title('Note the occupation on some excited states may not be included.')
xlabel('time [a.u.]')
ylabel('abs2 projections')
saveas(gcf,'abs2_all_to_all.png');
saveas(gcf,'abs2_all_to_all.fig');

save proj_data.mat t struct_proj




