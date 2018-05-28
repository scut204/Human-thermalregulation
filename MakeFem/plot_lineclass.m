function plot_lineclass(lineclass,option)
% lineclass is an structure array
% lineclass.l
% lineclass.v_phi
% lineclass.vc
% lineclass.slp_ang

% option �Ƿ񻭳��ı�������
ml=lineclass;
disp('number of flrs:')
flr = length(lineclass)
figure(1);view(3);hold on;axis equal;


% ����ע�͵����߿���

% for i=1:flr % �Ȼ�����
%     n=size(ml(i).v_phi,1);
%    
%     for j=1:n
%         X=[ml(i).v_phi(j,1)  ml(i).v_phi(mod(j,n)+1,1)];
%         Y=[ml(i).v_phi(j,2)  ml(i).v_phi(mod(j,n)+1,2)]; % �����mod ��Ϊ����β����
%         Z=[ml(i).v_phi(j,3)  ml(i).v_phi(mod(j,n)+1,3)];
%         plot3(X,Y,Z,'g');
%     end
% end
% 
% for i=1:flr-1 % �ٻ����ӵ�
%     n=size(ml(i).v_phi,1);
%     c=rand(1,3);
%     for j=1:n
%         X=[ml(i).v_phi(j,1)  ml(i+1).v_phi(j,1)];
%         Y=[ml(i).v_phi(j,2)  ml(i+1).v_phi(j,2)]; % �����mod ��Ϊ����β����
%         Z=[ml(i).v_phi(j,3)  ml(i+1).v_phi(j,3)];
%         plot3(X,Y,Z,'g');
%     end
% end

for i=1:flr-1 % �ٻ����ӵ�
    n=size(ml(i).v_phi,1);
    c=rand(1,3);
    for j=1:n
        X=[ml(i).v_phi(j,1)  ml(i+1).v_phi(j,1) ml(i+1).v_phi(mod(j,n)+1,1) ml(i).v_phi(mod(j,n)+1,1) ml(i).v_phi(j,1)];
        Y=[ml(i).v_phi(j,2)  ml(i+1).v_phi(j,2) ml(i+1).v_phi(mod(j,n)+1,2) ml(i).v_phi(mod(j,n)+1,2) ml(i).v_phi(j,2)]; % �����mod ��Ϊ����β����
        Z=[ml(i).v_phi(j,3)  ml(i+1).v_phi(j,3) ml(i+1).v_phi(mod(j,n)+1,3) ml(i).v_phi(mod(j,n)+1,3) ml(i).v_phi(j,3)];
        patch(X,Y,Z,c);
    end
end

end
    