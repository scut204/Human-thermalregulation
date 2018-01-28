% Shape function  
function N = NmatHeat2D_triangular(eta,psi) 
        
N  =  [1-psi-eta  eta  psi]; 