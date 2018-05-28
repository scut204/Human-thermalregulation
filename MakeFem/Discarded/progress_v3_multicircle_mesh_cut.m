function out_ml=progress_v3_multicircle_mesh_cut(v,multilines,n)
% ��ʱ�Ȳ������������
% ��������Ĺ����ǵ����Զ������ν��л����и
% ��ʱ�Ȳ�����Զ�������ͳ��ָ�Ĺ���
% ���õķ�����ö�ٷ�
% �����ǽ�����ʼ�㣬������ڶ����������·�
% Ȼ����ݲ����㽨���Ƕ��飬Ȼ���ÿ���ǶȽ��в���΢��


%%%%%%%%%%%%%
% multilines.vc
%           .l
%           .v_phi
%           .ang
%           .slp_ang
%%%%%%%%%%%%%

% if ~exist(label)
%     lines1=lines(label(lines(:,1))==con,:);    %
%     v1=v(label==con,:);   %y=0.3   
% end

% 11/29 �������һ���debug ��Ҫ����ֵ���⣬��get_int_v������x>0.0�����ʼ��������
% ��ʱ�Ȱ�ÿһ�㷢������߱�ע����

debug = 0; % ������������debug

% multilines �Ѿ������˽ǶȺ����ĵ�



num_phi=n;    % Բ�Ĳ����������
%   phi_old = pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;  % �����ȥ����ָ��б��
phi=pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;    % ���������Ĳ����ĽǶ���
phi_range = [phi-0.5*pi;phi+2*pi/num_phi-0.5*pi];      % n���Ƕ�  ��  ��Χ
phi_range = phi_range .* (phi_range >= 0) + (phi_range + 2 * pi) .* (phi_range < 0); 

% ��ʼ��
ml=multilines;
if debug
    for i=1:length(ml)
        cur_ml=ml(i);
        figure(i);hold on;title(num2str(i));axis equal;
        for j=1:size(cur_ml.l,1)      % �����ǻ���Χ�����߶�
            X=[v(cur_ml.l(j,1),1) v(cur_ml.l(j,2),1)];
            Y=[v(cur_ml.l(j,1),2) v(cur_ml.l(j,2),2)];    
            plot(X,Y,'b');
        end
    end
end

for i=1:length(ml)
    init_v=get_int_v2d(v,ml(i).l,ml(i).vc,1.5*pi);% ��ó�ʼ��   �����һ���ܹ���õ�
    ml(i).v_phi(1,:)=init_v;        % v_phi �����洢˳��ĵ�
    if debug
        figure(i);
        plot( ml(i).v_phi(1,1), ml(i).v_phi(1,2),'ro');
    end
end
nodi=1;

while(nodi<n) % i �� n-1 �������ֹͣ
    max_angl_arr=[];
    min_angl_arr=[];
    pass_zero=phi_range(2,nodi)<phi_range(1,nodi);
    for i=1:length(ml)
        cur_ml = ml(i);
            % 1����Ƕȷ�Χ����0��
        if pass_zero
            allow_vi = cur_ml.l((cur_ml.ang>phi_range(1,nodi)&cur_ml.ang<2*pi)|...
                                (cur_ml.ang<phi_range(2,nodi)&cur_ml.ang>0));
        else
            allow_vi = cur_ml.l(cur_ml.ang>phi_range(1,nodi)&...
                                cur_ml.ang<phi_range(2,nodi));
        end
            allow_vi = unique(allow_vi);   %ȥ���ظ�������
            
        if debug 
           figure(i);
           if ~isempty(allow_vi)
              x_hd(i)=plot(v(allow_vi,1),v(allow_vi,2),'bx');
           end
           if nodi == 2
               a=1;
           end
        end
        
        cur_slope_angle_arr=transform_slope_to_angle(repmat(cur_ml.v_phi(nodi,:),length(allow_vi),1),v(allow_vi,:));
        if abs(max(cur_slope_angle_arr)-min(cur_slope_angle_arr))>pi   %�ͽ�ԭ�� ����pi�����������0�� ���д���
            cur_slope_angle_arr = mod(cur_slope_angle_arr + pi , 2*pi) - pi;
        end
            max_angl_arr=[max_angl_arr max(cur_slope_angle_arr)];
            min_angl_arr=[min_angl_arr min(cur_slope_angle_arr)];
    end
    % ������б�ʵ���Сֵ �� ��Сб�ʵ����ֵ �õ����ǵľ�ֵ
    lowb_max_ang=min(max_angl_arr);
    uppb_min_ang=max(min_angl_arr);
    [xst_com_range,fin_rad_angle] = round_common_range(uppb_min_ang,lowb_max_ang);
