function bodypart_feminfo=femread_bodypart(bodypart)
% ԭ�ȵ�mesh�����������������и���
% �������ɵ���������������沢���ǹ���ģ�����нṹ�����������񻹿��Լ���ʹ�ã����û�о�����ʱ����

    fl=size(bodypart.v_phi,3);
    n_sp=size(bodypart.v_phi,1);
    
    bodypart_feminfo.floors=fl;
    bodypart_feminfo.num_cirp=n_sp;
    bodypart_feminfo.num_point=fl*n_sp*4;                         % ������           
    bodypart_feminfo.num_face=n_sp*3*fl+n_sp*4*(fl-1)+n_sp*3*(fl-1);             % ������
    bodypart_feminfo.num_element=n_sp*3*(fl-1);                      % Ԫ������
    
    v=[];               %����Ϣ����
%     f3b=[];
    f4b=[];        %XY��
    f4sd=[];       %����
    f4fr=[];       %����
    faces=[];      %�ܵ������
    ele1=[];       %��һ��Ԫ��
    ele2=[];       %�ڶ���Ԫ��
    ele3=[];       %������Ԫ��
    
    % make the first floor of v and f
    v_phi=bodypart.v_phi(:,:,1);
    vic=mean(v_phi);
    for j=1:4
        ps=v_phi-(v_phi-repmat(vic,n_sp,1))*(j-1)*0.25;
        v=[v;ps];      % v expands downward
    end
%     v=[v;vic];        % 121 vertex every floor
    fc1=1:n_sp;        % fc1 ��ĵ�һ����
    fc2=mod(fc1,n_sp)+1;
    for j=1:3     % outside 3 layers
        ftemp=[fc1;fc1+30;fc2+30;fc2];
        f4b=[f4b ftemp];
        fc1=fc1+30;
        fc2=fc2+30;
    end
    faces=[faces f4b];
%     f3b=[f3b fc1;repmat(n_sp*4+1,1,n_sp);fc2];
    

    %�������Ժ�����ٲ�������
    
    %�����������
    num_pfv=n_sp*4;   % ÿһ��ĵ������   
    
    %��Ԫ�ص�������
    num_b_fr=90;     % �ײ���ǰ�����
    num_sd=120;      % ���Ҳ��������
    num_pff=90+90+120;    %ÿһ���������
    
    % and the else
    for i=2:fl
        v_phi=bodypart.v_phi(:,:,i);
        vic=mean(v_phi);
        for j=1:4
            ps=v_phi-(v_phi-repmat(vic,n_sp,1))*(j-1)*0.25;
            v=[v;ps];      % v expands 
        end
%         v=[v;vic];        % 121 vertex every floor
        fc1=(1:n_sp)+num_pfv*(i-1);
        fc2=mod(fc1,n_sp)+1+num_pfv*(i-1);
        
        f4bt=[];     % ���˳���Ǵ���������
        f4sdt=[];    % ��߲���Ҫ����������
        f4frt=[];   
        for j=1:3    % ��������3��
            f4bt=[f4bt [fc1;fc1+n_sp;fc2+n_sp;fc2]];
            f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];
            f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];
            fc1=fc1+30;
            fc2=fc2+30;
        end
        f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];
        f4b=[f4b f4bt];
        f4sd=[f4sd f4sdt];
        f4fr=[f4fr f4frt];
        faces=[faces f4sdt f4frt f4bt];
        % ���� ���� ���λ��
        % ����Ԫ�ص���������
        % �����ڲ����Ĳ�
%         f3bt=[fc1;repmat((n_sp*4+1)*i,1,n_sp);fc2];
%         f3b=[f3b f3bt];
%         f4sdt=[fc1;fc1-num_pfv;fc2-num_pfv;fc2];
%         f4sd=[f4sd f4sdt];
%         f4frt=[fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv];
%         f4fr=[f4fr f4frt];
        
        ec1=(1:n_sp)+num_pff*(i-2);
        ec2=ec1+num_b_fr;
        ec3=ec2+num_sd;
        circle_offset=mod(1:30,30)-(1:30);
        elem_seq6=[ec1;ec1+num_pff;
                   ec2;ec2+30;
                   ec3;ec3+circle_offset+1];
%         elem_seq5=[ec1+90;ec1+num_pff+90;ec2+90;ec3+90;ec3+90+circle_offset+1];
        ele1=[ele1 elem_seq6];
        ele2=[ele2 elem_seq6+30];
        ele3=[ele3 elem_seq6+60];
%         ele4=[ele4 elem_seq5];
    end

    bodypart_feminfo.v=v;
    bodypart_feminfo.f=faces';
    bodypart_feminfo.e1=ele1';
    bodypart_feminfo.e2=ele2';
    bodypart_feminfo.e3=ele3';
end
