function mesh2d; 
include_flags; 
% 这里只需要把元素与点序号对应起来

x=femtet.v(:,1);
y=femtet.v(:,2);
z=femtet.v(:,3);

% 元素的输入需不需要先后顺序？

% generate connectivity array IEN 
% rowcount = 0;
% layercount = 0;
% for elementcount = 1:nel 
%       IEN(1,elementcount)   = elementcount + rowcount + layercount; 
%       IEN(2,elementcount)   = elementcount + 1 + rowcount + layercount; 
%       IEN(3,elementcount)   = elementcount + (lp + 1) + rowcount + layercount; 
%       IEN(4,elementcount)   = elementcount + (lp) + rowcount + layercount;
%       IEN(5,elementcount)   = IEN(1,elementcount) + lp*lp ;
%       IEN(6,elementcount)   = IEN(2,elementcount) + lp*lp ;
%       IEN(7,elementcount)   = IEN(3,elementcount) + lp*lp ;
%       IEN(8,elementcount)   = IEN(4,elementcount) + lp*lp ;
%       if mod(elementcount,lp-1) == 0 
%             rowcount   = rowcount + 1; % element less than node by 1.
%       end 
%       if mod(elementcount,(lp-1)*(lp-1)) == 0 
%             rowcount   = 0; 
%             layercount = layercount+9;
%       end 
% end 

% 从最外圈到最内圈
IEN=[femtet.f([femtet.e1(:,1) femtet.e2(:,1) femtet.e3(:,1)],:)';
	 femtet.f([femtet.e1(:,2) femtet.e2(:,2) femtet.e3(:,2)],:)' ];

% plot mesh and natural boundary  
% plotmesh; 

i = 1; 
        XX = [x(IEN(1,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(4,i)) x(IEN(1,i))]; 
        YY = [y(IEN(1,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(4,i)) y(IEN(1,i))];
        ZZ = [z(IEN(1,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(4,i)) z(IEN(1,i))];
        plot3(XX,YY,ZZ);hold on;
        XX = [ x(IEN(5,i)) x(IEN(6,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(5,i))]; 
        YY = [ y(IEN(5,i)) y(IEN(6,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(5,i))];
        ZZ = [ z(IEN(5,i)) z(IEN(6,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(5,i))];
        plot3(XX,YY,ZZ);
        for k=1:4
                XX=[x(IEN(k,i)) x(IEN(k+4,i))];
                YY=[y(IEN(k,i)) y(IEN(k+4,i))];
                ZZ=[z(IEN(k,i)) z(IEN(k+4,i))];
                plot3(XX,YY,ZZ);
        end
        
%         if strcmpi(plot_nod,'yes')==1;    
%         WARNING!! 
%        Don't run this code!
%        crash!
%             text(x(IEN(1,i)),y(IEN(1,i)),z(IEN(1,i)),sprintf('%0.5g',IEN(1,i))); 
%             text(x(IEN(2,i)),y(IEN(2,i)),z(IEN(2,i)),sprintf('%0.5g',IEN(2,i))); 
%             text(x(IEN(3,i)),y(IEN(3,i)),z(IEN(3,i)),sprintf('%0.5g',IEN(3,i))); 
%             text(x(IEN(4,i)),y(IEN(4,i)),z(IEN(4,i)),sprintf('%0.5g',IEN(4,i))); 
%             text(x(IEN(5,i)),y(IEN(5,i)),z(IEN(5,i)),sprintf('%0.5g',IEN(5,i))); 
%             text(x(IEN(6,i)),y(IEN(6,i)),z(IEN(6,i)),sprintf('%0.5g',IEN(6,i))); 
%             text(x(IEN(7,i)),y(IEN(7,i)),z(IEN(7,i)),sprintf('%0.5g',IEN(7,i))); 
%             text(x(IEN(8,i)),y(IEN(8,i)),z(IEN(8,i)),sprintf('%0.5g',IEN(8,i))); 
%             text(XX(1),YY(1),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(2),YY(2),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(3),YY(3),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(4),YY(4),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(5),YY(5),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(6),YY(6),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(7),YY(7),ZZ(1),sprintf('%0.5g','o')); 
%             text(XX(8),YY(8),ZZ(1),sprintf('%0.5g','o')); 
%         end 


  
fprintf(1,'  Mesh Params \n'); 
fprintf(1,'No. of Elements  %d \n',nel); 
fprintf(1,'No. of Nodes     %d \n',nnp); 
fprintf(1,'No. of Equations %d \n\n',neq); 