%     fin_rad_angle = 0.5*(lowb_max_ang+uppb_min_ang);
    % �������ӶԵ�ķ�Χ����
    
    % ������һ��������
    for i=1:length(ml)
        int_v=[];
        int_v_arr= get_int_v2d(v,ml(i).l,ml(i).v_phi(nodi,:),fin_rad_angle);
        is_interp=0;
        if ~isempty(int_v_arr) % �н���������¶Խ������з��࣬���Ƕ�����Χ�ڵĽ����ɸѡ����
            for j = 1:size(int_v_arr,1)
                phase = transform_slope_to_angle(repmat(ml(i).vc,size(int_v_arr,1),1),int_v_arr);
                if pass_zero
                    int_v = int_v_arr((phase>phi_range(1,nodi)&phase<2*pi)|...
                                        (phase<phi_range(2,nodi)&phase>0),:);
                else
                    int_v = int_v_arr(phase>phi_range(1,nodi)&...
                                        phase<phi_range(2,nodi),:);
                end
            end
        end
        if isempty(int_v) %����û�н�����������еõ��Ľ����û��������Ƕȷ�Χ��
            is_interp=1;
            vc_radial_angl = mean(phi_range(:,nodi))-(pass_zero)*pi; %�����ĵ�����ĽǶ�  ����Ҳ��Ҫ�� Բ�ܽǴ���
            radial_end = get_radius_line(ml(i).v_phi(nodi,:),fin_rad_angle);
            int_v = get_int_v2d([ml(i).v_phi(nodi,:);radial_end],...    % ����һ���߶Σ����˵��ã�����
                                        [1 2],...                       % ע��lines
                                   ml(i).vc,vc_radial_angl);
        end
        int_v = int_v(1,:); % ѡȡ���������ĵ�һ��
        ml(i).v_phi(nodi+1,:) = int_v;
        ml(i).slp_ang(nodi) = fin_rad_angle;
        if debug
            figure(i);
            plot( ml(i).v_phi(nodi+1,1), ml(i).v_phi(nodi+1,2),'ro'); % ���ﻭ������
            plot( [ml(i).v_phi(nodi,1) ml(i).v_phi(nodi+1,1)],... 
                  [ml(i).v_phi(nodi,2) ml(i).v_phi(nodi+1,2)],'g');
        end
    end
    nodi = nodi + 1;
    
    % debug ģ��
    if debug
      if ~isempty(x_hd)
        delete(x_hd);  
      end
      disp(strcat('interplation status:',num2str(is_interp)));
    end
end

    
% ���ﴦ�����һ��������
terminal_slp=[];      %��¼�����������ʼ������ĽǶ�
for i=1:length(ml)
    terminal_slp=[terminal_slp transform_slope_to_angle(ml(i).v_phi(end,:),ml(i).v_phi(1,:))];
end
terminal_slp = mod(terminal_slp + pi,2*pi)-pi;   % ��Χ�� [-pi pi] �м�
max_tmnl_slp = max(terminal_slp);
min_tmnl_slp = min(terminal_slp);

for i=1:length(ml)
    radial_end = get_radius_line(ml(i).v_phi(end,:),min_tmnl_slp-0.1);
    int_v = get_int_v2d([ml(i).v_phi(end,:);radial_end],...    % ����һ���߶Σ����˵��ã�����
                                            [1 2],...                       % ע��lines
                                       ml(i).v_phi(1,:),max_tmnl_slp+pi+0.1);
    ml(i).v_phi(end+1,:)=int_v;    
    if debug
        figure(i);
        plot( ml(i).v_phi(end,1), ml(i).v_phi(end,2),'ro'); % ���ﻭ���һ��������
    end
end
       
        
n=n+1;

    if debug % ����ͼ
%         title(strcat('n=',num2str(n)));
        for i=1:length(ml)   % ����������ӵ��߶�
            cur_ml=ml(i);
            figure(i)
            for j=1:n
                X=[cur_ml.v_phi(j,1)  cur_ml.v_phi(mod(j,n)+1,1)];
                Y=[cur_ml.v_phi(j,2)  cur_ml.v_phi(mod(j,n)+1,2)]; % �����mod ��Ϊ����β����
                plot(X,Y,'g');
            end
        end           
    end
    
out_ml = ml;
end




function [hit,fin_angle] = round_common_range(upa,lwa)
    % ���һϵ�л���ֵ�Ĺ�����Χ
    % upa �� ���ȵ��Ͻ��� lwa �� ���ȵ��½���
    % �������Ƕ�����һ��pi �ķ�Χ֮��
    % ���ȶ����ǽ��л���ֵ�Ĺ�һ��
    if max([upa lwa])-min([upa lwa])>pi
        upa = mod(upa + pi , 2*pi) - pi;
        lwa = mod(lwa + pi , 2*pi) - pi;
    end
    
    % ����upa��lwaͬһ������λ���µ����½���ȷ
    % ��� hit-range 
    if min(upa)<max(lwa) %���ڹ�����Χ  
        % ���������Χ�������� 2������
       hit = 1;
    else
        % ������в����ڹ�����Χ�Ĵ������һ������ֵ
       hit = 0;
    end
    fin_angle = 0.5*(min(upa)+max(lwa));
end
function radial_end=get_radius_line(beg_v,angle,len)
    if nargin==2   % ����ûָ��
        len=10;
    end
    cp=cos(angle);
    sp=sin(angle);
    RotP= [cp  sp;
           -sp cp];
    radial_end = [len 0]*RotP+beg_v;   
end

% debug ��������
function [int_v,radial]=get_int_v2d_test(v,lines,beg_v,angle)
     % ���ߵĳ���
    
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



