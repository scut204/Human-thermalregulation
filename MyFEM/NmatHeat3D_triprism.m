function  N = NmatHeat3D_triprism(eta,psi,omega) 
        %[1 4 5 2 3 6 ]
        %[8 5 4 7 6 3 ]
N  = 0.5 * [(1-psi-eta)*(1-omega) psi*(1-omega)  eta*(1-omega)   ...
            (1-psi-eta)*(1+omega) psi*(1+omega)  eta*(1+omega)  ];  
          
end