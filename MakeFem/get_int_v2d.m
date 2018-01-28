function [int_v]=get_int_v2d(v,lines,beg_v,angle)

% ��¼���еĽ����
% ���ص�int_vΪ���н��������꣬ ������������ʽ���
    cp=cos(angle);
    sp=sin(angle);
    Rot_P=[cp  -sp;      %��XZ������ת
           sp   cp];
    RotP= [cp  sp;
           -sp cp];
    int_v = zeros(1,2);
    v_rel=v-repmat(beg_v,size(v,1),1);   %��ÿһ���㽨�������ĵ��õ�����λ������
    v_rot=v_rel*Rot_P;         % ��ÿһ������������ת��˳ʱ�룩
    int_v=[];
    for j=1:size(lines,1)
        stp=v_rot(lines(j,1),:);
        fnp=v_rot(lines(j,2),:);
        if(stp(2)*fnp(2)<0) % signs are different
            lambda=0-fnp(2)/(stp(2)-fnp(2));
            x=lambda*(stp(1)-fnp(1))+fnp(1);     %��������ཻ���x��ֵ
            if(x>0.01)                   % �ж�x�Ƿ���������
                int_v=[int_v;
                        x 0];   %���� �����õ�
            end
        end
    end
    if ~isempty(int_v)    % ˵���н����
        int_v=int_v*RotP+repmat(beg_v,size(int_v,1),1);      %��ԭ�õ㵽ԭλ�ã���ʱ�룩
    end
end