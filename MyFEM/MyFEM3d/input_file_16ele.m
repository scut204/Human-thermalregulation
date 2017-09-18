% Input file for Example  8.1 (16-element mesh) 

% 读取人体的有限元特征
load('body.mat');
femtet=femread_bodypart(lowerleftleg)




% material properties 
k    = 5;            % thermal conductivity 
D    = k*eye(3);     % conductivity matrix 
dtime= 0.1;
dens = 1.05;
spech= 3.69;

% mesh specifications 
nsd    = 3;             % number of space dimensions 
nnp    = femtet.num_point;             % number of nodes 
nel    = femtet.num_element;             % number of elements 
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
  
ngp    = 2;                            % number of Gauss points in each direction 
  
% essential B.C. 
% flags(1:2)  = 2;    e_bc(1:2)       = 0.0; 
% % flags(6:5:21)   = 2;         e_bc(6:5:21)    = 0.0; 
% nd   = 2;           % number of nodes on essential boundary 
[flags,e_bc,nd]=set_ebc(femtet);


 % what to plot 
compute_flux   = 'yes'; 
plot_mesh      = 'yes'; 
plot_nod       = 'yes'; 
plot_temp      = 'yes'; 
plot_flux      = 'yes'; 
   
% natural B.C  - defined on edges positioned on the natural boundary 
% n_bc     = [       5          % node1 
%                    6                 % node2 
%                    7
%                    8
%                    -20               % flux value at node 1  
%                    -20 
%                    -20
%                    -20  ];        % flux value at node 2  
% nbe = 1;                 % number of edges on the natural boundary 
[n_bc,nbe]=set_nbc(femtet);

% mesh generation 
 mesh2d;  
 
 function [flags,e_bc,nd]=set_ebc(femtet)
    % 可以修改的脚本 下同
    ndlist_re=femtet.f(femtet.e3(:,4),1);
    ndlist=ndlist_re(:);
%     ndlist=unique(ndlist);
    flags(ndlist)=2;
    nd=length(ndlist);
    e_bc(ndlist)=37;
 end
 
 function [n_bc,nbe]=set_nbc(femtet)
    skin_q=-5;
    n_bc=[   femtet.f(femtet.e1(:,3),:)';skin_q*ones(4,size(femtet.e1,1))];
    nbe=size(n_bc,2);
 end