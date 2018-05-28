function out_ml=progress_v3_multicircle_mesh_cut(v,multilines,n)
% 暂时先不设置输出参数
% 这个函数的功能是迭代对多个多边形进行环形切割。
% 暂时先不加入对多边形组的统筹分割的功能
% 采用的方法是枚举法
% 首先是建立初始点，这里放在多边形区域的下方
% 然后根据采样点建立角度组，然后对每个角度进行测试微调


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

% 11/29 进行最后一点的debug 主要是数值问题，在get_int_v函数里x>0.0会把起始点加入进来
% 暂时先把每一点发射的射线标注出来

debug = 0; % 这里用来开关debug

% multilines 已经包括了角度和中心点



num_phi=n;    % 圆的采样点的数量
%   phi_old = pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;  % 这里过去用来指定斜率
phi=pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;    % 建立初步的采样的角度组
phi_range = [phi-0.5*pi;phi+2*pi/num_phi-0.5*pi];      % n个角度  和  范围
phi_range = phi_range .* (phi_range >= 0) + (phi_range + 2 * pi) .* (phi_range < 0); 

% 初始化
ml=multilines;
if debug
    for i=1:length(ml)
        cur_ml=ml(i);
        figure(i);hold on;title(num2str(i));axis equal;
        for j=1:size(cur_ml.l,1)      % 这里是画外围轮廓线段
            X=[v(cur_ml.l(j,1),1) v(cur_ml.l(j,2),1)];
            Y=[v(cur_ml.l(j,1),2) v(cur_ml.l(j,2),2)];    
            plot(X,Y,'b');
        end
    end
end

for i=1:length(ml)
    init_v=get_int_v2d(v,ml(i).l,ml(i).vc,1.5*pi);% 获得初始点   这个是一定能够获得的
    ml(i).v_phi(1,:)=init_v;        % v_phi 用来存储顺序的点
    if debug
        figure(i);
        plot( ml(i).v_phi(1,1), ml(i).v_phi(1,2),'ro');
    end
end
nodi=1;

while(nodi<n) % i 到 n-1 运行完后停止
    max_angl_arr=[];
    min_angl_arr=[];
    pass_zero=phi_range(2,nodi)<phi_range(1,nodi);
    for i=1:length(ml)
        cur_ml = ml(i);
            % 1代表角度范围经过0点
        if pass_zero
            allow_vi = cur_ml.l((cur_ml.ang>phi_range(1,nodi)&cur_ml.ang<2*pi)|...
                                (cur_ml.ang<phi_range(2,nodi)&cur_ml.ang>0));
        else
            allow_vi = cur_ml.l(cur_ml.ang>phi_range(1,nodi)&...
                                cur_ml.ang<phi_range(2,nodi));
        end
            allow_vi = unique(allow_vi);   %去除重复的索引
            
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
        if abs(max(cur_slope_angle_arr)-min(cur_slope_angle_arr))>pi   %就近原则 大于pi的情况当作过0点 进行处理
            cur_slope_angle_arr = mod(cur_slope_angle_arr + pi , 2*pi) - pi;
        end
            max_angl_arr=[max_angl_arr max(cur_slope_angle_arr)];
            min_angl_arr=[min_angl_arr min(cur_slope_angle_arr)];
    end
    % 获得最大斜率的最小值 和 最小斜率的最大值 得到他们的均值
    lowb_max_ang=min(max_angl_arr);
    uppb_min_ang=max(min_angl_arr);
    [xst_com_range,fin_rad_angle] = round_common_range(uppb_min_ang,lowb_max_ang);
%     fin_rad_angle = 0.5*(lowb_max_ang+uppb_min_ang);
    % 这里增加对点的范围给定
    
    % 更新下一个采样点
    for i=1:length(ml)
        int_v=[];
        int_v_arr= get_int_v2d(v,ml(i).l,ml(i).v_phi(nodi,:),fin_rad_angle);
        is_interp=0;
        if ~isempty(int_v_arr) % 有交叉点的情况下对交叉点进行分类，将角度允许范围内的交叉点筛选出来
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
        if isempty(int_v) %除了没有交叉点的情况还有得到的交叉点没有在允许角度范围内
            is_interp=1;
            vc_radial_angl = mean(phi_range(:,nodi))-(pass_zero)*pi; %从中心点射出的角度  这里也需要作 圆周角处理
            radial_end = get_radius_line(ml(i).v_phi(nodi,:),fin_rad_angle);
            int_v = get_int_v2d([ml(i).v_phi(nodi,:);radial_end],...    % 建立一条线段，两端点用；隔开
                                        [1 2],...                       % 注册lines
                                   ml(i).vc,vc_radial_angl);
        end
        int_v = int_v(1,:); % 选取符合条件的第一个
        ml(i).v_phi(nodi+1,:) = int_v;
        ml(i).slp_ang(nodi) = fin_rad_angle;
        if debug
            figure(i);
            plot( ml(i).v_phi(nodi+1,1), ml(i).v_phi(nodi+1,2),'ro'); % 这里画采样点
            plot( [ml(i).v_phi(nodi,1) ml(i).v_phi(nodi+1,1)],... 
                  [ml(i).v_phi(nodi,2) ml(i).v_phi(nodi+1,2)],'g');
        end
    end
    nodi = nodi + 1;
    
    % debug 模块
    if debug
      if ~isempty(x_hd)
        delete(x_hd);  
      end
      disp(strcat('interplation status:',num2str(is_interp)));
    end
