% - Compute and assemble nodal boundary flux vector and point sources 
function f = src_and_flux_tetra(f,Trp); 
makebias_srcflx;


% Tm m_rsw n_bc + 3d elem
h_fg = 2500.8 - 2.36 * Tm + 0.0016*Tm^2-0.00006*Tm^3;
m_val = Sweat_vapor.compute_valid_vapor(Trp,h_fg)	;

n_bc(5:8,:)=m_val;  
nbe = size(n_bc,2);
% compute nodal boundary flux vector 
for i = 1:nbe 
                                                                                    
        fq        = [0 0 0 0]';                % initialize the nodal source vector  
        node1     = n_bc(1,i);          % first node 
        node2     = n_bc(2,i);          % second node
        node3     = n_bc(3,i);          % third node 
        node4     = n_bc(4,i);          % 4th node
        n_bce     = n_bc(5:8,i);          % flux values at an edge 
        
        p1=[x(node1) y(node1) z(node1)];   %获得点的坐标
        p2=[x(node2) y(node2) z(node2)];
        p3=[x(node3) y(node3) z(node3)];
        p4=[x(node4) y(node4) z(node4)];
        
        nv1=cross(p2-p1,p4-p2);
        nv2=cross(p3-p2,p4-p3);
        m1 = vrrotvec2mat(vrrotvec(nv1,[0 0 1])); %m 是一个旋转矩阵 左乘向量从参数1到参数2
        m2 = vrrotvec2mat(vrrotvec(nv2,[0 0 1]));
        src_P1=[m1*[p1;p2;p4]']';
        src_P2=[m2*[p2;p3;p4]']';
        n_bce1=n_bce([1 2 4]);
        n_bce2=n_bce([2 3 4]);

        
        % by tianyi
        % there you could go to exmple 8.2 in [J.T.etc] for the quadracture
        % details and by now I appreciate the auto-line-break of Matlab.

        fq([1 2 4]) = fq([1 2 4])+gen_fq(src_P1,n_bce1);
        fq([2 3 4]) = fq([2 3 4])+gen_fq(src_P2,n_bce2);
        fq  = -fq;          % define nodal flux vectors as negative  
         
        % assemble the nodal flux vector 
        f((node1)) = f((node1)) + fq(1);   
        f((node2)) = f((node2)) + fq(2);
		f((node3)) = f((node3)) + fq(3);
        f((node4)) = f((node4)) + fq(4);
                
end   

end

function fq=gen_fq(src_P,n_bce)
% include_flags;
%             w=1;             % get Gauss points and weights 
%             gp = 1/3;
            fq=[0 0 0]';
            [w,gp] = gauss_tri(2);

            gp_nodes=gp;
       for i=1:length(w)         
            psi   = gp_nodes(i,1);
            eta   = gp_nodes(i,2);
            N  =  [1-psi-eta  eta  psi];        % 2D shape functions in the parent domain
            [~,J] = BmatHeat2D_triangular(eta,psi,src_P(:,1:2));

            flux   = N * n_bce;               % interpolate flux using shape functions in 16.1 it's 20
            fq     =fq + w(i) *N' *flux*J;      % nodal flux   
            %                 1        20  length/2(GQ)
       end
end