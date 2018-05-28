% Shape function  
function N = NmatHeat3D_tetra(eta,psi,omega) 
        
N  =  [ psi  eta  omega (1-psi-eta-omega)]; 