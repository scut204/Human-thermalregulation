%%%%%%%%%%%%%%%%%%%%% 
% Heat conduction in 3D    % 
% zty           % 
%%%%%%%%%%%%%%%%%%%% % 
clear all; 
close all;
aaa_matfile  =  'W:\MATLAB\Human_thermalregulation\MyFEM\load_t0_nob.mat';
if(exist(aaa_matfile,'file')&&  1  )    % ���� 1 ���ƶ�ȡ���ݣ� 0 ���Ʋ���
    load(aaa_matfile);
    Trp.Tm = 9;
else
% Include global variables 
% include_flags;
% [Se,De,Ti_env,Tb_env]=set_env; % wrap the environment parameters

% Preprocessing  
[K,f,Tb,Ta,Trp] ...     % Trp parameters
     = preprocessor;   % initial K���󣬸�����������֯�¶�d��ѪҺ�¶�Tb
% Evaluate element conductance matrix, nodal source vector and assemble 
save('Trp.mat','Trp');
% blood K F
b_KF.Ka = zeros(Trp.nnp); b_KF.Kb = zeros(Trp.nnp);    
b_KF.fa = zeros(Trp.nnp,1); b_KF.fb = zeros(Trp.nnp,1);
[sK,Cap] = heat3Delem(zeros(size(K)),Trp);      % ��������֯��K���Ծ�������ݾ�����м���
dK = zeros(size(K));
df = zeros(size(f));

 % compute the blood pressure
[Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);



%  Compute and assemble nodal boundary flux vector and point sources                
[dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % ѪҺ�¶� 
[dK,df] = src_mix_boundaryC(dK,df,Trp);           % Ƥ����������
 df =     src_and_flux_tetra(df,Trp);                 % Ƥ������ɢ��
 df =     src_metabolism(df,Ta,Tb,Trp);

 % ������������
K = sK + dK;
f = df;

% Solution  
[d] = solvedr(K,f);
[Tb,Ta,b_KF]      = solve_Tblood(d,Tb,Ta,Trp,b_KF) ; 
% postprocessor(d);
nm_ture.nd = []; nm_ture.nT = [];
nm_ture.Tcor = []; nm_ture.Tsk=[];
nm_ture.Tfat = []; nm_ture.Tmus=[];
end
for t=1:100000
    
    % Postprocessing 
      
% %       ���Ƥ�������¶Ⱥ��ں��¶�
      [T_core,T_skin,T_fat,T_mus] = compute_T_core_and_skin(d,Trp);
% %       Trp=control_system(T_core,T_skin,Trp);
%       [Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);
% 
%       [dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % ѪҺ�¶�
      [dK,df] = src_mix_boundaryC(dK,df,Trp);           % Ƥ����������
      df      = src_and_flux_tetra(df,Trp);                 % Ƥ������ɢ��
      df      = src_metabolism(df,Ta,Tb,Trp);            
      dK=.5*dK;df=.5*df;      % �� dK�� dF ������

      K = sK + dK;      %  �൱�� (K+K_) /2 
      f = df ;
      

      theta = 0.5;
      [d] = solvedr(Cap+theta*Trp.dtime*(K),(Cap-(1-theta)*Trp.dtime*K)*d + Trp.dtime*f);  % 
%       [Tb,Ta,b_KF]      = solve_Tblood(d,Tb,Ta,Trp,b_KF) ; 
   
      nm_ture=show_diff_tissue_blood(Tb,d,T_core,T_skin,T_fat,T_mus,nm_ture);
end
save_env;
%  postprocessor(d);
      