function plotmesh; 
include_flags; 
  
if strcmpi(plot_mesh,'yes')==1;   
% plot natural BC 
% for i=1:nbe 
%      
%         node1 = n_bc(1,i);            % first node 
%         node2 = n_bc(2,i);            % second node 
%         x1 = x(node1); y1=y(node1);      % coordinates of the first node 
%         x2 = x(node2); y2=y(node2);      % coordinates of the second node 
%   
%         plot([x1 x2],[y1 y2],'r','LineWidth',4); hold on 
% end 
%  
% legend('natural B.C. (flux)'); 
  
for i = 1:nel 
        XX = [x(IEN(1,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(4,i)) x(IEN(1,i))]; 
        YY = [y(IEN(1,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(4,i)) y(IEN(1,i))];
        ZZ = [z(IEN(1,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(4,i)) z(IEN(1,i))];
        plot3(XX,YY,ZZ);hold on;
        XX = [ x(IEN(5,i)) x(IEN(6,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(5,i))]; 
        YY = [ y(IEN(5,i)) y(IEN(6,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(5,i))];
        ZZ = [ z(IEN(5,i)) z(IEN(6,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(5,i))];
        plot3(XX,YY,ZZ);hold on;
        XX = [ x(IEN(1,i)) x(IEN(5,i)) x(IEN(6,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(4,i))]; 
        YY = [ y(IEN(1,i)) y(IEN(5,i)) y(IEN(6,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(4,i))];
        ZZ = [ z(IEN(1,i)) z(IEN(5,i)) z(IEN(6,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(4,i))];
        plot3(XX,YY,ZZ);hold on;
        
        
        if strcmpi(plot_nod,'yes')==1;    
            text(XX(1),YY(1),ZZ(1),sprintf('%0.5g',IEN(1,i))); 
            text(XX(2),YY(2),ZZ(2),sprintf('%0.5g',IEN(2,i))); 
            text(XX(3),YY(3),ZZ(3),sprintf('%0.5g',IEN(3,i))); 
            text(XX(4),YY(4),ZZ(4),sprintf('%0.5g',IEN(4,i))); 
            text(XX(5),YY(5),ZZ(5),sprintf('%0.5g',IEN(5,i))); 
            text(XX(6),YY(6),ZZ(6),sprintf('%0.5g',IEN(6,i))); 
            text(XX(7),YY(7),ZZ(7),sprintf('%0.5g',IEN(7,i))); 
            text(XX(8),YY(8),ZZ(8),sprintf('%0.5g',IEN(8,i))); 
        end 
end 
end 
  
fprintf(1,'  Mesh Params \n'); 
fprintf(1,'No. of Elements  %d \n',nel); 
fprintf(1,'No. of Nodes     %d \n',nnp); 
fprintf(1,'No. of Equations %d \n\n',neq); 