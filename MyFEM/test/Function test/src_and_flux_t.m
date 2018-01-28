% - Compute and assemble nodal boundary flux vector and point sources 
function f = src_and_flux_t(f); 
include_flags; 
  
% assemble point sources to the global flux vector  
f(ID)   = f(ID) + P(ID); 
  
% compute nodal boundary flux vector 
for i = 1:nbe 
     
        fq        = [0 0 0 0]';                % initialize the nodal source vector  
        node1     = n_bc(1,i);          % first node 
        node2     = n_bc(2,i);          % second node
        node3     = n_bc(3,i);          % third node 
        node4     = n_bc(4,i);          % fourth node 
        n_bce     = n_bc(5:8,i);          % flux values at an edge 
        
        p1=[x(node1) y(node1) z(node1)];   %获得点的坐标
        p2=[x(node2) y(node2) z(node2)];
        p3=[x(node3) y(node3) z(node3)];
        p4=[x(node4) y(node4) z(node4)];
        nv=cross(p2-p1,p3-p2);
        m1 = vrrotvec2mat(vrrotvec(nv,[0 0 1])); %m 是一个旋转矩阵 左乘向量从参数1到参数2
        src_P=[m1*[p1;p2;p3;p4]']';
% %         C=[p1;p2;p3;p4];
        C=src_P;
        
        
        
        % 之前的做法
        C=[C(:,1) sign(C(:,2)).*sqrt(sum(C(:,2:3).^2,2))];  % 对三维进行面积伸展
        
        [w,gp]   = gauss(ngp);             % get Gauss points and weights 
        
        
        % by tianyi
        % there you could go to exmple 8.2 in [J.T.etc] for the quadracture
        % details and by now I appreciate the auto-line-break of Matlab.
        for j=1:ngp                        % integrate along the edge 
            for m=1:ngp    
                
            psi   = gp(j);
            eta   = gp(m);
            N  = 0.25 * [(1-psi)*(1-eta)  (1+psi)*(1-eta)  (1+psi)*(1+eta)  (1-psi)*(1+eta)];        % 2D shape functions in the parent domain
            [~,J] = BmatHeat2D(eta,psi,C);
            flux   = N * n_bce;               % interpolate flux using shape functions in 16.1 it's 20
            fq        = fq + w(j)*w(m)*N' *flux*J;      % nodal flux   
            %                 1        20  length/2(GQ)
            end 
        end
        fq  = -fq;          % define nodal flux vectors as negative  
         
        % assemble the nodal flux vector 
        f(ID(node1)) = f(ID(node1)) + fq(1);   
        f(ID(node2)) = f(ID(node2)) + fq(2);
		f(ID(node3)) = f(ID(node3)) + fq(3);
        f(ID(node4)) = f(ID(node4)) + fq(4);
end   

end