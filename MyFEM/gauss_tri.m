function [w,gp]=gauss_tri(ngp)
    
%  三角形的gauss点与权重
      if ngp==1
         w=1;
         gp=1/2*ones(1,2);
      elseif ngp == 2
         w=1/6*ones(1,3);
         gp=0.5*[eye(2);ones(1,2)];
      end
end