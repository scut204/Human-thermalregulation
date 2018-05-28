% 这里只需要把元素与点序号对应起来



%%%%%%%%%%%%%%%%% only for test
% femtet.v=[];
% bott=2;
% r = 10:((bott-10)/16):bott;
% drl = 10 * ones(16,1);
% rad = 2*pi/30*(1:30);
% for fl=1:16
%     for i=1:4
%         femtet.v = [femtet.v;[drl(fl)/i*cos(rad)' fl*ones(30,1) drl(fl)/i*sin(rad)']];
%     end
% end


x=femtet.v(:,1);
y=femtet.v(:,2);
z=femtet.v(:,3);

% 元素的输入需不需要先后顺序？

IEN=[femtet.f([femtet.e1(:,1) femtet.e2(:,1) femtet.e3(:,1)],:)';
	 femtet.f([femtet.e1(:,2) femtet.e2(:,2) femtet.e3(:,2)],:)' ];
IEN3 = [femtet.f3(femtet.e4(:,1),:)';
        femtet.f3(femtet.e4(:,2),:)'];

% plot mesh and natural boundary  
% plotmesh; 
plotmesh=false;
if plotmesh
    figure(1);hold on;view(3)
    for i=1:femtet.num_element

            XX = [x(IEN(1,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(4,i)) x(IEN(1,i))]; 
            YY = [y(IEN(1,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(4,i)) y(IEN(1,i))];
            ZZ = [z(IEN(1,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(4,i)) z(IEN(1,i))];
            patch(XX,YY,ZZ,'b');
            XX = [ x(IEN(5,i)) x(IEN(6,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(5,i))]; 
            YY = [ y(IEN(5,i)) y(IEN(6,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(5,i))];
            ZZ = [ z(IEN(5,i)) z(IEN(6,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(5,i))];
            patch(XX,YY,ZZ,'b');
            for k=1:4
                    XX=[x(IEN(k,i)) x(IEN(k+4,i))];
                    YY=[y(IEN(k,i)) y(IEN(k+4,i))];
                    ZZ=[z(IEN(k,i)) z(IEN(k+4,i))];
                    plot3(XX,YY,ZZ,'b');
            end
            XX = [ x(IEN(1,i)) x(IEN(4,i)) x(IEN(8,i)) x(IEN(5,i)) x(IEN(1,i))]; 
            YY = [ y(IEN(1,i)) y(IEN(4,i)) y(IEN(8,i)) y(IEN(5,i)) y(IEN(1,i))];
            ZZ = [ z(IEN(1,i)) z(IEN(4,i)) z(IEN(8,i)) z(IEN(5,i)) z(IEN(1,i))];
            patch(XX,YY,ZZ,'b');
    end        
end


  
fprintf(1,'  Mesh Params \n'); 
fprintf(1,'No. of Elements  %d \n',nel); 
fprintf(1,'No. of Nodes     %d \n',nnp); 
fprintf(1,'No. of Equations %d \n\n',neq); 