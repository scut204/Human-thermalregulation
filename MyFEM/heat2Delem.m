% Quadrilateral element conductance matrix and nodal source vector 
function [ke, fe, Cape] = heat2Delem(e) 
include_flags; 
  
ke    = zeros(nen,nen);      % initialize element conductance matrix 
fe    = zeros(nen,1);        % initialize element nodal source vector 
Cape  = zeros(nen,nen);

% get coordinates of element nodes  
je   = IEN(:,e);            % get the global node number.
C    = [x(je) y(je) z(je)];  
  
[w,gp]   = gauss(ngp);      % get Gauss points and weights 
  
% compute element conductance matrix and nodal source vector  
for i=1:ngp 
   for j=1:ngp
       for m=1:ngp
       eta = gp(i);             
       psi = gp(j); 
       omega=gp(m);
                
       N     = NmatHeat3D(eta,psi,omega); % shape functions matrix  
       
        [B, detJ]      = BmatHeat3D(eta,psi,omega,C); % derivative of the shape functions 
       ke  = ke + w(i)*w(j)*w(m)*B'*D*B*detJ;     % element conductance matrix 
       se  = N*s(:,e);                         % compute s(x) 
       Cape   = Cape + w(i)*w(j)*w(m)*N'*dens*spech*N*detJ; 
       fe   = fe + w(i)*w(j)*w(m)*N'*se*detJ;      % element nodal source vector  
       end
   end    
end