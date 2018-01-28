function [B, detJ] = BmatHeat3D_triprism(eta,psi,omega,C) 

% N  = 0.125 * [(1-psi)*(1-eta)*(1-omega)  (1+psi)*(1-eta)*(1-omega)  (1+psi)*(1+eta)*(1-omega)  (1-psi)*(1+eta)*(1-omega) ...
%               (1-psi)*(1-eta)*(1+omega)  (1+psi)*(1-eta)*(1+omega)  (1+psi)*(1+eta)*(1+omega)  (1-psi)*(1+eta)*(1+omega)]; 
% calculate the Grad(N) matrix 
GN      = 0.5 * [omega-1   (1-omega)    0         -(omega+1)   (1+omega)       0    ; 
                   omega-1      0      (1-omega)    -(omega+1)      0        (1+omega);
				  (psi+eta-1)  -psi      -eta       (1-psi-eta)    psi          eta  ]; 
J       = GN*C;         % Get the Jacobian matrix  
detJ    = det(J);       % Jacobian     
B       = J\GN;         % compute the B matrix J*B=GN