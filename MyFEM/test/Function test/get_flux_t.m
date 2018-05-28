
function get_flux(d,e); 
include_flags; 

debug = 1;
if debug
    plot_mesh='yes';
    plot_flux='yes';
else
    plot_mesh='no';
    plot_flux='no';
end

de   = d(LM(:,e));    % extract temperature at element nodes 
  
% get coordinates of element nodes  
je   = IEN(:,e);   
C    = [x(je) y(je) z(je)];  

% sdno=[1 4 8 5]; 
sdno=[5 6 7 8];
nv=norm_vector(C(sdno,:));
% nv2=norm_vector(C(sdno(2:4),:));

nopt=1;
[~,gp]   = gauss(nopt);   % get Gauss points and weights 
  
% compute flux vector  
ind = 1;
omega= 1;
for i=1:nopt 
   for j=1:nopt
           eta  = gp(i);             
           psi  = gp(j); 
           
           N     = NmatHeat3D(eta,psi,omega); % shape functions matrix  

           [B, ~]      = BmatHeat3D(eta,psi,omega,C); % derivative of the shape functions 
           X(ind,:)   =  N*C;          % Gauss points in physical coordinates  
           q(:,ind)   =  -D*B*de;        % compute flux vector 
           ind       = ind + 1; 
       
   end 
end 
q_norm=sqrt(sum(q.^2,1));
q_x = q(1,:)/q_norm;
q_y = q(2,:)/q_norm;
q_z = q(3,:)/q_norm;
%{
    q=[x x x x ...
       y y y y ...
       z z z z ...];
%}
q_v = abs(sum(q.*repmat(nv',1,size(q,2))));  
%          #x-coord     y-coord    q_x(eta,psi)  q_y(eta,psi) 
% q
% fprintf(1,'\t\t\tx-coord\t\t\t\ty-coord\t\t\t\tq_x\t\t\t\t\tq_y\n'); 
% fprintf(1,'\t\t\tx-coord\t\t\t\ty-coord\t\t\t\tq_x\t\t\t\t\tq_y\n'); 
disp(e)
q_v
plot_qv=[plot_qv q_v];
% fprintf(1,'\t\t\t%f\t\t\t%f\t\t\t%f\t\t\t%f\n',flux_e1'); 
  
if strcmpi(plot_flux,'yes')==1 & strcmpi(plot_mesh,'yes') ==1;   
    figure(1);  
    quiver3(X(:,1),X(:,2),X(:,3),q_x',q_y',q_z','k'); 
    plot3(X(:,1),X(:,2),X(:,3),'ro'); 
    title('Heat Flux'); 
    xlabel('X'); 
    ylabel('Y'); 
end

end
function nv=norm_vector(C)
    m1=C(2,:)-C(3,:);
    m2=C(2,:)-C(1,:);
    avec=cross(m1,m2);
    nv=avec/dot(avec,avec,2).^(1/2);
end
