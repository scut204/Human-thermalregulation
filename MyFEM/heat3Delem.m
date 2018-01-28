% Quadrilateral element conductance matrix and nodal source vector 
function [ke, fe, Cape] = heat3Delem(e) 
include_flags; 
 
ke    = zeros(nen,nen);      % initialize element conductance matrix 
fe    = zeros(nen,1);        % initialize element nodal source vector 
Cape  = zeros(nen,nen);

% get coordinates of element nodes  
je   = IEN(:,e);            % get the global node number.


if e < nel/3
%     if ngp>1
%         ngp_tri=2;
%     else
%         ngp_tri=1;
%     end
     t = [1 3 2 6 
          1 4 3 8
          6 7 8 3
          5 6 8 1
          1 3 6 8];      % t�Ƿ�ӳ�������ڲ���������Ԫ�صķֲ�
     iso_para =[eye(3);zeros(1,3)];
     [w,gp]   = gauss_tet(1);      % �������ĵ�shape function����Ҫ����ĸ�˹�� ����������Ϊ1
     gp_nodes=gp*iso_para;
        % ����Ȩ�س������  
    for k = 1:size(t,1)
      for i = 1 : length(w)
       arr = t(k,:);
       C   = [x(je(arr)) y(je(arr)) z(je(arr))]; % C��Ҫ��һЩ�仯

       eta   = gp_nodes(i,1);             
       psi   = gp_nodes(i,2);   
       omega = gp_nodes(i,3);   

       N     = NmatHeat3D_tetra(eta,psi,omega); % shape functions matrix  

       [B, detJ]      = BmatHeat3D_tetra(eta,psi,omega,C); % derivative of the shape functions 
       A = 1/6; % A��ʾgarlekin�����еĵȲ����������
       detJ = detJ *A ;
%        detJ = abs(detJ);
       ke(arr,arr)  = ke(arr,arr) + w(i)*B'*D*B*detJ;     % element conductance matrix 

       se  = N*s(arr,e);                         % compute s(x) 
       Cape(arr,arr) = Cape(arr,arr) + w(i)*N'*dens*spech*N*detJ; 
       fe(arr)   = fe(arr) + w(i)*N'*se*detJ;      % element nodal source vector  
      end
    end
else    %������Ԫ�ؾͺ���ͨ������һ������      
    C    = [x(je) y(je) z(je)]; 
    [w,gp]   = gauss(ngp);    
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
end