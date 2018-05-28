% - Compute and assemble nodal boundary flux vector and point sources 
function [f,K] = mixed_boundary_tobe(f,K); 
include_flags; 
  
% assemble point sources to the global flux vector  
f(ID)   = f(ID) + P(ID); 
  
% compute nodal boundary flux vector 
for i = 1:mbe
    
    %%%%%%%%%%%%%%%%
        % h =
        fq        = [0 0 0 0]';                % initialize the nodal source vector
		Km		  = zeros(4);
       % node1     = m_bc(1,i);          % first node 
       % node2     = m_bc(2,i);          % second node
       % node3     = m_bc(3,i);          % third node 
        node     = m_bc(1:4,i);          %  node array
        m_bce     = m_bc(5:8,i);          % Tm values in nodes
        
       % p1=[x(node1) y(node1) z(node1)];   %获得点的坐标
       % p2=[x(node2) y(node2) z(node2)];
       % p3=[x(node3) y(node3) z(node3)];
       % p4=[x(node4) y(node4) z(node4)];
		p=[x(node) y(node) z(node)];
        ratio=rat_plane2planar(p);        %通过点的坐标来计算三角形面积
        C        = [x(node) y(node)];
                                     
        [w,gp]   = gauss(ngp);             % get Gauss points and weights 
        
        
        % by tianyi
        % there you could go to exmple 8.2 in [J.T.etc] for the quadracture
        % details and by now I appreciate the auto-line-break of Matlab.
        for j=1:ngp                        % integrate along the edge 
            for m=1:ngp    
                
            psi   = gp(j);
            eta   = gp(m);
            N  = 0.25 * [(1-psi)*(1-eta)  (1+psi)*(1-eta)  (1+psi)*(1+eta)  (1-psi)*(1+eta)];        % 2D shape functions in the parent domain 
            [~,J]=BmatHeat2D(eta,psi,C);
            J=abs(J);
%%%%%%%%
            flux   = N * m_bce;               % interpolate flux using shape functions in 16.1 it's 20
            fq        = fq + w(j)*w(m)*N'* flux * ratio * J;      % nodal flux   
            
            Ke        = Ke + w(j)*w(m)*N'* N    * h * ratio * J;  % 
%%%%%%%%
            end 
        end
        fq  = -fq;          % define nodal flux vectors as negative  
         
        % assemble the nodal flux vector 
        gnode=ID(node);
%         f(ID(node1)) = f(ID(node1)) + fq(1);   
%         f(ID(node2)) = f(ID(node2)) + fq(2);
% 		f(ID(node3)) = f(ID(node3)) + fq(3);
%         f(ID(node4)) = f(ID(node4)) + fq(4);
        f(gnode)=f(gnode)+fq;
        K(gnode,gnode) = K(gnode,gnode) + Ke;        
end   

end


function r=rat_plane2planar(p)
    p1=p(1,:);
    p2=p(2,:);
    p3=p(3,:);
    p4=p(4,:);
    affp(:,3)=0;
    a1=affp(1,:);
    a2=affp(2,:);
    a3=affp(3,:);
    a4=affp(4,:);
    r=quad_area(p1,p2,p3,p4)/quad_area(a1,a2,a3,a4);
end


function area=quad_area(p1,p2,p3,p4)
    m1=p1-p2;
    m2=p2-p3;
    avec=cross(m1,m2);
    area=dot(avec,avec,2).^(1/2);
    
    m1=p3-p4;
    m2=p4-p1;
    avec=cross(m1,m2);
    area=area+dot(avec,avec,2).^(1/2);
    area=area*0.5;
end