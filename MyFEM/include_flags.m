% % file to include global variables 
% global  ndof nnp nel nen nsd neq ngp nee  
% global  nd e_bc s P kd
% % global  LM ID
% global  IEN IEN3 flags n_bc  m_bc 
% global  x y z nbe mbe 
% global  compute_flux plot_mesh plot_temp plot_flux plot_nod      % 控制变量
% global  dtime dens spech                                              % time-domain
% global  femtet                                             % 有限元点
% global  visc r0 densb speHtb prsa prsb hb  r0_skin r1 r1_skin CO  kb % 血液属性
% global  skin_A Tm
% global m_rsw                       % 汗蒸发量
% global meta_and_capill M_shiv R0_control 
% % debug global variables
% global J_pr plot_qv


% system control set
Sys_ctr_para.compute_flux = compute_flux;
Sys_ctr_para.plot_mesh = plot_mesh;
Sys_ctr_para.plot_temp = plot_temp;
Sys_ctr_para.plot_flux = plot_flux;
Sys_ctr_para.plot_nod = plot_nod;

% bodypart tissue stiffness matrix parameters
Trp.nnp = nnp;
Trp.nen = nen;
Trp.nel = nel;
Trp.IEN = IEN;
Trp.IEN3 = IEN3;
Trp.x = x;
Trp.y = y;
Trp.z = z;
Trp.kd=kd;
Trp.dens=dens;
Trp.spech=spech;
Trp.ngp = ngp;

% blood and respiratory 
Trp.femtet =femtet  ;
Trp.CO     =CO      ;
Trp.r0     =r0      ;
Trp.r0_skin=r0_skin ;
Trp.r1_skin=r1_skin ;
Trp.r1     =r1      ;
Trp.visc   =visc    ;
Trp.kb     = kb     ;
Trp.densb=densb;
Trp.speHtb=speHtb;
Trp.wb_basal=wb_basal;
% src_mix_boundaryC
Trp.mbc=m_bc;

% src_and_flux_tetra
Trp.nbc=n_bc;
Trp.m_rsw=m_rsw;
Trp.Tm=Tm;

% src_metabolism
Trp.s = s;
Trp.meta_and_capill=meta_and_capill;
Trp.M_shiv=M_shiv;
Trp.RH =RH;

Trp.dtime = dtime;
Trp.skin_A=skin_A;
Trp.R0_control=R0_control;

% regulation of all para





