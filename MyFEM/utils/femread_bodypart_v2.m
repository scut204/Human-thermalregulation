function bodypart_feminfo=femread_bodypart_v2(bodypart)
% ԭ�ȵ�mesh�����������������и���
% �������ɵ���������������沢���ǹ���ģ�����нṹ�����������񻹿��Լ���ʹ�ã����û�о�����ʱ����
%
% 18.1.17
% ��v1�Ĳ�ͬ���ڣ�������ڲ�����֯�ÿɱ�뾶��Բ�������
% bodypart_feminfo �Ľṹ��
%     bodypart_feminfo.floors      
%     bodypart_feminfo.num_cirp    ÿһ�㻷�ĵ��� �������ó�30
%     bodypart_feminfo.num_point   ������ 
%     bodypart_feminfo.num_face    ������
%     bodypart_feminfo.num_element Ԫ������
%     bodypart_feminfo.v    
%     bodypart_feminfo.f4b
%     bodypart_feminfo.f4sd
%     bodypart_feminfo.f4fr
%     bodypart_feminfo.faces
%     bodypart_feminfo.ele1
%     bodypart_feminfo.ele2
%     bodypart_feminfo.ele3
%     bodypart_feminfo.ele4 

    fl=size(bodypart.v_phi,3);
    n_sp=size(bodypart.v_phi,1);
    
    % �����Զ���������
    bodypart_feminfo.floors=fl;
    bodypart_feminfo.num_cirp=n_sp;    % ÿ���������
    bodypart_feminfo.num_point=fl*(n_sp*4+1);                         % ������           
    bodypart_feminfo.num_face=n_sp*4*fl+ ...    % ���� 
							  n_sp*4*(fl-1)+ ...% ����
							  n_sp*4*(fl-1);    % ����              % ������
    bodypart_feminfo.num_element=n_sp*4*(fl-1);                      % Ԫ������
    
    
    v=[];          %����Ϣ����
    f4b=[];        %XY��  ���Z�Ǹ߶�
    
    f4sd=[];       %����
    f4fr=[];       %����
    faces=[];      %�ܵ������
	faces3=[];	  %���������
    ele1=[];       %��һ��Ԫ��
    ele2=[];       %�ڶ���Ԫ��
    ele3=[];       %������Ԫ��
    ele4=[];       %���ڲ�Ԫ��  ��ʽ��ǰ���㲻ͬ
    phi=2*pi/n_sp   :    2*pi/n_sp    :    2*pi;  % ��ʼ��n_sp���ǶȵĽǶ���
    rad_rate = .58;    % Բ�����ĺ��
    skin_rate = .95;  % ��ȥƤ����ĺ��
    fat_rate = rad_rate;
    muscle_rate =.19;
    rate_arr = [skin_rate fat_rate muscle_rate];
    
    % make the first floor of v and f
    v_phi=bodypart.v_phi(:,:,1);
    v = get_v_1f(v_phi,v,n_sp,rate_arr);
	
    fc1=1:n_sp;        % fc1 ��ĵ�һ����
    fc2=mod(fc1,n_sp)+1;
    for j=1:3     % ������������
        ftemp=[fc1;fc1+n_sp;fc2+n_sp;fc2]; 
        f4b=[f4b ftemp];	
        fc1=fc1+n_sp;
        fc2=fc2+n_sp;
    end  % fc1 ������Ĳ㻷
    faces3=[faces3 [fc1;fc2;repmat(fc1(1)+n_sp,1,n_sp)]];
    faces=[faces f4b];
