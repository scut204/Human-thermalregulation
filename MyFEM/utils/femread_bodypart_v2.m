function bodypart_feminfo=femread_bodypart_v2(bodypart)
% 原先的mesh网格在这个函数里进行改造
% 但是生成的六面体网格外表面并不是共面的，如果有结构的六面体网格还可以继续使用，如果没有就先暂时这样
%
% 18.1.17
% 与v1的不同在于，这里把内部的组织用可变半径的圆柱体代替
% bodypart_feminfo 的结构：
%     bodypart_feminfo.floors      
%     bodypart_feminfo.num_cirp    每一层环的点数 这里设置成30
%     bodypart_feminfo.num_point   点总数 
%     bodypart_feminfo.num_face    面总数
%     bodypart_feminfo.num_element 元素总数
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
    
    % 这里自动计算生成
    bodypart_feminfo.floors=fl;
    bodypart_feminfo.num_cirp=n_sp;    % 每层采样点数
    bodypart_feminfo.num_point=fl*(n_sp*4+1);                         % 点总数           
    bodypart_feminfo.num_face=n_sp*4*fl+ ...    % 底面 
							  n_sp*4*(fl-1)+ ...% 径面
							  n_sp*4*(fl-1);    % 侧面              % 面总数
    bodypart_feminfo.num_element=n_sp*4*(fl-1);                      % 元素总数
    
    
    v=[];          %点信息矩阵
    f4b=[];        %XY面  如果Z是高度
    
    f4sd=[];       %侧面
    f4fr=[];       %径面
    faces=[];      %总的面矩阵
	faces3=[];	  %三角面矩阵
    ele1=[];       %第一层元素
    ele2=[];       %第二层元素
    ele3=[];       %第三层元素
    ele4=[];       %最内层元素  格式与前三层不同
    phi=2*pi/n_sp   :    2*pi/n_sp    :    2*pi;  % 初始化n_sp个角度的角度组
    rad_rate = .58;    % 圆柱外层的厚度
    skin_rate = .95;  % 除去皮肤层的厚度
    fat_rate = rad_rate;
    muscle_rate =.19;
    rate_arr = [skin_rate fat_rate muscle_rate];
    
    % make the first floor of v and f
    v_phi=bodypart.v_phi(:,:,1);
    v = get_v_1f(v_phi,v,n_sp,rate_arr);
	
    fc1=1:n_sp;        % fc1 面的第一个点
    fc2=mod(fc1,n_sp)+1;
    for j=1:3     % 最外层的三个点
        ftemp=[fc1;fc1+n_sp;fc2+n_sp;fc2]; 
        f4b=[f4b ftemp];	
        fc1=fc1+n_sp;
        fc2=fc2+n_sp;
    end  % fc1 到达第四层环
    faces3=[faces3 [fc1;fc2;repmat(fc1(1)+n_sp,1,n_sp)]];
    faces=[faces f4b];
