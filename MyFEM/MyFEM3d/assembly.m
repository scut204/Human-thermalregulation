% assemble element stiffness matrix and nodal force vector  
function [K,f,Cap] = assembly(K,f,e,ke,fe,Cape) 
include_flags; 
  
for loop1 = 1:nen 
    i = LM(loop1,e); 
    f(i) =  f(i) + fe(loop1);   % assemble nodal force vector 
    for loop2 = 1:nen 
        j = LM(loop2,e); 
        K(i,j) = K(i,j) + ke(loop1,loop2);  % assemble stiffness matrix 
        Cap(i,j)=Cap(i,j)+Cape(loop1,loop2);
    end 
end 