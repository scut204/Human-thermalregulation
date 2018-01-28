% B matrix function 
  
function [B, detJ] = BmatHeat3D_tetra(eta,psi,omega,C) 

% N  =  [(1-psi-eta-omega) psi  eta  omega ]; 
% calculate the Grad(N) matrix 
GN      = [ 1 0 0 -1 
            0 1 0 -1
            0 0 1 -1];
J       = GN*C;         % Get the Jacobian matrix  
detJ    = det(J);       % Jacobian     
B       = J\GN;         % compute the B matrix J*B=GN