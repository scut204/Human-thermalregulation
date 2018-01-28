function [int_v]=get_int_v2d(v,lines,beg_v,angle)

% 记录所有的交叉点
% 返回的int_v为所有交叉点的坐标， 以行向量的形式组合
    cp=cos(angle);
    sp=sin(angle);
    Rot_P=[cp  -sp;      %在XZ面上旋转
           sp   cp];
    RotP= [cp  sp;
           -sp cp];
    int_v = zeros(1,2);
    v_rel=v-repmat(beg_v,size(v,1),1);   %对每一个点建立从重心到该点的相对位移向量
    v_rot=v_rel*Rot_P;         % 对每一个向量进行旋转（顺时针）
    int_v=[];
    for j=1:size(lines,1)
        stp=v_rot(lines(j,1),:);
        fnp=v_rot(lines(j,2),:);
        if(stp(2)*fnp(2)<0) % signs are different
            lambda=0-fnp(2)/(stp(2)-fnp(2));
            x=lambda*(stp(1)-fnp(1))+fnp(1);     %获得与轴相交点的x插值
            if(x>0.01)                   % 判断x是否在正轴上
                int_v=[int_v;
                        x 0];   %若是 则保留该点
            end
        end
    end
    if ~isempty(int_v)    % 说明有交叉点
        int_v=int_v*RotP+repmat(beg_v,size(int_v,1),1);      %还原该点到原位置（逆时针）
    end
end