end

    
% 这里处理最后一个点的情况
terminal_slp=[];      %记录最后采样点与初始采样点的角度
for i=1:length(ml)
    terminal_slp=[terminal_slp transform_slope_to_angle(ml(i).v_phi(end,:),ml(i).v_phi(1,:))];
end
terminal_slp = mod(terminal_slp + pi,2*pi)-pi;   % 范围在 [-pi pi] 中间
max_tmnl_slp = max(terminal_slp);
min_tmnl_slp = min(terminal_slp);

for i=1:length(ml)
    radial_end = get_radius_line(ml(i).v_phi(end,:),min_tmnl_slp-0.1);
    int_v = get_int_v2d([ml(i).v_phi(end,:);radial_end],...    % 建立一条线段，两端点用；隔开
                                            [1 2],...                       % 注册lines
                                       ml(i).v_phi(1,:),max_tmnl_slp+pi+0.1);
    ml(i).v_phi(end+1,:)=int_v;    
    if debug
        figure(i);
        plot( ml(i).v_phi(end,1), ml(i).v_phi(end,2),'ro'); % 这里画最后一个采样点
    end
end
       
        
n=n+1;

    if debug % 画个图
%         title(strcat('n=',num2str(n)));
        for i=1:length(ml)   % 这里最后画连接的线段
            cur_ml=ml(i);
            figure(i)
            for j=1:n
                X=[cur_ml.v_phi(j,1)  cur_ml.v_phi(mod(j,n)+1,1)];
                Y=[cur_ml.v_phi(j,2)  cur_ml.v_phi(mod(j,n)+1,2)]; % 这里的mod 是为了首尾链接
                plot(X,Y,'g');
            end
        end           
    end
    
out_ml = ml;
end




function [hit,fin_angle] = round_common_range(upa,lwa)
    % 输出一系列弧度值的公共范围
    % upa 是 弧度的上界组 lwa 是 弧度的下界组
    % 假设它们都是在一个pi 的范围之内
    % 首先对它们进行弧度值的归一化
    if max([upa lwa])-min([upa lwa])>pi
        upa = mod(upa + pi , 2*pi) - pi;
        lwa = mod(lwa + pi , 2*pi) - pi;
    end
    
    % 假设upa与lwa同一个索引位置下的上下界正确
    % 输出 hit-range 
    if min(upa)<max(lwa) %存在公共范围  
        % 这个公共范围仅适用于 2个轮廓
       hit = 1;
    else
        % 这里进行不存在公共范围的处理，输出一个弧度值
       hit = 0;
    end
    fin_angle = 0.5*(min(upa)+max(lwa));
end
function radial_end=get_radius_line(beg_v,angle,len)
    if nargin==2   % 长度没指定
        len=10;
    end
    cp=cos(angle);
    sp=sin(angle);
    RotP= [cp  sp;
           -sp cp];
    radial_end = [len 0]*RotP+beg_v;   
end

% debug 函数代码
function [int_v,radial]=get_int_v2d_test(v,lines,beg_v,angle)
     % 射线的长度
    
    cp=cos(angle);
    sp=sin(angle);
    Rot_P=[cp  -sp;      %在XZ面上旋转
           sp   cp];
    RotP= [cp  sp;
           -sp cp];
    int_v = zeros(1,2);
    v_rel=v-repmat(beg_v,size(v,1),1);   %对每一个点建立从重心到该点的相对位移向量
    v_rot=v_rel*Rot_P;         % 对每一个向量进行旋转（顺时针）
    for j=1:size(lines,1)
        stp=v_rot(lines(j,1),:);
        fnp=v_rot(lines(j,2),:);
        if(stp(2)*fnp(2)<0) % signs are different
            lambda=0-fnp(2)/(stp(2)-fnp(2));
            x=lambda*(stp(1)-fnp(1))+fnp(1);     %获得与轴相交点的x插值
            if(x>0.01)                   % 判断x是否在正轴上
                int_v=[x 0];   %若是 则保留该点
            end
        end
    end
    int_v=int_v*RotP+beg_v;      %还原该点到原位置（逆时针）
    radial = [10 0]*RotP+beg_v;
    
    
end



