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
     = preprocessor;   % initial K矩阵，负载向量，组织温度d，血液温度Tb
% Evaluate element conductance matrix, nodal source vector and assemble 
save('forvalid.mat','Trp');
[sK,Cap] = heat3Delem(zeros(Trp.nnp,Trp.nnp),Trp);      % 仅仅对组织的K刚性矩阵和热容矩阵进行计算
dK = zeros(size(K));
df = zeros(size(f));

 % compute the blood pressure
[Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);



%  Compute and assemble nodal boundary flux vector and point sources                
[dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % 血液温度
[dK,df] = src_mix_boundaryC(dK,df,Trp);           % 皮肤对流辐射
 df =     src_and_flux_tetra(df,Trp);                 % 皮肤蒸发散热
 df =     src_metabolism(df,Ta,Tb,Trp);

 % 整合所有条件
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
      
% %       获得皮肤表面温度和内核温度
      [T_core,T_skin,T_fat,T_mus] = compute_T_core_and_skin(d,Trp);
      Trp=control_system(T_core,T_skin,Trp);
      
      [Trp.prsa,Trp.prsb]  = blood_and_respiratory_1D(Trp);

      [dK,df] = src_mix_boundaryC(dK,df,Trp,'blood',Tb,Ta);   % 血液温度
      [dK,df] = src_mix_boundaryC(dK,df,Trp);           % 皮肤对流辐射
      df      = src_and_flux_tetra(df,Trp);                 % 皮肤蒸发散热
      df      = src_metabolism(df,Ta,Tb,Trp);            
      dK=.5*dK;df=.5*df;      % 对 dK与 dF 做更新

      K = sK + dK;      % 相当于 (K+K_) /2 
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
      