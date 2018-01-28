% - Compute and assemble nodal boundary flux vector and point sources 
% 9/29 修复了不同顶点的读取顺序，获得法向量以后将平面旋转到垂直某个分量的平面上 保证了所有顶点的读取顺序一致
% 10/13 修改为三角的NBC输入
function f = src_and_flux(f); 
include_flags; 
  
% assemble point sources to the global flux vector  
f(ID)   = f(ID) + P(ID); 
  
% compute nodal boundary flux vector 
% disp('J:    ')
% J_pr = [];
for i = 1:nbe 
     
        fq        = [0 0 0 0]';                % initialize the nodal source vector  
        node1     = n_bc(1,i);          % first node 
        node2     = n_bc(2,i);          % second node
        node3     = n_bc(3,i);          % third node 
        node4     = n_bc(4,i);          % fourth node 
        n_bce     = n_bc(5:8,i);          % flux values at an edge 
        perm      = [1 2 3;
                     3 4 1
                     1 2 4
                     2 3 4];
        p1=[x(node1) y(node1) z(node1)];   %获得点的坐标
        p2=[x(node2) y(node2) z(node2)];
        p3=[x(node3) y(node3) z(node3)];
        p4=[x(node4) y(node4) z(node4)];
        nv1=cross(p2-p1,p3-p2);
        nv2=cross(p4-p3,p1-p4);
        nv3=cross(p2-p1,p4-p2);
        nv4=cross(p3-p2,p4-p3);
        m1 = vrrotvec2mat(vrrotvec(nv1,[0 0 1])); %m 是一个旋转矩阵 左乘向量从参数1到参数2
        m2 = vrrotvec2mat(vrrotvec(nv2,[0 0 1]));
        m3 = vrrotvec2mat(vrrotvec(nv3,[0 0 1]));
        m4 = vrrotvec2mat(vrrotvec(nv4,[0 0 1]));
        src_P1=(m1*[p1;p2;p3]')';
        src_P2=(m2*[p3;p4;p1]')';
        src_P3=(m3*[p1;p2;p4]')';
        src_P4=(m4*[p2;p3;p4]')';

        C1        = src_P1(:,1:2);    % 获得xy坐标， z必定都相等
        C2        = src_P2(:,1:2);
        C3        = src_P3(:,1:2); 
        C4        = src_P4(:,1:2);
        
        [wt,gpt]=gauss_tri;
        
        % by tianyi
        % there you could go to exmple 8.2 in [J.T.etc] for the quadracture


                psi   = gpt;
                eta   = gpt;
                N  = [(1-psi-eta)  (psi) eta]; 
                
                
                [~,J]=BmatHeat2D_triangular(eta,psi,C1);   
                flux   = N * n_bce(perm(1,:));               % interpolate flux using shape functions in 16.1 it's 20
                fq(perm(1,:))        = fq(perm(1,:)) + wt*N' *flux*J;              % nodal flux 
                
                
                [~,J]=BmatHeat2D_triangular(eta,psi,C2);  
                flux   = N * n_bce(perm(2,:));               % interpolate flux using shape functions in 16.1 it's 20
                fq(perm(2,:))        = fq(perm(2,:)) + wt*N' *flux*J;              % nodal flux 

                [~,J]=BmatHeat2D_triangular(eta,psi,C3);  
                flux   = N * n_bce(perm(3,:));               % interpolate flux using shape functions in 16.1 it's 20
                fq(perm(3,:))        = fq(perm(3,:)) + wt*N' *flux*J;              % nodal flux 
                
                [~,J]=BmatHeat2D_triangular(eta,psi,C4);  
                flux   = N * n_bce(perm(4,:));               % interpolate flux using shape functions in 16.1 it's 20
                fq(perm(4,:))        = fq(perm(4,:)) + wt*N' *flux*J;              % nodal flux 

        fq  = -fq*0.5;          % define nodal flux vectors as negative  
         
        % assemble the nodal flux vector 
        f(ID(node1)) = f(ID(node1)) + fq(1);   
        f(ID(node2)) = f(ID(node2)) + fq(2);
		f(ID(node3)) = f(ID(node3)) + fq(3);
        f(ID(node4)) = f(ID(node4)) + fq(4);
                
end   

end



