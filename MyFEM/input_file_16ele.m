% Input file for Example  8.1 (16-element mesh) 

% 读取人体的有限元特征
load('body.mat');
femtet=femread_bodypart_v2(lowerleftleg)

Bool_main=1; % test elements


% material properties 
k    = 5;            % thermal conductivity 
D    = k*eye(3);     % conductivity matrix 
dtime= 0.1;
dens = 1.05;
spech= 3.69;

% mesh specifications 
nsd    = 3;             % number of space dimensions 
nnp    = 12;
nel    = 2;             % 
if Bool_main
    nnp    = femtet.num_point;             % number of nodes
    nel    = femtet.num_element;             % number of elements 
end

nen    = 8;             % number of element nodes  
ndof   = 1;             % number of degrees-of-freedom per node 
neq    = nnp*ndof;      % number of equations 
  
f   = zeros(neq,1);        % initialize nodal flux vector 
d   = zeros(neq,1);        % initialize nodal temperature vector 
K   = zeros(neq);          % initialize conductance matrix 
Cap = zeros(neq);          % initialize Capacity matrix

flags   = zeros(neq,1);    % array to set B.C flags  
e_bc    = zeros(neq,1);    % essential B.C array 
n_bc    = zeros(neq,1);    % natural B.C array 
P      = zeros(neq,1);            % initialize point source vector defined at a node  
s       = zeros(nen,nel);    % heat source defined over the nodes 
  
ngp    = 3;                            % number of Gauss points in each direction 
  
% essential B.C. 
if Bool_main
%     flags(1:2)  = 2;    e_bc(1:2)       = 37; 
    nd   = 0;           % number of nodes on essential boundary 
else
    [flags,e_bc,nd]=set_ebc(femtet,flags,e_bc);
end


 % what to plot 
compute_flux   = 'yes'; 
plot_mesh      = 'yes'; 
plot_nod       = 'yes'; 
plot_temp      = 'yes'; 
plot_flux      = 'yes'; 
   
% natural B.C  - defined on edges positioned on the natural boundary 
if Bool_main
%     n_bc     = [       9          % node1 
%                        10                % node2 
%                        11
%                        12
%                        -20               % flux value at node 1  
%                        -20 
%                        -20
%                        -20  ];        % flux value at node 2  
    nbe = 0;                 % number of edges on the natural boundary 
else
    [n_bc,nbe]=set_nbc(femtet);
end

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
    skin_q=0;
    n_bc=[   femtet.f(femtet.e1(:,3),:)';skin_q*ones(4,size(femtet.e1,1))]; 
    nbe=size(n_bc,2);
 end
 
 function [m_bc,mbe,h]=set_mbc(femtet)
    h = 2.0;
    Tm = 37;
    m_bc = [femtet.f(femtet.e3(:,4),:)';Tm * ones(4,size(femtet.e3,1))];
    mbe=size(m_bc,2);
 end