function [w,gp]=gauss_tri(ngp)
    
%  �����ε�gauss����Ȩ��
      if ngp==1
         w=1;
         gp=1/2*ones(1,2);
      elseif ngp == 2
         w=1/6*ones(1,3);
         gp=0.5*[eye(2);ones(1,2)];
      end
end