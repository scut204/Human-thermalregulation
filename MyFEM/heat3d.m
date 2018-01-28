%%%%%%%%%%%%%%%%%%%%% 
% Heat conduction in 2D (Chapter 8)      % 
% Haim Waisman, Rensselaer               % 
%%%%%%%%%%%%%%%%%%%% % 
clear all; 
close all;  


% Include global variables 
include_flags; 

% Preprocessing  
[K,f,d] = preprocessor; 

% Evaluate element conductance matrix, nodal source vector and assemble 
    
for e = 1:nel 
    [ke, fe, Cape] = heat3Delem(e);  
    [K,f, Cap] = assembly(K,f,e,ke,fe,Cape);   
end 

%  Compute and assemble nodal boundary flux vector and point sources  
% f= src_and_flux_tetra(f);
[K,f] = src_mix_boundaryC(K,f);
% f = src_and_flux_t(f); % 
% f = src_and_flux_prism(f);

% Solution  
[d,f_E] = solvedr(K,f,d);
    
    
for t=1:1
    
    % Postprocessing 
    postprocessor(d); 
    
%     Kt=Cap+0.5*dtime*K;
%     ft=(Cap-0.5*dtime*K)*d;
%     [d,f_E] = solvedr(Kt,ft,d);
    
end
    