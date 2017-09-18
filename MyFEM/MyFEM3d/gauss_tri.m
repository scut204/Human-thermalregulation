function [w,gp]=gauss_tri(ngp)
    
    if ngp == 1 
        gp = 0; 
        w  = 2; 
    elseif ngp == 2 
        gp = [0.5  0    0.5;
              0    0.5  0.5];     % 1/sqrt(3)
        w  = [0.16666666,  0.16666666,   0.16666666]; 
    end
end