%     f3b=[f3b fc1;repmat(n_sp*4+1,1,n_sp);fc2];
    

    %�������Ժ�����ٲ�������
    
    %����Ԫ��������
    num_pfv=n_sp*4+1;   % ÿһ��ĵ������   
    
    %����Ԫ��������
    
    num_sd=n_sp*4;      % ÿһ���������������ͬ
	num_b = n_sp*3;     % ���滹������
    num_pf4f=n_sp*11;    %ÿһ���ı����������
	num_pf3f=n_sp*1;    %ÿһ�������������
    
    % and the else
    for i=2:fl
        v_phi=bodypart.v_phi(:,:,i);
        v = get_v_1f(v_phi,v,n_sp,rate_arr);
        

        fc1=(1:n_sp)+num_pfv*(i-1);   % fc1 ���ϲ�ĵ�һ����
        circle_offset=mod(1:n_sp,n_sp)-(1:n_sp);
        fc2=fc1+circle_offset+1; % fc2 ��fc1ͬ�� �ұߵڶ�����
        
        f4bt=[];     % ���˳���Ǵ���������
        f4sdt=[];    % ��������Ҫ����������
        f4frt=[];    % ������
		f3bt=[];    % ���ǵ���
        for j=1:3    % ��������3��
            f4bt=[f4bt [fc1;fc1+n_sp;fc2+n_sp;fc2]];      % �ذ��컨����
            f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];    % ������
            f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];    % ������
            fc1=fc1+n_sp;
            fc2=fc2+n_sp;
        end
        f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];
		f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];  % ��������������
		f3bt = [fc1;fc2;repmat(fc1(1)+n_sp,1,n_sp)];
	    faces=[faces f4sdt f4frt f4bt];    % 
		faces3=[faces3 f3bt];
		% ����ֻ��������¼
        f4b=[f4b f4bt];  
        f4sd=[f4sd f4sdt];
        f4fr=[f4fr f4frt];
		
        % ��Ľṹ�����棨3���������棨4���������棨4����ѭ������
		% ����������ĵ���
        % ���� ���� ���λ��
        % ����Ԫ�ص���������
        % �����ڲ����Ĳ�        
        ec1=(1:n_sp)+num_pf4f*(i-2);        % num_pf4f 11   
        ec2=ec1+num_b;                  % num_b_fr 3
        ec3=ec2+num_sd;                    % num_sd   4
        
		
		% �������ec
		e3c1 = (1:n_sp)+num_pf3f*(i-2);
        % ���������
        elem_seq6=[ec1;                 % 12���ǵ��붥
                   ec1+num_pf4f;         
                   ec2;                 % 34���Ǿ����� ��������
                   ec2+n_sp;
                   ec3;                 %56����������
                   ec3+circle_offset+1];    
	    elem_seq5=[e3c1;                % 12���ǵ��붥
				   e3c1 + num_pf3f;	   % ��������face3�����
				   ec2 + n_sp*3;	 	 % ʣ�µ��Ǿ������������
				   ec3 + n_sp*3;
				   ec3 + n_sp*3+circle_offset+1;
				  ];
        ele1=[ele1 elem_seq6];     % ����һ��
        ele2=[ele2 elem_seq6+n_sp];
        ele3=[ele3 elem_seq6+n_sp*2];
	    ele4=[ele4 elem_seq5];
    end

    bodypart_feminfo.v=v;
    bodypart_feminfo.f=faces';
    bodypart_feminfo.f3 = faces3';
    bodypart_feminfo.e1=ele1';    %  Ƥ���� ��Ҫ��
    bodypart_feminfo.e2=ele2';
    bodypart_feminfo.e3=ele3';
    bodypart_feminfo.e4=ele4';
    
    bodypart_feminfo.info = strcat('6_nodes_ele contains faces of [bottom ceil front behind side1 side2]\n', ...
                                   '5_nodes_ele contains faces of [bottom(index from face3) ceil front side1 side2]');
                            
                            
    
end


function v = get_v_1f(v_phi,v,n_sp,rate_arr)
            vic=mean(v_phi);      % ���ĵ�
    %     v_sub_skin = (v_phi-repmat(vic,n_sp,1))*skin_rate+repmat(vic,n_sp,1);
    %     vic_mindis = min(sqrt(sum((v_sub_skin-repmat(vic,n_sp,1)).^2,2)));
    %     itn_cir_rad = (vic_mindis)*rad_rate; % �ڲ��뾶ȡ��̾���ĺ��
        v=[v;v_phi];   % �����²�Ƥ��
        for j=1:3
    %         ps=repmat(vic,n_sp,1) + [cos(phi') zeros(n_sp,1) sin(phi')]*itn_cir_rad*(2-j)/2;    % ������ڽǶȵ����⻹��Ҫ�ٿ�
            ps = (v_phi-repmat(vic,n_sp,1))*rate_arr(j)+repmat(vic,n_sp,1);
            v=[v;ps];      % v expands downward
        end
		v = [v;vic];    % �����ĵ������ȥ
end
