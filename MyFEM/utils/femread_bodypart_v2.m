function bodypart_feminfo=femread_bodypart_v2(bodypart)
% ԭ�ȵ�mesh�����������������и���
% �������ɵ���������������沢���ǹ���ģ�����нṹ�����������񻹿��Լ���ʹ�ã����û�о�����ʱ����
%
% 18.1.17
% ��v1�Ĳ�ͬ���ڣ�������ڲ�����֯�ÿɱ�뾶��Բ�������
    fl=size(bodypart.v_phi,3);
    n_sp=size(bodypart.v_phi,1);
    
    % �����Զ���������
    bodypart_feminfo.floors=fl;
    bodypart_feminfo.num_cirp=n_sp;
    bodypart_feminfo.num_point=fl*n_sp*4;                         % ������           
    bodypart_feminfo.num_face=n_sp*3*fl+n_sp*4*(fl-1)+n_sp*3*(fl-1);             % ������
    bodypart_feminfo.num_element=n_sp*3*(fl-1);                      % Ԫ������
    
    
    v=[];          %����Ϣ����
    f4b=[];        %XY��
    f4sd=[];       %����
    f4fr=[];       %����
    faces=[];      %�ܵ������
    ele1=[];       %��һ��Ԫ��
    ele2=[];       %�ڶ���Ԫ��
    ele3=[];       %������Ԫ��
    phi=2*pi/n_sp   :    2*pi/n_sp    :    2*pi;  % ��ʼ��n_sp���ǶȵĽǶ���
    rad_rate = .9;
    
    
    % make the first floor of v and f
    v_phi=bodypart.v_phi(:,:,1);
    vic=mean(v_phi);
    vic_mindis = min(sqrt(sum((v_phi-repmat(vic,n_sp,1)).^2,2)));
    itn_cir_rad = (vic_mindis)*rad_rate; % �ڲ��뾶ȡ��̾����0.9
    
    v=[v;v_phi];
    for j=0:2
        ps=vic + [cos(phi') repmat([0],n_sp,1) sin(phi')]*itn_cir_rad*(3-j)/3;    % ������ڽǶȵ����⻹��Ҫ�ٿ�
        v=[v;ps];      % v expands downward
    end
    fc1=1:n_sp;        % fc1 ��ĵ�һ����
    fc2=mod(fc1,n_sp)+1;
    for j=1:3     % outside 3 layers
        ftemp=[fc1;fc1+n_sp;fc2+n_sp;fc2]; 
        f4b=[f4b ftemp];
        fc1=fc1+n_sp;
        fc2=fc2+n_sp;
    end
    faces=[faces f4b];
%     f3b=[f3b fc1;repmat(n_sp*4+1,1,n_sp);fc2];
    

    %�������Ժ�����ٲ�������
    
    %����Ԫ��������
    num_pfv=n_sp*4;   % ÿһ��ĵ������   
    
    %����Ԫ��������
    num_b_fr=n_sp*3;     % �ײ��������������������
    num_sd=n_sp*4;      % ������������
    num_pff=n_sp*10;    %ÿһ���������
    
    % and the else
    for i=2:fl
        v_phi=bodypart.v_phi(:,:,i);
        vic=mean(v_phi);
        vic_mindis = min(sqrt(sum((v_phi-repmat(vic,n_sp,1)).^2,2)));
        itn_cir_rad = vic_mindis*rad_rate; % �ڲ��뾶ȡ��̾����0.9
        v=[v;v_phi];
        for j=0:2
            ps=vic + [cos(phi') repmat([0],n_sp,1) sin(phi')]*itn_cir_rad*(3-j)/3;    % ������ڽǶȵ����⻹��Ҫ�ٿ�
            v=[v;ps];      % v expands 
        end

        fc1=(1:n_sp)+num_pfv*(i-1);
        fc2=mod(fc1,n_sp)+1+num_pfv*(i-1);
        
        f4bt=[];     % ���˳���Ǵ���������
        f4sdt=[];    % ��������Ҫ����������
        f4frt=[];    % ������
        for j=1:3    % ��������3��
            f4bt=[f4bt [fc1;fc1+n_sp;fc2+n_sp;fc2]];      % �ذ��컨����
            f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];    % ������
            f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];    % ������
            fc1=fc1+n_sp;
            fc2=fc2+n_sp;
        end
        f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];
        f4b=[f4b f4bt];
        f4sd=[f4sd f4sdt];
        f4fr=[f4fr f4frt];
        faces=[faces f4sdt f4frt f4bt];    % ��Ľṹ�����棨3���������棨4���������棨3����ѭ������
        % ���� ���� ���λ��
        % ����Ԫ�ص���������
        % �����ڲ����Ĳ�        
        ec1=(1:n_sp)+num_pff*(i-2);        % num_pff 10    
        ec2=ec1+num_b_fr;                  % num_b_fr 3
        ec3=ec2+num_sd;                    % num_sd   4
        circle_offset=mod(1:n_sp,n_sp)-(1:n_sp);
        % ���������
        elem_seq6=[ec1;                 % 12���ǵ��붥
                   ec1+num_pff;         
                   ec2;                 % 34���Ǿ����� ��������
                   ec2+n_sp;
                   ec3;                 %56����������
                   ec3+circle_offset+1];    

        ele1=[ele1 elem_seq6];     % ����һ��
        ele2=[ele2 elem_seq6+n_sp];
        ele3=[ele3 elem_seq6+n_sp*2];

    end

    bodypart_feminfo.v=v;
    bodypart_feminfo.f=faces';
    bodypart_feminfo.e1=ele1';
    bodypart_feminfo.e2=ele2';
    bodypart_feminfo.e3=ele3';
end
