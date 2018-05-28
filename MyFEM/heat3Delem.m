% Quadrilateral element conductance matrix and nodal source vector 
% 通过判断单元的位置来进行元素skin与内核的刚性矩阵选择
function [K, Cap] = heat3Delem(K,Trp) 

Cap = zeros(Trp.nnp,Trp.nnp);

for e=1:Trp.nel
    Etype = ElementType.get_tissue_type(e,Trp.nel);
    [par_set] = ElementMatrix.create_param_set(Etype,e,Trp);    
    [ke,Cape] = ElementMatrix.compute_stiffness_n_capcity(Etype,Trp,par_set);    
    % assembly
    je = par_set.je;
    K(je,je) =    K(je,je)+ke;
    Cap(je,je)=   Cap(je,je)+Cape;
end