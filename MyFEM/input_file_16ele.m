% Input file for Example  8.1 (16-element mesh) 

% 读取人体的有限元特征
load('body2.mat');
femtet=femread_bodypart_v2(lowerleftleg);
femtet.v=femtet.v*2;   % 将尺寸double一倍以符合正常标准
Bool_main=1; % main programs

% material properties 
kd    = [7.52 5.8 15.1 82.0]./3600;            % thermal conductivity 
% D    = kd*eye(3);     % conductivity matrix 
dtime= 0.1;
dens = [1.0 0.85 1.05 1.70] ;
spech= [3.77 2.51 3.77 1.59];

%
skin_A = compute_skin_area(femtet);
% blood properties
visc = 2.87e-3;      % (pa*s)
kb   = 18.7/3600;
r_max   = 0.9;                      % 血管最大半径
r0 = r_max ;
r0_skin = 0.0430;                % 皮肤血管半径
R0_control = [r0_skin r0_skin*2 r0_skin/2];% 主动控制系统参数
r1 = r0/2;
r1_skin = r0_skin/2;
R1_control = R0_control/2;
bldepth = [1 4];   % 指定血管的影响范围 1 2 3 4 分别代表环与环之间的边界
densb= 1.06;
speHtb = 4.0;
hb_offset   = 1/(femtet.floors * femtet.num_cirp /(4*5))/2;     % 修改 热流系数比例
wb_basal = [0.07 0.0003 0.03 0]/60;    % cm3/s
Trp.wb_basal_BASE = [0.07 0.0003 0.03 0]/60;    % cm3/s 常数
sk_bloodflow = [1456 12453 0];
RH = 0.5;  % the relative humidity is 50%
meta_and_capill = [0.06 0.0002 0.0004 0]/60;   % basal metabolism
mus_vol = computer_muscle_volume(femtet,3) ;
fat_vol = computer_muscle_volume(femtet,2);
skin_vol= computer_muscle_volume(femtet,1);
bone_vol= 0 ;
M_shiv = 0.000;
CO = 6196/3600  ; % 第一项是心脏的位置 第二项是CO
m_rsw = 0;


% mesh specifications 

if Bool_main
    nnp    = femtet.num_point;             % number of nodes
    nel    = femtet.num_element;             % number of elements 
end

nen    = 8;             % number of element nodes  
ndof   = 1;             % number of degrees-of-freedom per node 
neq    = nnp*ndof;      % number of equations 
ngp    = 3;                            % number of Gauss points in each direction 

f   = zeros(neq,1);        % initialize nodal flux vector 
d   = zeros(neq,1);        % initialize nodal temperature vector 
K   = zeros(neq);          % initialize conductance matrix 
Cap = zeros(neq);          % initialize Capacity matrix

flags   = zeros(neq,1);    % array to set B.C flags  
e_bc    = zeros(neq,1);    % essential B.C array 
n_bc    = zeros(neq,1);    % natural B.C array 
P      = zeros(neq,1);            % initialize point source vector defined at a node  
s       = ones(nen,nel);    % heat source defined over the nodes 

  
% essential B.C. 
if Bool_main
    nd   = 0;           % number of nodes on essential boundary 
else
    [flags,e_bc,nd]=set_ebc(femtet,flags,e_bc);    % 这里输入
end


 % what to plot 
compute_flux   = 'yes'; 
plot_mesh      = 'yes'; 
plot_nod       = 'yes'; 
plot_temp      = 'yes'; 
plot_flux      = 'yes'; 

% what to compute
compt_bld_p = 1;
compt_bld_t = 1;
compt_metb  = 1;
compt_airt  = 1;    % 还没有使用
swt_ctrl_sys= 1;
compt_skin_env = 1 ;     % 必不可少，  确定组织温度的参考值


% natural B.C  - defined on edges positioned on the natural boundary 
Tm = 28;
[n_bc,nbe]=set_nbc(femtet);

