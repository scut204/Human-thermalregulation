%%%%%%%%%%%%%
% v vertex matrix m*3
% f cell array depicting the faces matrix of fn
% points  the intersection of meshcut algorithm
% tianyi 8/14;
%%%%%%%%%%%%
% this plot is to create multiple pologons 
% to test the parallel line segments performances 
% tianyi 12/1
%%%%%%
% use it to produce the polygon data structure
% 
%
%%%%%
clearvars;
close all;
if ~exist('human_nodfh_vf.mat')
    [v,f]=zread_mesh('human_nodfh.obj');

    save('human_nodfh_vf.mat','v','f');
else 
    load('human_nodfh_vf.mat');
end
% zplot_mesh(v,f); hold on;
points=[];
% 切出两个平面
y=-41.1:1:-14;
for j=1:length(y)
    for i=1:length(f)
         points=y_plane_cut_test(v',f{i}',points,y(j));
    end
end
clear y_plane_cut_test;
[v,lines]=extract_vertex_n_lines(points);    %  modified from official function, so it's quick.
% plot_testvl(v,lines,'r');
% get the connections 
v_sel_indice = find(v(lines(:,1),1)<0);    % 里面包括了所有v的符合条件的索引
lines_L = lines(ismember(lines(:,1),v_sel_indice),:);

C=make_component_graph(lines_L);
[label,~]=graph_connected_components(C);
figure(1);
plot_divided_vl(v,lines_L,label);
for i=1:floor(max(label))
    linesclass_LR(i).l=lines(label(lines(:,1))==i,:);
%     linesclass_R(i).l=lines(label(lines(:,1))==2*i,:);
end

save('exp_LR_limbs.mat','v','linesclass_L','linesclass_R');
% match the point between the adjacent floors.
n=6;
[v2_phi,v2c]=progress_circle_mesh_cut(v,lines,label,n,3);
[v5_phi,v5c]=progress_circle_mesh_cut(v,lines,label,n,4);

% body2=make_body_section(v2_phi,v2c);
% body5=make_body_section(v5_phi,v5c);
% draw_internal_section(body2);
% draw_internal_section(body5);

figure(2);hold on;view(3);
lines_34=lines(label(lines(:,1))==3|label(lines(:,1))==4,:);
plot_testvl(v,lines_34);
for i=1:n
    XX=[v2_phi(i,1) v5_phi(i,1)];
    YY=[v2_phi(i,2) v5_phi(i,2)];
    ZZ=[v2_phi(i,3) v5_phi(i,3)];
    plot3(XX,YY,ZZ);
    
    XX=[v2_phi(i,1) v2_phi(mod(i,n)+1,1)];
    YY=[v2_phi(i,2) v2_phi(mod(i,n)+1,2)];
    ZZ=[v2_phi(i,3) v2_phi(mod(i,n)+1,3)];
    plot3(XX,YY,ZZ);             
                                 
    XX=[v5_phi(i,1) v5_phi(mod(i,n)+1,1)];
    YY=[v5_phi(i,2) v5_phi(mod(i,n)+1,2)];
    ZZ=[v5_phi(i,3) v5_phi(mod(i,n)+1,3)];
    plot3(XX,YY,ZZ);
end




function draw_internal_section(body)
    a1=[body.skin;body.skin(1,:)];
    a2=[body.muscle;body.muscle(1,:)];
    a3=[body.tissue;body.tissue(1,:)];
    a4=[body.bone;body.bone(1,:)];
    a5=[body.kernel;body.kernel(1,:)];
    connection_between_layers(a1,a2);
    connection_between_layers(a2,a3);
    connection_between_layers(a3,a4);
    connection_between_layers(a4,a5);
    ac=body.center;
    for i=1:size(a5,1)-1
        x=[a5(i,1) a5(i+1,1) ac(1) a5(i,1)];
        y=[a5(i,2) a5(i+1,2) ac(2) a5(i,2)];
        z=[a5(i,3) a5(i+1,3) ac(3) a5(i,3)];
        plot3(x,y,z);hold on;
    end

end
function connection_between_layers(v1,v2)
    for i=1:size(v1,1)-1
        x=[v1(i,1) v1(i+1,1) v2(i+1,1) v2(i,1) v1(i,1)];
        y=[v1(i,2) v1(i+1,2) v2(i+1,2) v2(i,2) v1(i,2)];
        z=[v1(i,3) v1(i+1,3) v2(i+1,3) v2(i,3) v1(i,3)];
        plot3(x,y,z);hold on;
    end

end
function body=make_body_section(vn_phi,vnc)
    body.skin=vn_phi;
    body.muscle=(vn_phi-repmat(vnc,size(vn_phi,1),1))*0.8+repmat(vnc,size(vn_phi,1),1);
    body.tissue=(vn_phi-repmat(vnc,size(vn_phi,1),1))*0.6+repmat(vnc,size(vn_phi,1),1);
    body.bone=(vn_phi-repmat(vnc,size(vn_phi,1),1))*0.4+repmat(vnc,size(vn_phi,1),1);
    body.kernel=(vn_phi-repmat(vnc,size(vn_phi,1),1))*0.2+repmat(vnc,size(vn_phi,1),1);
    body.center=vnc;
end






