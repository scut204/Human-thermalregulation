function [v_phi,v1c]=progress_circle_mesh_cut(v,lines,label,n,con)
lines1=lines(label(lines(:,1))==con,:);    %
v1=v(label==con,:);   %y=0.3
v1c=mean(v1);

num_phi=n;    % 圆的采样点的数量
phi=pi/num_phi:2*pi/num_phi:2*pi-pi/num_phi;    % 建立采样的角度组
     %初始化返回值
init_v=get_int_v(v,lines1,v1c,1.5*pi);% 获得初始点
v_phi(1,:)=init_v;
   for i=1:n-1
       v_phi(i+1,:)=get_int_v(v,lines1,v_phi(i,:),phi(i));
   end

end

function [int_v]=get_int_v(v,lines,beg_v,phi)
    cp=cos(phi);
    sp=sin(phi);
    Rot_P=[cp 0 -sp;      %在XZ面上旋转
           0  1   0;
           sp 0  cp];
    RotP= [cp 0  sp;
           0  1  0;
           -sp 0 cp];
    v_rel=v-repmat(beg_v,size(v,1),1);   %对每一个点建立从重心到该点的相对位移向量
    v_rot=v_rel*Rot_P;         % 对每一个向量进行旋转
    for j=1:size(lines,1)
        stp=v_rot(lines(j,1),:);
        fnp=v_rot(lines(j,2),:);
        if(stp(3)*fnp(3)<0) % signs are different
            lambda=0-fnp(3)/(stp(3)-fnp(3));
            x=lambda*(stp(1)-fnp(1))+fnp(1);     %获得与z轴相交点的x插值
            if(x>0.01)                   % 判断x是否在正轴上
                int_v=[x stp(2) 0];   %若是 则保留该点
            end
        end
    end
    int_v=int_v*RotP+beg_v;      %还原该点到原位置
end