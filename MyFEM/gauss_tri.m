function [w,gp]=gauss_tri(ngp)
    
%  三角形的gauss点与权重
      if ngp==1
         w=1/2;
         gp=1/3*ones(1,2);
      elseif ngp == 2
         w=1/6*ones(1,3);
          gp_w= 1/2*eye(3) + 1/6*ones(3,3);
         iso_para=0.5*[eye(2);ones(1,2)];
         gp = gp_w*iso_para;
      end
end