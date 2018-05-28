function [v_phi,v1c]=progress_v2_circle_mesh_cut(v,lines,n)

% 这个函数的功能是迭代对一个多边形进行环形切割。
% 暂时先不加入对多边形组的统筹分割的功能
% 采用的方法是枚举法
% 首先是建立初始点，这里放在多边形区域的下方
% 然后根据采样点建立角度组，然后对每个角度进行测试微调

% if ~exist(label)
%     lines1=lines(label(lines(:,1))==con,:);    %
%     v1=v(label==con,:);   %y=0.3   
% end

% 11/29 进行最后一点的debug
% 暂时先把每一点发射的射线标注出来
% BUG修复完成
v1c=mean(v);
num_phi=n;    % 圆的采样点的数量
phi=pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;    % 建立初步的采样的角度组
     %初始化返回值     
init_v=get_int_v2d(v,lines,v1c,1.5*pi);% 获得初始点   这个是一定能够获得的
v_phi(1,:)=init_v;        % v_phi 用来存储顺序的点

   % 这里不得不写得比较丑陋，为了自己的逻辑着想
   i=1;
   while(i<n) % i 到 n-1 运行完后停止
%        int_v=get_int_v2d(v,lines,v_phi(i,:),phi(i));   
       [int_v,radial]=get_int_v2d_test(v,lines,v_phi(i,:),phi(i));      %这里进行debug  
       if norm(int_v-v_phi(i,:))<1e-4     %是则说明没有找到合适的内插点，需要重新分配一个角度
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
   
   %  画出最后一个点
            X=[v_phi(n,1) ];
            Y=[v_phi(n,2) ];
            plot(X,Y,'ro');    
end


function [int_v,radial]=get_int_v2d_test(v,lines,beg_v,angle)
    len = 10;  % 射线的长度
    
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

