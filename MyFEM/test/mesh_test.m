% mesh_test
% 这里只需要把元素与点序号对应起来
load('body.mat');
femtet=femread_bodypart_v2(lowerleftleg)
x=femtet.v(:,1);
y=femtet.v(:,2);
z=femtet.v(:,3);

% 元素的输入需不需要先后顺序？

IEN=[femtet.f([femtet.e1(:,1) femtet.e2(:,1) femtet.e3(:,1)],:)';
	 femtet.f([femtet.e1(:,2) femtet.e2(:,2) femtet.e3(:,2)],:)' ];

% plot mesh and natural boundary  
% plotmesh; 
plot_wireframe=true;
if plot_wireframe
    figure(1);hold on;view(3);axis equal
    cl=0.5;
    num_show_per_floor=30;
    side = 0;
    front = 1;
    updown = 0;
    start_floor = 1:15;
for j = [start_floor...
        %start_floor+15 start_floor+30...
        ]
    for i=1+(j-1)*30: num_show_per_floor+(j-1)*30
          if updown
            XX = [x(IEN(1,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(4,i)) x(IEN(1,i))]; 
            YY = [y(IEN(1,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(4,i)) y(IEN(1,i))];
            ZZ = [z(IEN(1,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(4,i)) z(IEN(1,i))];
            patch(XX,YY,ZZ,cl);
            XX = [ x(IEN(5,i)) x(IEN(6,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(5,i))]; 
            YY = [ y(IEN(5,i)) y(IEN(6,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(5,i))];
            ZZ = [ z(IEN(5,i)) z(IEN(6,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(5,i))];
            patch(XX,YY,ZZ,cl);
          end
            for k=[4]
                    XX=[x(IEN(k,i)) x(IEN(mod(k,4)+1,i)) x(IEN(mod(k,4)+5,i)) x(IEN(k+4,i))];
                    YY=[y(IEN(k,i)) y(IEN(mod(k,4)+1,i)) y(IEN(mod(k,4)+5,i)) y(IEN(k+4,i))];
                    ZZ=[z(IEN(k,i)) z(IEN(mod(k,4)+1,i)) z(IEN(mod(k,4)+5,i)) z(IEN(k+4,i))];
                    patch(XX,YY,ZZ,cl);
            end
    end        
end
end

% for j = 1:15
%     for i=1+(j-1)*30:15+(j-1)*30
%             
% %             XX = [x(IEN(1,i)) x(IEN(2,i)) x(IEN(3,i)) x(IEN(4,i)) x(IEN(1,i))]; 
% %             YY = [y(IEN(1,i)) y(IEN(2,i)) y(IEN(3,i)) y(IEN(4,i)) y(IEN(1,i))];
% %             ZZ = [z(IEN(1,i)) z(IEN(2,i)) z(IEN(3,i)) z(IEN(4,i)) z(IEN(1,i))];
% %             plot3(XX,YY,ZZ,'b');
% %             XX = [ x(IEN(5,i)) x(IEN(6,i)) x(IEN(7,i)) x(IEN(8,i)) x(IEN(5,i))]; 
% %             YY = [ y(IEN(5,i)) y(IEN(6,i)) y(IEN(7,i)) y(IEN(8,i)) y(IEN(5,i))];
% %             ZZ = [ z(IEN(5,i)) z(IEN(6,i)) z(IEN(7,i)) z(IEN(8,i)) z(IEN(5,i))];
% %             plot3(XX,YY,ZZ,'b');
% %             for k=1:4
% %                     XX=[x(IEN(k,i)) x(IEN(k+4,i))];
% %                     YY=[y(IEN(k,i)) y(IEN(k+4,i))];
% %                     ZZ=[z(IEN(k,i)) z(IEN(k+4,i))];
% %                     plot3(XX,YY,ZZ,'b');
% %             end
% %             XX = [ x(IEN(1,i)) x(IEN(4,i)) x(IEN(8,i)) x(IEN(5,i)) x(IEN(1,i))]; 
% %             YY = [ y(IEN(1,i)) y(IEN(4,i)) y(IEN(8,i)) y(IEN(5,i)) y(IEN(1,i))];
% %             ZZ = [ z(IEN(1,i)) z(IEN(4,i)) z(IEN(8,i)) z(IEN(5,i)) z(IEN(1,i))];
% %             plot3(XX,YY,ZZ,'b');
%             
%             
%             for k=1:5
%                 XX = [ x(IEN(t(k,1),i)) x(IEN(t(k,2),i)) x(IEN(t(k,3),i)) x(IEN(t(k,4),i)) x(IEN(t(k,5),i))]; 
%                 YY = [ y(IEN(t(k,1),i)) y(IEN(t(k,2),i)) y(IEN(t(k,3),i)) y(IEN(t(k,4),i)) y(IEN(t(k,5),i))];
%                 ZZ = [ z(IEN(t(k,1),i)) z(IEN(t(k,2),i)) z(IEN(t(k,3),i)) z(IEN(t(k,4),i)) z(IEN(t(k,5),i))];
%                 patch(XX,YY,ZZ,c(k));
%             end
%     end    
% end
