%%%%%%%%%%%%%
% v vertex matrix m*3
% f cell array depicting the faces matrix of fn
% points  the intersection of meshcut algorithm
% tianyi 8/14;
%%%%%%%%%%%%
clearvars;
if ~exist('human_nodfh_vf.mat')
[v,f]=zread_mesh('human_nodfh.obj');

save('human_nodfh_vf.mat','v','f');
else 
    load('human_nodfh_vf.mat');
end
% zplot_mesh(v,f); hold on;

% get the mesh cut point set, extract the lines and vertex.

% status=0;
% ymax=max(v(:,2));
% ymin=min(v(:,2));
% sfh=1;
% ys=ymin:sfh:ymax;
% for flr=1:length(ys)
%     points=[];
%     for i=1:length(f)
%          points=y_plane_cut_test(v',f{i}',points,0.6);
%          points=y_plane_cut_test(v',f{i}',points,0.3);
%     end
% end

    for i=1:length(f)
         points=y_plane_cut_test(v',f{i}',points,0.6);
         points=y_plane_cut_test(v',f{i}',points,0.3);
    end
clear y_plane_cut_test;
[v,lines]=extract_vertex_n_lines(points);    %  modified from official function, so it's quick.
% plot_testvl(v,lines,'r');

% get the connections 
C=make_component_graph(lines);
[label,~]=graph_connected_components(C);
plot_divided_vl(v,lines,label);

% match the point between the adjacent floors.
n=30;
[v2_phi,v2c]=radial_mesh_cut(v,lines,label,n,3);
[v5_phi,v5c]=radial_mesh_cut(v,lines,label,n,4);

body2=make_body_section(v2_phi,v2c);
body5=make_body_section(v5_phi,v5c);
draw_internal_section(body2);
draw_internal_section(body5);

% for i=1:n
%     XX=[v2_phi(i,1) v5_phi(i,1)];
%     YY=[v2_phi(i,2) v5_phi(i,2)];
%     ZZ=[v2_phi(i,3) v5_phi(i,3)];
%     plot3(XX,YY,ZZ);hold on;
% end




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






