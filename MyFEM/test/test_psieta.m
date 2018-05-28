% 测试xyz坐标与希腊字母坐标的转换
x=[1 4 5 2];
y=[0 0 4 3];
C    = [x' y'];  
line([x x(1)],[y y(1)]); hold on;
% compute element conductance matrix and nodal source vector  

eta =  -.8;            
psi =  .5;

 
       N     = NmatHeat2D(eta,psi); % shape functions matrix  
       cor     = N*C;
       plot(cor(1),cor(2),'ro');
%         [B, detJ]      = BmatHeat3D(eta,psi,omega,C); % derivative of the shape functions 