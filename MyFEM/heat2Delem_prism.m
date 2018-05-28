% Quadrilateral element conductance matrix and nodal source vector 
function [ke, fe, Cape] = heat2Delem_prism(e) 
include_flags; 
  

% get coordinates of element nodes  
je   = IEN3(:,e);            % get the global node number.
C    = [x(je) y(je) z(je)];  
psm_nen = length(je);
ke    = zeros(psm_nen,psm_nen);      % initialize element conductance matrix  
Cape  = zeros(psm_nen,psm_nen);
[w,gp]   = gauss(ngp);      % get Gauss points and weights 
[wt,gpt] = gauss_tri(2);


for i=1:length(wt)    % 两个三角形
      for m=1:ngp
       eta = gpt(i,1);             
       psi = gpt(i,2); 
       omega=gp(m);
                
       N     = NmatHeat3D_triprism(eta,psi,omega); % shape functions matrix  
        [B, detJ]      = BmatHeat3D_triprism(eta,psi,omega,C); % derivative of the shape functions 
       ke = ke + wt(i)*w(m)*B'*D*B*detJ;     % element conductance matrix 
%        se  = N*s(:,e);                         % compute s(x) 
       Cape   = Cape + wt(i)*w(m)*N'*dens*spech*N*detJ; 
%        fe   = fe + w(i)*w(j)*w(m)*N'*se*detJ;      % element nodal source vector  
      end
%    end    
end