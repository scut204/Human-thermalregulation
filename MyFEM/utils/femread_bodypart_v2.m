function bodypart_feminfo=femread_bodypart_v2(bodypart)
% 原先的mesh网格在这个函数里进行改造
% 但是生成的六面体网格外表面并不是共面的，如果有结构的六面体网格还可以继续使用，如果没有就先暂时这样
%
% 18.1.17
% 与v1的不同在于，这里把内部的组织用可变半径的圆柱体代替
    fl=size(bodypart.v_phi,3);
    n_sp=size(bodypart.v_phi,1);
    
    % 这里自动计算生成
    bodypart_feminfo.floors=fl;
    bodypart_feminfo.num_cirp=n_sp;
    bodypart_feminfo.num_point=fl*n_sp*4;                         % 点总数           
    bodypart_feminfo.num_face=n_sp*3*fl+n_sp*4*(fl-1)+n_sp*3*(fl-1);             % 面总数
    bodypart_feminfo.num_element=n_sp*3*(fl-1);                      % 元素总数
    
    
    v=[];          %点信息矩阵
    f4b=[];        %XY面
    f4sd=[];       %侧面
    f4fr=[];       %径面
    faces=[];      %总的面矩阵
    ele1=[];       %第一层元素
    ele2=[];       %第二层元素
    ele3=[];       %第三层元素
    phi=2*pi/n_sp   :    2*pi/n_sp    :    2*pi;  % 初始化n_sp个角度的角度组
    rad_rate = .9;
    
    
    % make the first floor of v and f
    v_phi=bodypart.v_phi(:,:,1);
    vic=mean(v_phi);
    vic_mindis = min(sqrt(sum((v_phi-repmat(vic,n_sp,1)).^2,2)));
    itn_cir_rad = (vic_mindis)*rad_rate; % 内部半径取最短距离的0.9
    
    v=[v;v_phi];
    for j=0:2
        ps=vic + [cos(phi') repmat([0],n_sp,1) sin(phi')]*itn_cir_rad*(3-j)/3;    % 这里对于角度的问题还需要再看
        v=[v;ps];      % v expands downward
    end
    fc1=1:n_sp;        % fc1 面的第一个点
    fc2=mod(fc1,n_sp)+1;
    for j=1:3     % outside 3 layers
        ftemp=[fc1;fc1+n_sp;fc2+n_sp;fc2]; 
        f4b=[f4b ftemp];
        fc1=fc1+n_sp;
        fc2=fc2+n_sp;
    end
    faces=[faces f4b];
%     f3b=[f3b fc1;repmat(n_sp*4+1,1,n_sp);fc2];
    

    %（这里以后可以再参数化）
    
    %给面元的索引用
    num_pfv=n_sp*4;   % 每一层的点的数量   
    
    %给体元的索引用
    num_b_fr=n_sp*3;     % 底部面数量和切向面的数量
    num_sd=n_sp*4;      % 径向侧面的数量
    num_pff=n_sp*10;    %每一层面的数量
    
    % and the else
    for i=2:fl
        v_phi=bodypart.v_phi(:,:,i);
        vic=mean(v_phi);
        vic_mindis = min(sqrt(sum((v_phi-repmat(vic,n_sp,1)).^2,2)));
        itn_cir_rad = vic_mindis*rad_rate; % 内部半径取最短距离的0.9
        v=[v;v_phi];
        for j=0:2
            ps=vic + [cos(phi') repmat([0],n_sp,1) sin(phi')]*itn_cir_rad*(3-j)/3;    % 这里对于角度的问题还需要再看
            v=[v;ps];      % v expands 
        end

        fc1=(1:n_sp)+num_pfv*(i-1);
        fc2=mod(fc1,n_sp)+1+num_pfv*(i-1);
        
        f4bt=[];     % 点的顺序是从上往下走
        f4sdt=[];    % 径向面需要单独做处理
        f4frt=[];    % 切向面
        for j=1:3    % 处理外面3层
            f4bt=[f4bt [fc1;fc1+n_sp;fc2+n_sp;fc2]];      % 地板天花顶面
            f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];    % 径向面
            f4frt=[f4frt [fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv]];    % 切向面
            fc1=fc1+n_sp;
            fc2=fc2+n_sp;
        end
        f4sdt=[f4sdt [fc1;fc1-num_pfv;fc2-num_pfv;fc2]];
        f4b=[f4b f4bt];
        f4sd=[f4sd f4sdt];
        f4fr=[f4fr f4frt];
        faces=[faces f4sdt f4frt f4bt];    % 面的结构【底面（3）、径向面（4）、切相面（3）（循环）】
        % 测试 面与 点的位置
        % 测试元素的六面索引
        % 处理内部核心层        
        ec1=(1:n_sp)+num_pff*(i-2);        % num_pff 10    
        ec2=ec1+num_b_fr;                  % num_b_fr 3
        ec3=ec2+num_sd;                    % num_sd   4
        circle_offset=mod(1:n_sp,n_sp)-(1:n_sp);
        % 对面的索引
        elem_seq6=[ec1;                 % 12行是底与顶
                   ec1+num_pff;         
                   ec2;                 % 34行是径向面 由外向内
                   ec2+n_sp;
                   ec3;                 %56行是切向面
                   ec3+circle_offset+1];    

        ele1=[ele1 elem_seq6];     % 处理一层
        ele2=[ele2 elem_seq6+n_sp];
        ele3=[ele3 elem_seq6+n_sp*2];

    end

    bodypart_feminfo.v=v;
    bodypart_feminfo.f=faces';
    bodypart_feminfo.e1=ele1';
    bodypart_feminfo.e2=ele2';
    bodypart_feminfo.e3=ele3';
end
