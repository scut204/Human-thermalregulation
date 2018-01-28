function [v_phi,v1c]=progress_circle_mesh_cut(v,lines,label,n,con)
lines1=lines(label(lines(:,1))==con,:);    %
v1=v(label==con,:);   %y=0.3
v1c=mean(v1);

num_phi=n;    % Բ�Ĳ����������
phi=pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;    % ���������ĽǶ���
     %��ʼ������ֵ
init_v=get_int_v(v,lines1,v1c,1.5*pi);% ��ó�ʼ��
v_phi(1,:)=init_v;
   for i=1:n-1
       v_phi(i+1,:)=get_int_v(v,lines1,v_phi(i,:),phi(i));
   end

end

function [int_v]=get_int_v(v,lines,beg_v,phi)
    cp=cos(phi);
    sp=sin(phi);
    Rot_P=[cp 0 -sp;      %��XZ������ת
           0  1   0;
           sp 0  cp];
    RotP= [cp 0  sp;
           0  1  0;
           -sp 0 cp];
    v_rel=v-repmat(beg_v,size(v,1),1);   %��ÿһ���㽨�������ĵ��õ�����λ������
    v_rot=v_rel*Rot_P;         % ��ÿһ������������ת
    for j=1:size(lines,1)
        stp=v_rot(lines(j,1),:);
        fnp=v_rot(lines(j,2),:);
        if(stp(3)*fnp(3)<0) % signs are different
            lambda=0-fnp(3)/(stp(3)-fnp(3));
            x=lambda*(stp(1)-fnp(1))+fnp(1);     %�����z���ཻ���x��ֵ
            if(x>0.01)                   % �ж�x�Ƿ���������
                int_v=[x stp(2) 0];   %���� �����õ�
            end
        end
    end
    int_v=int_v*RotP+beg_v;      %��ԭ�õ㵽ԭλ��
end