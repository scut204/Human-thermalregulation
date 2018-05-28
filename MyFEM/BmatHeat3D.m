% B matrix function 
  
function [B, detJ] = BmatHeat3D(eta,psi,omega,C) 

% N  = 0.125 * [(1-psi)*(1-eta)*(1-omega)  (1+psi)*(1-eta)*(1-omega)  (1+psi)*(1+eta)*(1-omega)  (1-psi)*(1+eta)*(1-omega) ...
%               (1-psi)*(1-eta)*(1+omega)  (1+psi)*(1-eta)*(1+omega)  (1+psi)*(1+eta)*(1+omega)  (1-psi)*(1+eta)*(1+omega)]; 
% calculate the Grad(N) matrix 
GN      = 0.125 * [(eta-1)*(1-omega)   (1-eta)*(1-omega)    (1+eta)*(1-omega)   (-eta-1)*(1-omega) (eta-1)*(1+omega)   (1-eta)*(1+omega)    (1+eta)*(1+omega)   (-eta-1)*(1+omega); 
                   (psi-1)*(1-omega)   (-psi-1)*(1-omega)   (1+psi)*(1-omega)   (1-psi)*(1-omega)  (psi-1)*(1+omega)   (-psi-1)*(1+omega)   (1+psi)*(1+omega)   (1-psi)*(1+omega);
				   (psi-1)*(1-eta)	   (1+psi)*(eta-1)		-1*(1+psi)*(1+eta)	(psi-1)*(1+eta)    (1-psi)*(1-eta)	   (1+psi)*(1-eta)		(1+psi)*(1+eta)	    (1-psi)*(1+eta)]; 
J       = GN*C;         % Get the Jacobian matrix  
detJ    = det(J);       % Jacobian     
B       = J\GN;         % compute the B matrix J*B=GN