function [w,gp]=gauss_tri(ngp)
    
%  三角形的gauss点与权重
      if ngp==1
         w=1;
         gp=0.25*ones(1,2);
      elseif ngp == 2
         w=1/3*ones(1,3);
         gp=1/6*ones(3,3)+(2/3-1/6)*eye(3);
      end
end