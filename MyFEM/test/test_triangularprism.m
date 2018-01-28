% 测试两个三角柱的有限元模拟情况
% 顶面设置NBC 为-5的热量
% 底面设置EBC 为 37度
% 在运行过‘heat3d.m’后运行
include_flags; 
%  随机抽取第n个元素 里面拆分两个三角柱
n=4;
je   = IEN(:,n);            % get the global node number.
C    = [x(je) y(je) z(je)];  
perm =  [1 4 5 2 3 6 ;
         8 5 4 7 6 3 ];
[wt,gpt] = gauss_tri;
[w,gp]   = gauss(ngp);      % get Gauss points and weights 

% 先检查三角柱的5个面是否都处于同一面

test_midface=[4 5 6 3];
% nv=norm_vector(C(test_midface,:));
% m1 = vrrotvec2mat(vrrotvec(nv,[0 0 1]));
% src_P1=(m1*[C(test_midface,:)]')'
ed1=C(5,:)-C(4,:);
ed2=C(6,:)-C(3,:);
ed1./ed2



% 得到K 矩阵

% for i=1:2    % 两个三角形
%        for m=1:ngp
%         eta = gpt;             
%         psi = gpt; 
%         omega=gp(m);
%                 
%         N     = NmatHeat3D_triprism(eta,psi,omega); % shape functions matrix  
%        
%         [B, detJ]      = BmatHeat3D_triprism(eta,psi,omega,C(perm(i,:),:)); % derivative of the shape functions 
%         ke(perm(i,:),perm(i,:))  = ke(perm(i,:),perm(i,:)) + wt*w(m)*B'*D*B*detJ;     % element conductance matrix 
% %        se  = N*s(:,e);                         % compute s(x) 
% %        Cape   = Cape + wt*w(m)*N'*dens*spech*N*detJ; 
% %        fe   = fe + w(i)*w(j)*w(m)*N'*se*detJ;      % element nodal source vector  
%        end
% %    end    
% end


function nv=norm_vector(C)
    m1=C(2,:)-C(3,:);
    m2=C(2,:)-C(1,:);
    avec=cross(m1,m2);
    nv=avec/dot(avec,avec,2).^(1/2);
end