%     f3b=[f3b fc1;repmat(n_sp*4+1,1,n_sp);fc2];
    

    %（这里以后可以再参数化）
    
    %给面元的索引用
    num_pfv=n_sp*4+1;   % 每一层的点的数量   
    
    %给体元的索引用
    
    num_sd=n_sp*4;      % 每一层三种面的数量相同
	num_b = n_sp*3;     % 底面还是三层
    num_pf4f=n_sp*11;    %每一层四边形面的数量
	num_pf3f=n_sp*1;    %每一层三角面的数量
    
    % and the else
    for i=2:fl
        v_phi=bodypart.v_phi(:,:,i);
        v = get_v_1f(v_phi,v,n_sp,rate_arr);
        

        fc1=(1:n_sp)+num_pfv*(i-1);   % fc1 是上层的第一个点
        circle_offset=mod(1:n_sp,n_sp)-(1:n_sp);
        fc2=fc1+circle_offset+1; % fc2 和fc1同层 右边第二个点
        
        f4bt=[];     % 点的顺序是从上往下走
        f4sdt=[];    % 径向面需要单独做处理
        f4frt=[];    % 切向面
		f3bt=[];    % 三角底面
        for j=1:3    % 处理外面3层
            f4bt=[f4bt [fc1;fc1+n_sp;fc2+n_sp;fc2]];      % 地板天花顶面
            f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];    % 径向面
            f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];    % 切向面
            fc1=fc1+n_sp;
            fc2=fc2+n_sp;
        end
        f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];
		f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];  % 三角柱的切向面
		f3bt = [fc1;fc2;repmat(fc1(1)+n_sp,1,n_sp)];
	    faces=[faces f4sdt f4frt f4bt];    % 
		faces3=[faces3 f3bt];
		% 这里只是用来记录
        f4b=[f4b f4bt];  
        f4sd=[f4sd f4sdt];
        f4fr=[f4fr f4frt];
		
        % 面的结构【底面（3）、径向面（4）、切相面（4）（循环）】
		% 加上三角面的底面
        % 测试 面与 点的位置
        % 测试元素的六面索引
        % 处理内部核心层        
        ec1=(1:n_sp)+num_pf4f*(i-2);        % num_pf4f 11   
        ec2=ec1+num_b;                  % num_b_fr 3
        ec3=ec2+num_sd;                    % num_sd   4
        
		
		% 三角面的ec
		e3c1 = (1:n_sp)+num_pf3f*(i-2);
        % 对面的索引
        elem_seq6=[ec1;                 % 12行是底与顶
                   ec1+num_pf4f;         
                   ec2;                 % 34行是径向面 由外向内
                   ec2+n_sp;
                   ec3;                 %56行是切向面
                   ec3+circle_offset+1];    
	    elem_seq5=[e3c1;                % 12行是底与顶
				   e3c1 + num_pf3f;	   % 索引的是face3面矩阵
				   ec2 + n_sp*3;	 	 % 剩下的是径向面和切向面
				   ec3 + n_sp*3;
				   ec3 + n_sp*3+circle_offset+1;
				  ];
        ele1=[ele1 elem_seq6];     % 处理一层
        ele2=[ele2 elem_seq6+n_sp];
        ele3=[ele3 elem_seq6+n_sp*2];
	    ele4=[ele4 elem_seq5];
    end

    bodypart_feminfo.v=v;
    bodypart_feminfo.f=faces';
    bodypart_feminfo.f3 = faces3';
    bodypart_feminfo.e1=ele1';    %  皮肤层 需要用
    bodypart_feminfo.e2=ele2';
    bodypart_feminfo.e3=ele3';
    bodypart_feminfo.e4=ele4';
    
    bodypart_feminfo.info = strcat('6_nodes_ele contains faces of [bottom ceil front behind side1 side2]\n', ...
                                   '5_nodes_ele contains faces of [bottom(index from face3) ceil front side1 side2]');
                            
                            
    
end


function v = get_v_1f(v_phi,v,n_sp,rate_arr)
            vic=mean(v_phi);      % 中心点
    %     v_sub_skin = (v_phi-repmat(vic,n_sp,1))*skin_rate+repmat(vic,n_sp,1);
    %     vic_mindis = min(sqrt(sum((v_sub_skin-repmat(vic,n_sp,1)).^2,2)));
    %     itn_cir_rad = (vic_mindis)*rad_rate; % 内部半径取最短距离的厚度
        v=[v;v_phi];   % 加入下层皮肤
        for j=1:3
    %         ps=repmat(vic,n_sp,1) + [cos(phi') zeros(n_sp,1) sin(phi')]*itn_cir_rad*(2-j)/2;    % 这里对于角度的问题还需要再看
            ps = (v_phi-repmat(vic,n_sp,1))*rate_arr(j)+repmat(vic,n_sp,1);
            v=[v;ps];      % v expands downward
        end
		v = [v;vic];    % 将中心点包括进去
end
