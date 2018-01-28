function [K,f]=src_mix_boundaryC(K,f)
    include_flags;
for i=1:mbe
        
%     h     = m_bc(,e);
        Tm    = m_bc(5,i);
        
        fq        = [0 0 0 0]';                % initialize the nodal source vector  
        kq        = zeros(4,4);
        nodes     = m_bc(1:4,i);
        node1     = m_bc(1,i);          % first node 
        node2     = m_bc(2,i);          % second node
        node3     = m_bc(3,i);          % third node 
        node4     = m_bc(4,i);          % 4th node
        tri1      = [1 2 4];
        tri2      = [2 3 4];
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
        kq1 = gen_kq(src_P1(:,1:2),h);
        kq2 = gen_kq(src_P2(:,1:2),h);
        fq1 = gen_fq(src_P2(:,1:2),h,Tm);
        fq2 = gen_fq(src_P2(:,1:2),h,Tm);
        
        fq(tri1) = fq(tri1)+fq1;
        fq(tri2) = fq(tri2)+fq1;
        kq(tri1,tri1) = kq(tri1,tri1) + kq1;
        kq(tri2,tri2) = kq(tri2,tri2) + kq2;
        fq  = fq; 
        
        f(ID(nodes)) = f(ID(nodes)) + fq;
        K(ID(nodes),ID(nodes)) = K(ID(nodes),ID(nodes)) + kq;
end

 
end
    
function kq = gen_kq(src_P,h)
     kq=zeros(3,3);                 % kq初始化的矩阵秩需要参数化
     iso_para =[eye(2);zeros(1,2)];
     [w,gp]   = gauss_tri(2);      % 四面体四点shape function不需要多余的高斯点 所以这里设为1
     gp_nodes=gp*iso_para;
     for i=1:length(w)         
        psi   = gp_nodes(i,1);
        eta   = gp_nodes(i,2);
        N  =  [1-psi-eta  eta  psi];        % 2D shape functions in the parent domain
        [~,J] = BmatHeat2D_triangular(eta,psi,src_P(:,1:2));
        J = J *0.5;                       
        kq     =kq + w(i) *N'*h*N *J;      % nodal flux   
        %                 1        20  length/2(GQ)
     end     
end
 
function fq=gen_fq(src_P,h,Tm)
% include_flags;
%             w=1;             % get Gauss points and weights 
%             gp = 1/3;
            fq=[0 0 0]';
            [w,gp] = gauss_tri(2);
            iso_para =[eye(2);zeros(1,2)];
            gp_nodes=gp*iso_para;
       for i=1:length(w)         
            psi   = gp_nodes(i,1);
            eta   = gp_nodes(i,2);
            N  =  [1-psi-eta  eta  psi];        % 2D shape functions in the parent domain
            [~,J] = BmatHeat2D_triangular(eta,psi,src_P(:,1:2));
            J = J *0.5;
%             Tq   = N * Tm;               % interpolate flux using shape functions in 16.1 it's 20
            fq     =fq + w(i) *N' *Tm*h*J;      % nodal flux   
            %                 1        20  length/2(GQ)
       end
end