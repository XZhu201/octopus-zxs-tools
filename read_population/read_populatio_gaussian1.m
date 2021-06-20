clear

t=[0:367:30828,30865];
Nt = length(t);

Mpop = zeros(8,Nt);

strhead = 'population';



for m = 1:8
       
    strm = num2str(m+21);
    title = [strhead strm]
    
    load(title);
    
    
    %%%%% smooth %%%%%
    %%% 平滑的方法参见 PHYSICAL REVIEW A,66, 023805 （2002） 公式8
    disp('smoothing ...');
    
    xaxis = t;
    yaxis = population;
    

    
    dw = 367;
    
    w = dw;
    
    smwidth = 2*w;
    
    Lyaxis = Nt;     %   曲线的点数
    
    arrw = (1:Lyaxis)*dw;       %   横坐标w
    
    for nsm = 1:Lyaxis
        smaxis(nsm) = sum( yaxis.*exp( -(arrw-nsm*dw).^2/smwidth/smwidth ) ) ./ sum( exp( -(arrw-nsm*dw).^2/smwidth/smwidth )) ;
        
        if nsm == Lyaxis/2
            figure; 
            plot(t,exp( -(arrw-nsm*dw).^2/smwidth/smwidth ))
        end
    end
    
    % end of smooth
    
    
    population_sm = smaxis;
        
    Mpop(m,:) = abs(population_sm* 0.4^3).^2 ;
    
end


figure;
surf(t,[22:29],Mpop);  shading iNterp;

figure;
plot(t,Mpop);
legend('HOMO','HOMO-1','HOMO-2','HOMO-3','HOMO-4','HOMO-5','HOMO-6','HOMO-7')










