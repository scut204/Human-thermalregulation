function [v_phi,v1c]=progress_v2_circle_mesh_cut(v,lines,n)

% ��������Ĺ����ǵ�����һ������ν��л����и
% ��ʱ�Ȳ�����Զ�������ͳ��ָ�Ĺ���
% ���õķ�����ö�ٷ�
% �����ǽ�����ʼ�㣬������ڶ����������·�
% Ȼ����ݲ����㽨���Ƕ��飬Ȼ���ÿ���ǶȽ��в���΢��

% if ~exist(label)
%     lines1=lines(label(lines(:,1))==con,:);    %
%     v1=v(label==con,:);   %y=0.3   
% end

% 11/29 �������һ���debug
% ��ʱ�Ȱ�ÿһ�㷢������߱�ע����
% BUG�޸����
v1c=mean(v);
num_phi=n;    % Բ�Ĳ����������
phi=pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;    % ���������Ĳ����ĽǶ���
     %��ʼ������ֵ     
init_v=get_int_v2d(v,lines,v1c,1.5*pi);% ��ó�ʼ��   �����һ���ܹ���õ�
v_phi(1,:)=init_v;        % v_phi �����洢˳��ĵ�

   % ���ﲻ�ò�д�ñȽϳ�ª��Ϊ���Լ����߼�����
   i=1;
   while(i<n) % i �� n-1 �������ֹͣ
%        int_v=get_int_v2d(v,lines,v_phi(i,:),phi(i));   
       [int_v,radial]=get_int_v2d_test(v,lines,v_phi(i,:),phi(i));      %�������debug  
       if norm(int_v-v_phi(i,:))<1e-4     %����˵��û���ҵ����ʵ��ڲ�㣬��Ҫ���·���һ���Ƕ�
          phi(i) = phi(i) + pi/(2*num_phi) ;
           i=i-1;
       else
            v_phi(i+1,:) = int_v;
            X=[v_phi(i,1) ];
            Y=[v_phi(i,2) ];
            plot(X,Y,'ro');
       end
       

       i=i+1;
       plot([v_phi(i,1) radial(1)],[v_phi(i,2) radial(2)],'g');
       if i==2
           disp('debug');
       end
   end
   
   %  �������һ����
            X=[v_phi(n,1) ];
            Y=[v_phi(n,2) ];
            plot(X,Y,'ro');    
end


function [int_v,radial]=get_int_v2d_test(v,lines,beg_v,angle)
    len = 10;  % ���ߵĳ���
    
    cp=cos(angle);
    sp=sin(angle);
    Rot_P=[cp  -sp;      %��XZ������ת
           sp   cp];
    RotP= [cp  sp;
           -sp cp];
    int_v = zeros(1,2);
    v_rel=v-repmat(beg_v,size(v,1),1);   %��ÿһ���㽨�������ĵ��õ�����λ������
    v_rot=v_rel*Rot_P;         % ��ÿһ������������ת��˳ʱ�룩
    for j=1:size(lines,1)
        stp=v_rot(lines(j,1),:);
        fnp=v_rot(lines(j,2),:);
        if(stp(2)*fnp(2)<0) % signs are different
            lambda=0-fnp(2)/(stp(2)-fnp(2));
            x=lambda*(stp(1)-fnp(1))+fnp(1);     %��������ཻ���x��ֵ
            if(x>0.01)                   % �ж�x�Ƿ���������
                int_v=[x 0];   %���� �����õ�
            end
        end
    end
    int_v=int_v*RotP+beg_v;      %��ԭ�õ㵽ԭλ�ã���ʱ�룩
    radial = [10 0]*RotP+beg_v;
end

