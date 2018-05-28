% plot temperature and flux 
function postprocessor_t(d); 
include_flags 
  
% plot the temperature field 
if strcmpi(plot_temp,'yes') == 1;   
   d1   = d(ID); 
   figure(2);  view(3);hold on; 
   axis([min(x) max(x) min(y) max(y) min(z) max(z) min(d1) max(d1)]);    
   for e = 1:nel 
	   XX  = [x(IEN(1,e))  x(IEN(2,e))  x(IEN(3,e))  x(IEN(4,e))  x(IEN(1,e))]; 
       YY  = [y(IEN(1,e))  y(IEN(2,e))  y(IEN(3,e))  y(IEN(4,e))  y(IEN(1,e))]; 
	   ZZ  = [z(IEN(1,e))  z(IEN(2,e))  z(IEN(3,e))  z(IEN(4,e))  z(IEN(1,e))]; 
       dd  = [d1(IEN(1,e)) d1(IEN(2,e)) d1(IEN(3,e)) d1(IEN(4,e)) d1(IEN(1,e))]; 
       patch(XX,YY,ZZ,dd);
       	  
       XX  = [x(IEN(4,e))  x(IEN(1,e))  x(IEN(5,e))  x(IEN(8,e))  x(IEN(4,e))]; 
       YY  = [y(IEN(4,e))  y(IEN(1,e))  y(IEN(5,e))  y(IEN(8,e))  y(IEN(4,e))]; 
	   ZZ  = [z(IEN(4,e))  z(IEN(1,e))  z(IEN(5,e))  z(IEN(8,e))  z(IEN(4,e))]; 
       dd  = [d1(IEN(4,e)) d1(IEN(1,e)) d1(IEN(5,e)) d1(IEN(8,e)) d1(IEN(4,e))]; 
       patch(XX,YY,ZZ,dd);  
	   
	   for i=1:3
		XX  = [x(IEN(i,e))  x(IEN(i+1,e))  x(IEN(i+5,e))  x(IEN(i+4,e))  x(IEN(i,e))]; 
		YY  = [y(IEN(i,e))  y(IEN(i+1,e))  y(IEN(i+5,e))  y(IEN(i+4,e))  y(IEN(i,e))];
		ZZ  = [z(IEN(i,e))  z(IEN(i+1,e))  z(IEN(i+5,e))  z(IEN(i+4,e))  z(IEN(i,e))]; 		
		dd  = [d1(IEN(i,e))  d1(IEN(i+1,e))  d1(IEN(i+5,e))  d1(IEN(i+4,e))  d1(IEN(i,e))]; 
		patch(XX,YY,ZZ,dd);   
	   end
	   
	   XX  = [x(IEN(5,e))  x(IEN(6,e))  x(IEN(7,e))  x(IEN(8,e))  x(IEN(5,e))]; 
       YY  = [y(IEN(5,e))  y(IEN(6,e))  y(IEN(7,e))  y(IEN(8,e))  y(IEN(5,e))]; 
	   ZZ  = [z(IEN(5,e))  z(IEN(6,e))  z(IEN(7,e))  z(IEN(8,e))  z(IEN(5,e))];
       dd  = [d1(IEN(5,e)) d1(IEN(6,e)) d1(IEN(7,e)) d1(IEN(8,e)) d1(IEN(5,e))]; 
       patch(XX,YY,ZZ,dd);
   end 
title('Temperature distribution'); xlabel('X'); ylabel('Y');zlabel('Z'); colorbar; 
    drawnow 
    pause(0.25);
end 
  
%compute flux vector at Gauss points 
if strcmpi(compute_flux,'yes')==1;   
    plot_qv=[];
    fprintf(1,'\n                     Heat Flux at Gauss Points \n') 
    fprintf(1,'----------------------------------------------------------------------------- \n') 
    for e  = 2:2
    fprintf(1,'Element  %d \n',e) 
    fprintf(1,'-------------\n')       
        get_flux_t(d,e); 
    end 
end 