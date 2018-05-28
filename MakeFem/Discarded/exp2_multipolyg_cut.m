% 这次进行联合的斜率规划
% 初始 lineclass 是一个结构体，包括了 l 和 
close all;
clearvars;
load('exp_two_polygons.mat');
load('exp_LR_limbs.mat');
vert_2d=v(:,[1 3]);    % 将 点集 二维化
vert_3d=v;
narr=[10];

debug=0;
if debug
    figure(1);view(3);hold on;
    for i=1:14 %length(linesclass_L)
        for j=1:size(linesclass_L(i).l,1)
            X=[v(linesclass_L(i).l(j,1),1) v(linesclass_L(i).l(j,2),1)];
            Y=[v(linesclass_L(i).l(j,1),2) v(linesclass_L(i).l(j,2),2)];
            Z=[v(linesclass_L(i).l(j,1),3) v(linesclass_L(i).l(j,2),3)];
            plot3(X,Y,Z,'r');
        end
    end

end


for k=1:length(narr)
    n=narr(k);

    % 环境测试完毕
    % 以上是一个略非凸的轮廓几何

    % 质量检测用面积比参数

    % 整理变量
    v=vert_2d;    
    lineclass=linesclass_L(1:14); % 先用左腿进行测试
    
    % 计算中心点、每个点到中心点的角度
    for i=1:length(lineclass)
        temp_l=lineclass(i).l;
        ang=[];
        lineclass(i).vc=mean(v(temp_l(:,1),:));    %因为所有轮廓都是闭合的，所以只需要索引到点的第一列来计算中心点
        for j=1:size(temp_l,1)
            ang=[ang;
                transform_slope_to_angle(lineclass(i).vc,v(temp_l(j,1),:)) ...
                transform_slope_to_angle(lineclass(i).vc,v(temp_l(j,2),:))];
        end
        lineclass(i).ang=ang;
    end

    
    
    lineclass=progress_v3_multicircle_mesh_cut(v,lineclass,n);   % 暂时先在2d的情况下进行
    
end

for i=1:length(lineclass)
    lineclass(i).v_phi=[lineclass(i).v_phi(:,1) i*ones(size(lineclass(i).v_phi,1),1) lineclass(i).v_phi(:,2)];
end

plot_lineclass(lineclass);


