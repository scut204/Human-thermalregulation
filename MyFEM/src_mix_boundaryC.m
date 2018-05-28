function [K,f]=src_mix_boundaryC(K,f,Trp,option,Tb,Ta)
    
if nargin==3
     [K,f]=src_mbc(K,f,Trp);
else
    switch option
        case 'blood'
            [K,f]=src_blood_1Dmbc(K,f,Tb,Ta,Trp);
        case 'surface'  % 暂时无效
            [K,f]=src_blood_2Dmbc(K,f,Trp);
        otherwise 
            [K,f]=src_mbc(K,f,Trp);
    end
end


end


function [K,f]=src_blood_1Dmbc(K,f,Tb,Ta,Trp)

    makebias_bld_n_res;
    [w,gp] = gauss(2);
	%  heat3d + Tb
for e = (nel/4+1):nel*3/4
    

    r_bl = r0_skin:(r0-r0_skin)/3:r0;
    r_bl_con =(((r_bl(2:end).^2)+(r_bl(1:end-1).^2)+r_bl(2:end).*r_bl(1:end-1))...
               ./(3*(r_bl(1:end-1)).^3.*(r_bl(2:end)).^3))...
               .^-0.25;    
    if(e<=nel/4)
        stg=1;
    elseif(e<=nel*2/4)
        stg=2;
    elseif(e<=nel*3/4)
        stg=3;
    end
    ro=r_bl(stg);
    rin=r_bl(stg+1);
    r_mid = r_bl_con(stg);
    
    if(e<=nel*3/4)
    je   = IEN(:,e);            % get the global node number.
    C    = [x(je) y(je) z(je)];  
    eg   = [1 2 3 4 1 2 3 4 5 6 7 8;
            2 3 4 1 5 6 7 8 6 7 8 5]; % 12条边的上下端
    r_1d = [r_mid rin r_mid ro ro rin rin ro r_mid rin r_mid ro];
    else
        el3=e-nel*3/4;
        je   = IEN3(:,el3);            % get the global node number.
        C    = [x(je) y(je) z(je)];  
        eg   = [1 2 3 1 2 3 4 5 6 ;
                2 3 1 4 5 6 5 6 4 ]; % 边的上下端
        r_1d = [ro r_mid r_mid ro ro rin ro r_mid r_mid];
    end
     for i = 1:size(eg,2)        
        st = je(eg(1,i));
        ed = je(eg(2,i));
        delta_z = norm(C(eg(1,i),:)-C(eg(2,i),:))/2;
        for j = 1:2
             psi = gp(j);
             N     = 0.5*[1-psi  1+psi];  
             
             hb_loc = 4.36 * kb /(2*r_1d(i));
             ke = w(j)* 2*pi*r_1d(i)*hb_loc*(delta_z)*(N'*N);
             fe = w(j)* 2*pi*r_1d(i)*hb_loc*(delta_z)*(N'*N)*Tb([st ed]);
             K([st ed],[st ed])=K([st ed],[st ed])+ke;
             f([st ed]) =   f([st ed])+ fe;
        end
    end
end

for e = (nel/4+1):nel*3/4
    

    r_bl = r1_skin:(r1-r1_skin)/3:r0;
    r_bl_con =(((r_bl(2:end).^2)+(r_bl(1:end-1).^2)+r_bl(2:end).*r_bl(1:end-1))...
               ./(3*(r_bl(1:end-1)).^3.*(r_bl(2:end)).^3))...
               .^-0.25;    
    if(e<=nel/4)
        stg=1;
    elseif(e<=nel*2/4)
        stg=2;
    elseif(e<=nel*3/4)
        stg=3;
    end
    ro=r_bl(stg);
    rin=r_bl(stg+1);
    r_mid = r_bl_con(stg);
    
    if(e<=nel*3/4)
    je   = IEN(:,e);            % get the global node number.
    C    = [x(je) y(je) z(je)];  
    eg   = [1 2 3 4 1 2 3 4 5 6 7 8;
            2 3 4 1 5 6 7 8 6 7 8 5]; % 12条边的上下端
    r_1d = [r_mid rin r_mid ro ro rin rin ro r_mid rin r_mid ro];
    else
        el3=e-nel*3/4;
        je   = IEN3(:,el3);            % get the global node number.
        C    = [x(je) y(je) z(je)];  
        eg   = [1 2 3 1 2 3 4 5 6 ;
                2 3 1 4 5 6 5 6 4 ]; % 边的上下端
        r_1d = [ro r_mid r_mid ro ro rin ro r_mid r_mid];
    end
     for i = 1:size(eg,2)        
        st = je(eg(1,i));
        ed = je(eg(2,i));
        delta_z = norm(C(eg(1,i),:)-C(eg(2,i),:))/2;
        for j = 1:2
             psi = gp(j);
             N     = 0.5*[1-psi  1+psi];  
             
             hb_loc = 4.36 * kb /(2*r_1d(i));
             ke = w(j)* 2*pi*r_1d(i)*hb_loc*(delta_z)*(N'*N);
             fe = w(j)* 2*pi*r_1d(i)*hb_loc*(delta_z)*(N'*N)*Ta([st ed]);
             K([st ed],[st ed])=K([st ed],[st ed])+ke;
             f([st ed]) =   f([st ed])+ fe;
        end
    end
end



end





function [K,f]=src_mbc(K,f,Trp)
    m_bc = Trp.mbc;
    Tm   = Trp.Tm;
    makebias_h3elem;
    mbe = size(m_bc,2);
    % m_bc + heat3d
for i=1:mbe
        
        h     = m_bc(9,i);
%         Tm    = m_bc(5,i);
        
        fq        = [0 0 0 0]';                % initialize the nodal source vector  
        kq        = zeros(4,4);
        nodes     = m_bc(1:4,i);
        px = [x(nodes) y(nodes) z(nodes)];
        tri       = [1 2 4;
				     2 3 4];
    for j=1:2                %两个三角形
	    tri1=tri(j,:);
        [p1,p2,p3]=deal(px(tri1(1),:),px(tri1(2),:),px(tri1(3),:));
        nv1=cross(p2-p1,p3-p2);   
        m1 = vrrotvec2mat(vrrotvec(nv1,[0 0 1])); %m 是一个旋转矩阵 左乘向量从参数1到参数2
        src_P1=[m1*[p1;p2;p3]']';
        kq1 = gen_kq(src_P1(:,1:2),h);
        fq1 = gen_fq(src_P1(:,1:2),h,Tm);
        fq(tri1) = fq(tri1)+fq1;
        kq(tri1,tri1) = kq(tri1,tri1) + kq1;
    end
        f(nodes) = f(nodes) + fq;
        K(nodes,nodes) = K(nodes,nodes) + kq;
end

 
end
    
% small function for tetrahedron
function kq = gen_kq(src_P,h)
     kq=zeros(3,3);                 % kq初始化的矩阵秩需要参数化
%      iso_para =[eye(2);zeros(1,2)];
     [w,gp]   = gauss_tri(2);      % 四面体四点shape function不需要多余的高斯点 所以这里设为1
     gp_nodes=gp;
     for i=1:length(w)         
        psi   = gp_nodes(i,1);
        eta   = gp_nodes(i,2);
        N  =  [1-psi-eta  eta  psi];        % 2D shape functions in the parent domain
        [~,J] = BmatHeat2D_triangular(eta,psi,src_P(:,1:2));
%         J = J *0.5;                       
        kq     =kq + w(i) *N'*h*N *J;      % nodal flux   
        %                 1        20  length/2(GQ)
     end     
end
function fq=gen_fq(src_P,h,Tm)
            fq=[0 0 0]';
            [w,gp] = gauss_tri(2);
             
            gp_nodes=gp;
       for i=1:length(w)         
            psi   = gp_nodes(i,1);
            eta   = gp_nodes(i,2);
            N  =  [1-psi-eta  eta  psi];        % 2D shape functions in the parent domain
            [~,J] = BmatHeat2D_triangular(eta,psi,src_P(:,1:2));
%             J = J *0.5;
%             Tq   = N * Tm;               % interpolate flux using shape functions in 16.1 it's 20
            fq     =fq + w(i) *N' *Tm*h*J;      % nodal flux   
            %                 1        20  length/2(GQ)
       end
end