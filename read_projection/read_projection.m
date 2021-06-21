% This is fast and good~
% extract the data from the .cube file
% the inporated data are named data

% about the use of "dynamic expression" with structure can be seen here:
% https://ww2.mathworks.cn/help/matlab/matlab_prog/string-evaluation.html
% https://ww2.mathworks.cn/help/matlab/matlab_prog/generate-field-names-from-variables.html

clc
clear

%% input
str_file = 'projections';
Nhead = 22;

Lstate = 4;  % the number of states

%% read file
D=importdata(str_file,' ',Nhead);
data = D.data;
head = D.textdata;

%% read time
t = data(:,2);

%% extract the individual prjoections [nleft -> nright]
% note the order of the states

col_real = 1;       % set the initial pointer for the column index
col_imag = 2;  

temp_all_to_all = zeros(length(t),1);

for nleft = 1:Lstate
    
    temp_all_to_n = zeros(length(t),1);
    
    for nright = 1:Lstate
        
        col_real = col_real + 2;  % shift two columns
        col_imag = col_imag + 2
                       
        % read data from the file
        data_real = data(:,col_real);
        data_imag = data(:,col_imag);
        data_abs2 = data_real.^2 + data_imag.^2;     
        
        temp_all_to_n = temp_all_to_n + data_abs2;
        
%         figure; plot(t,data_real,t,data_imag,t,data_abs)
%         figure; plot(t,data_abs)
        
        % save the results to the structure "struct_proj"
        str_name = ['real_',num2str(nleft),'to',num2str(nright)]       
        struct_proj.(str_name) = data_real;
        
        str_name = ['imag_',num2str(nleft),'to',num2str(nright)]
        struct_proj.(str_name) = data_imag;
        
        str_name = ['abs2_',num2str(nleft),'to',num2str(nright)]
        struct_proj.(str_name) = data_abs2;
        
    end % end of nright     
    
    str_name = ['abs2_allTo',num2str(nleft)];
    struct_proj.(str_name) = temp_all_to_n;
    
    figure(200)
    hold on;
    plot(t,temp_all_to_n)
    
    temp_all_to_all = temp_all_to_all + temp_all_to_n;
    
end % end of nleft

figure; plot(t,temp_all_to_all)

%% save
figure(200); 
saveas(gcf,'abs2_all_to_n.png');

save proj_data.mat t struct_proj




