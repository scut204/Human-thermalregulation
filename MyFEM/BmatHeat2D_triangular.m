function [B, detJ] = BmatHeat2D_triangular(eta,psi,C) 
         
% calculate the Grad(N) matrix 
% N  =  [1-psi-eta  eta  psi]; 
% gradN first d(eta) then d(psi)
GN      = [-1   1    0; 
           -1   0   1]; 
  
J       = GN*C;         % Get the Jacobian matrix  
detJ    = det(J);       % Jacobian     
B       = J\GN;         % compute the B matrix J*B=GN