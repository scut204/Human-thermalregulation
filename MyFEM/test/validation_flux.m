figure(1);
hold on;
view(3)
for i=2:30:femtet.num_element/3

%         XX = [x(IEN(1,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(4,i)) x(IEN(1,i))]; 
%         YY = [y(IEN(1,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(4,i)) y(IEN(1,i))];
%         ZZ = [z(IEN(1,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(4,i)) z(IEN(1,i))];
%         plot3(XX,YY,ZZ,'b');
%         XX = [ x(IEN(5,i)) x(IEN(6,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(5,i))]; 
%         YY = [ y(IEN(5,i)) y(IEN(6,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(5,i))];
%         ZZ = [ z(IEN(5,i)) z(IEN(6,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(5,i))];
%         plot3(XX,YY,ZZ,'b');
%         for k=1:4
%                 XX=[x(IEN(k,i)) x(IEN(k+4,i))];
%                 YY=[y(IEN(k,i)) y(IEN(k+4,i))];
%                 ZZ=[z(IEN(k,i)) z(IEN(k+4,i))];
%                 plot3(XX,YY,ZZ,'b');
%         end
        XX = [ x(IEN(1,i)) x(IEN(4,i)) x(IEN(8,i)) x(IEN(5,i)) x(IEN(1,i))]; 
        YY = [ y(IEN(1,i)) y(IEN(4,i)) y(IEN(8,i)) y(IEN(5,i)) y(IEN(1,i))];
        ZZ = [ z(IEN(1,i)) z(IEN(4,i)) z(IEN(8,i)) z(IEN(5,i)) z(IEN(1,i))];
        plot3(XX,YY,ZZ,'b');
end        

for e  = 2:30:450
%     fprintf(1,'Element  %d \n',e) 
%     fprintf(1,'-------------\n')       

include_flags; 

debug = 1;
if debug
    plot_mesh='yes';
    plot_flux='yes';
end

de   = d(LM(:,e));    % extract temperature at element nodes 
  
% get coordinates of element nodes  
je   = IEN(:,e);   
C    = [x(je) y(je) z(je)];  

sdno=[1 4 8 5]; 
nv=norm_vector(C(sdno,:));

nopt=2;
[~,gp]   = gauss(nopt);   % get Gauss points and weights 
  
% compute flux vector  
ind = 1; 
psi= -1;
for i=1:nopt 
   for j=1:nopt
           eta  = gp(i);             
           omega  = gp(j); 
          

           N     = NmatHeat3D(eta,psi,omega); % shape functions matrix  

           [B, ~]      = BmatHeat3D(eta,psi,omega,C); % derivative of the shape functions 
           X(ind,:)   =  N*C;          % Gauss points in physical coordinates  
           q(:,ind)   =  -D*B*de;        % compute flux vector 
           ind       = ind + 1; 
       
   end 
end 
q_x = q(1,:);
q_y = q(2,:);
q_z = q(3,:);
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
% disp(e)
% q_v
plot_qv=[plot_qv q_v];
% fprintf(1,'\t\t\t%f\t\t\t%f\t\t\t%f\t\t\t%f\n',flux_e1'); 
  
if strcmpi(plot_flux,'yes')==1 & strcmpi(plot_mesh,'yes') ==1;   
    figure(1);  
    quiver3(X(:,1),X(:,2),X(:,3),q_x',q_y',q_z','k'); 
%     plot3(X(:,1),X(:,2),X(:,3),'ro'); 
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
