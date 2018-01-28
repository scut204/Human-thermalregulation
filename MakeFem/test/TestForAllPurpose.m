
% % test_allpurpose
% v1=v(label==1,:);
% v2=v(label==2,:);
% 
% num_smp=50;
% x1=min(v1(:,1)):(max(v1(:,1))-min(v1(:,1)))/num_smp:max(v1(:,1));
% x2=min(v2(:,1)):(max(v2(:,1))-min(v2(:,1)))/num_smp:max(v2(:,1));
% 
%     p1=[];
%     p2=[];
% for i=1:length(x1)
%     p1=x_plane_cut_test(v',lines',p1,x1(i));
%     clear x_plane_cut_test;
%     p2=x_plane_cut_test(v',lines',p2,x2(i));
%     clear x_plane_cut_test;
%     if((p2(3,1,3)-p2(3,1,4))*(p1(3,1,1)-p1(3,1,2))>0)
%         k=3;
%     else
%         k=4;
%     end
%     XX=[p1(1,1,1) p2(1,1,k)];
%     YY=[p1(2,1,1) p2(2,1,k)];
%     ZZ=[p1(3,1,1) p2(3,1,k)];
%     plot3(XX,YY,ZZ,'r');hold on;
% end
% hold off;
% % clear x_plane_cut_test;




