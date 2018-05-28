%%%%%%%%%%%%%%%%%%%%% 
% Heat conduction in 3D    % 
% zty           % 
%%%%%%%%%%%%%%%%%%%% % 
clear all; 
close all;  

% Include global variables 
% include_flags;
% [Se,De,Ti_env,Tb_env]=set_env; % wrap the environment parameters

% Preprocessing  
[K,f,d,Tb,Ta,Trp] ...     % Trp parameters
     = preprocessor;   % initial K���󣬸�����������֯�¶�d��ѪҺ�¶�Tb
% Evaluate element conductance matrix, nodal source vector and assemble 
save('forvalid.mat','Trp');
[sK,Cap] = heat3Delem(zeros(Trp.nnp,Trp.nnp),Trp);      % ��������֯��K���Ծ�������ݾ�����м���
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
[d] = solvedr(K,f,d);
[Tb,Ta]      = solve_Tblood(d,Tb,Ta,Trp) ; 
% postprocessor(d);
nm_ture.nd = []; nm_ture.nT = [];
nm_ture.Tcor = []; nm_ture.Tsk=[];
nm_ture.Tfat = []; nm_ture.Tmus=[];
% if(exist('load_t.mat'))
%     load('load_t.mat');
% end
for t=1:5000
    
    
    % Postprocessing 
      
% %       ���Ƥ�������¶Ⱥ��ں��¶�
      [T_core,T_skin,T_fat,T_mus] = compute_T_core_and_skin(d,Trp);
      Trp=control_system(T_core,T_skin,Trp);
      
      [Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);

      [dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % ѪҺ�¶�
      [dK,df] = src_mix_boundaryC(dK,df,Trp);           % Ƥ����������
      df      = src_and_flux_tetra(df,Trp);                 % Ƥ������ɢ��
      df      = src_metabolism(df,Ta,Tb,Trp);            
      dK=.5*dK;df=.5*df;      % �� dK�� dF ������

      K = sK + dK;      % �൱�� (K+K_) /2 
      f = df ;
      

%       [d,f_E] = solvedr(K,f,d);
      theta = 0.5;
      [d] = solvedr(Cap+theta*Trp.dtime*(K),(Cap-(1-theta)*Trp.dtime*K)*d + Trp.dtime*f,d);  % 
      [Tb,Ta]      = solve_Tblood(d,Tb,Ta,Trp) ; 
   
      nm_ture=show_diff_tissue_blood(Tb,d,T_core,T_skin,T_fat,T_mus,nm_ture);
end
figure,1;
plot(nm_ture.nT);hold on;
plot(nm_ture.nd);

figure,2;
plot(nm_ture.Tcor);hold on;
plot(nm_ture.Tsk);
plot(nm_ture.Tmus);
plot(nm_ture.Tfat);
save('load_t.mat');
saveas(gcf,'save.jpg');
%  postprocessor(d);
      