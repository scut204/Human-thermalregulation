function [B, detJ] = BmatHeat3D_triprism(eta,psi,omega,C) 


% calculate the Grad(N) matrix 
% N  = 0.5 * [(1-psi-eta)*(1-omega) psi*(1-omega)  eta*(1-omega)   ...
%             (1-psi-eta)*(1+omega) psi*(1+omega)  eta*(1+omega)  ];  
GN      = 0.5 * [omega-1   (1-omega)    0         -(omega+1)   (1+omega)       0    ; 
				  (psi+eta-1)  -psi      -eta       (1-psi-eta)    psi          eta;
                   omega-1      0      (1-omega)    -(omega+1)      0        (1+omega)]; 
J       = GN*C;         % Get the Jacobian matrix  
detJ    = det(J);       % Jacobian     
B       = J\GN;         % compute the B matrix J*B=GN