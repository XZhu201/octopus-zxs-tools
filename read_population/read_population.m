t=[0:367:30828,30865];
Nt = length(t);

Mpop = zeros(8,Nt);

strhead = 'population';



for m = 1:8
       
    strm = num2str(m+21);
    title = [strhead strm]
    
    load(title);
        
    Mpop(m,:) = abs(population* 0.4^3).^2 ;
    
end


figure;
imagesc(t,[22:29],Mpop);  

figure;
plot(t,Mpop);
legend('HOMO','HOMO-1','HOMO-2','HOMO-3','HOMO-4','HOMO-5','HOMO-6','HOMO-7')





