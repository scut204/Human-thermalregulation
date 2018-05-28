% Shape function  
function N = NmatHeat3D(eta,psi,omega) 
        
N  = 0.125 * [(1-psi)*(1-eta)*(1-omega)  (1+psi)*(1-eta)*(1-omega)  (1+psi)*(1+eta)*(1-omega)  (1-psi)*(1+eta)*(1-omega) ...
              (1-psi)*(1-eta)*(1+omega)  (1+psi)*(1-eta)*(1+omega)  (1+psi)*(1+eta)*(1+omega)  (1-psi)*(1+eta)*(1+omega)]; 