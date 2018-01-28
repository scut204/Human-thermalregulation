% Quadrilateral element conductance matrix and nodal source vector 
function [ke, fe, Cape] = heat2Delem(e) 
include_flags; 
  
ke    = zeros(nen,nen);      % initialize element conductance matrix 
fe    = zeros(nen,1);        % initialize element nodal source vector 
Cape  = zeros(nen,nen);

% get coordinates of element nodes  
je   = IEN(:,e);            % get the global node number.
C    = [x(je) y(je) z(je)];  
perm =  [1 4 5 2 3 6 ;
         8 5 4 7 6 3 ];
[w,gp]   = gauss(ngp);      % get Gauss points and weights 
[wt,gpt] = gauss_tri;
% compute element conductance matrix and nodal source vector  
% for i=1:ngp 
%    for j=1:ngp
%        for m=1:ngp
%        eta = gp(i);             
%        psi = gp(j); 
%        omega=gp(m);
%                 
%        N     = NmatHeat3D(eta,psi,omega); % shape functions matrix  
%        
%         [B, detJ]      = BmatHeat3D(eta,psi,omega,C); % derivative of the shape functions 
%        ke  = ke + w(i)*w(j)*w(m)*B'*D*B*detJ;     % element conductance matrix 
%        se  = N*s(:,e);                         % compute s(x) 
%        Cape   = Cape + w(i)*w(j)*w(m)*N'*dens*spech*N*detJ; 
%        fe   = fe + w(i)*w(j)*w(m)*N'*se*detJ;      % element nodal source vector  
%        end
%    end    
% end

for i=1:2    % 两个三角形
      for m=1:ngp
       eta = gpt;             
       psi = gpt; 
       omega=gp(m);
                
       N     = NmatHeat3D_triprism(eta,psi,omega); % shape functions matrix  
       
        [B, detJ]      = BmatHeat3D_triprism(eta,psi,omega,C(perm(i,:),:)); % derivative of the shape functions 
       ke(perm(i,:),perm(i,:))  = ke(perm(i,:),perm(i,:)) + wt*w(m)*B'*D*B*detJ;     % element conductance matrix 
%        se  = N*s(:,e);                         % compute s(x) 
%        Cape   = Cape + wt*w(m)*N'*dens*spech*N*detJ; 
%        fe   = fe + w(i)*w(j)*w(m)*N'*se*detJ;      % element nodal source vector  
      end
%    end    
end