% blood temperature initialization
Tb = 37 * ones(nnp,1);
Ta = 37 * ones(nnp,1);
% mix B.C     _ defined on the face which describes the convection,
% insulation or other 
[m_bc,mbe,h] = set_mbc(femtet);

% mesh generation 
if ~Bool_main
    mesh_test; 
    show_nbc_test;
else
    mesh3d;
end
%  
 function [flags,e_bc,nd]=set_ebc(femtet,flags,e_bc)
    % 可以修改的脚本 下同
    ndlist_re=femtet.f(femtet.e3(:,4),:);      %  取元素的最表面温度作为37度
    ndlist=ndlist_re(:);
    ndlist=unique(ndlist,'stable');
    flags(ndlist)=2;
    nd=length(ndlist);
    e_bc(ndlist)=37;
 end
 
 function [n_bc,nbe]=set_nbc(femtet)
    % 设置皮肤表面的水蒸气散热
       % 经验公式一般是用摄氏度
       % 用来注册皮肤表面的NBC条件，方便后面的参数传导
    skin_q=0;    
    n_bc=[   femtet.f(femtet.e1(:,3),:)';skin_q*ones(4,size(femtet.e1,1))]; 
    nbe=size(n_bc,2);
 end
 
 function [m_bc,mbe,h]=set_mbc(femtet)
    h_R = 4.2e-4;
    h_c=  3.61e-4;
    h = h_c+h_R ;

    m_bc = [femtet.f(femtet.e1(:,3),:)';
            h * ones(1,size(femtet.e1,1))];    
    mbe=size(m_bc,2);
 end
 
 function A = compute_skin_area(femtet)
    A = 0;
    for i=1:size(femtet.e1,1)
        je = femtet.f(femtet.e1(i,3),:);
        tri_v = [femtet.v(je(1:3),:);femtet.v(je(2:4),:)];
        S = norm(cross(tri_v(2,:)-tri_v(1,:),tri_v(3,:)-tri_v(1,:)))...
            +norm(cross(tri_v(5,:)-tri_v(4,:),tri_v(6,:)-tri_v(4,:)));
        A = A+S;
    end
 end
 
 function mus_vol = computer_muscle_volume(femtet,et)
    mus_vol = 0 ;
    eta = 0;             
    psi = 0; 
    omega=0;
    switch et
        case 1
            ele = femtet.e1;
        case 2
            ele = femtet.e2;
        case 3
            ele = femtet.e3;
        case 4
            return;
    end
    w = 8;  % w = wx * wy * wz = 2*2*2; 
    GN      = 0.125 * [(eta-1)*(1-omega)   (1-eta)*(1-omega)    (1+eta)*(1-omega)   (-eta-1)*(1-omega) (eta-1)*(1+omega)   (1-eta)*(1+omega)    (1+eta)*(1+omega)   (-eta-1)*(1+omega); 
                       (psi-1)*(1-omega)   (-psi-1)*(1-omega)   (1+psi)*(1-omega)   (1-psi)*(1-omega)  (psi-1)*(1+omega)   (-psi-1)*(1+omega)   (1+psi)*(1+omega)   (1-psi)*(1+omega);
                       (psi-1)*(1-eta)	   (1+psi)*(eta-1)		-1*(1+psi)*(1+eta)	(psi-1)*(1+eta)    (1-psi)*(1-eta)	   (1+psi)*(1-eta)		(1+psi)*(1+eta)	    (1-psi)*(1+eta)]; 
  
    for i = 1 : size(ele,1)
           je = [femtet.f([ele(i,5)],:)  femtet.f(ele(i,6),:)];
           C = femtet.v(je,:);
            J       = GN*C;         % Get the Jacobian matrix  
            detJ    = det(J);       % Jacobian           
            mus_vol  = mus_vol + w*abs(detJ);     % element conductance matrix 
    end
 end
 
 function V = computer_total_volume(femtet)
    
 end