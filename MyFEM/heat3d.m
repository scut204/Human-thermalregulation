%%%%%%%%%%%%%%%%%%%%% 
% Heat conduction in 3D    % 
% zty           % 
%%%%%%%%%%%%%%%%%%%% % 
clear all; 
close all;
aaa_matfile  =  'W:\MATLAB\Human_thermalregulation\MyFEM\load_t_7_16_T20_constc.mat';

if(exist(aaa_matfile,'file')&&  1  )    % ���� 1 ���ƶ�ȡ���ݣ� 0 ���Ʋ���
    load(aaa_matfile);
%     Trp.Tm = 0;
else
        msg = '������ѪҺ��ע����֮ǰ��COȥ��';
        

    % Include global variables 
    % include_flags;
    % [Se,De,Ti_env,Tb_env]=set_env; % wrap the environment parameters
    % Trp.hb_offset = 1;
    % Preprocessing  
    [K,f,Tb,Ta,Trp] ...     % Trp parameters
         = preprocessor;   % initial K���󣬸�����������֯�¶�d��ѪҺ�¶�Tb
    % Evaluate element conductance matrix, nodal source vector and assemble
    Trp.swt_ctrl_sys= 1;
    save('Trp.mat','Trp');
    % blood K F
    b_KF.Ka = zeros(Trp.nnp); b_KF.Kb = zeros(Trp.nnp);    
    b_KF.fa = zeros(Trp.nnp,1); b_KF.fb = zeros(Trp.nnp,1);
    [sK,Cap] = heat3Delem(zeros(size(K)),Trp);      % ��������֯��K���Ծ�������ݾ�����м���

    %  ���ÿһ�������
    Trp.skin_i = unique(Trp.femtet.f([Trp.femtet.e1(:,3)],:));
    Trp.fat_i = unique(Trp.femtet.f([Trp.femtet.e2(:,3)],:));
    Trp.mus_i = unique(Trp.femtet.f([Trp.femtet.e3(:,3)],:));
    Trp.core_i = unique(Trp.femtet.f([Trp.femtet.e4(:,3)],:));
    Trp.cor_cor_i = unique(Trp.femtet.f3([Trp.femtet.e4(:,1:2)],3));
%     Trp.cor_cor_i = [cor_cor_i;126];
    % Cap = 0.01*eye(Trp.nnp);
    dK = zeros(size(K));
    df = zeros(size(f));

     % compute the blood pressure
    [Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);


    %  ������������
    %  Compute and assemble nodal boundary flux vector and point sources                
    [dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % ѪҺ�¶� 
    [dK,df] = src_mix_boundaryC(dK,df,Trp);           % Ƥ����������
     df     = src_and_flux_tetra(df,Trp);                 % Ƥ������ɢ��
     df     = src_metabolism(df,Ta,Tb,Trp);

     % ������������
    K = sK + dK;
    f = df;

    % Solution  

    [d] = solvedr(K,f);
    % d = 37 * ones(Trp.nnp,1);
    % d(fat_i) = 10;
    % [Tb,Ta,b_KF]      = solve_Tblood(d,Tb,Ta,Trp,b_KF) ; 

    initial_nm_ture;

    status = 1;
    T_reg=[1 20;0 0];
end




% ��ѭ��
for t=1:50000
    
%     % Postprocessing 
%       if (~mod(t,100)&&t>20000)
%           a = 1;
%       end
%       if (~isempty(find(diag(K)<0,1)))
%           asdasdasdasd= 1;
%       end
% % %       ���Ƥ�������¶Ⱥ��ں��¶�
      if t==T_reg(status,1)
          Trp.Tm = T_reg(status,2);
          status = status +1;
      end
      clc;
      [T_core,T_skin,T_fat,T_mus,T_core_core] = compute_T_core_and_skin(d,Trp);
      nm_ture=show_diff_tissue_blood(Tb,d,T_core,T_skin,T_fat,T_mus,Trp,nm_ture);
      
      Trp.wb_basal = compute_blood_perfusion(T_skin,T_fat,T_mus,T_core,Trp);
      Trp   =  control_system(T_core,T_skin,Trp);
      [Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);
% 
      [dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % ѪҺ�¶�
      [dK,df] = src_mix_boundaryC(dK,df,Trp);           % Ƥ����������
      df      = src_and_flux_tetra(df,Trp);                 % Ƥ������ɢ��
      df      = src_metabolism(df,Ta,Tb,Trp);            
      dK=.5*dK;df=.5*df;      % �� dK�� dF ������
%       detK = sum(sum(sK+dK-K))    % ����֤����ÿһ����֯��K���󲻻�����仯
      K = sK + dK;      %  �൱�� (K+K_) /2 
      f = df ;
%       
      
      theta = 0.5;
      [d] = solvedr(Cap+theta*Trp.dtime*(K),(Cap-(1-theta)*Trp.dtime*K)*d + Trp.dtime*f);  % 
%       [d] = solvedr(K,f);
      [Tb,Ta,b_KF]      = solve_Tblood(d,Tb,Ta,Trp,b_KF) ; 
      
end
save_env;
%  postprocessor(d);
      