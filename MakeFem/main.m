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

% debug
debug=0;


% get the mesh cut point set, extract the lines and vertex.

status=0;
ymax=max(v(:,2));
ymin=min(v(:,2));
sfh=0.8;    % 每一层的高度
ys=ymin:sfh:ymax;
num_ringp=30;   % 每一层的点数
cur=1;

if(debug)
    cur=57;
    status=3;
end

if ~exist('body.mat')
for flr=cur:length(ys)
    points=[];
    for i=1:length(f)
         points=y_plane_cut_test(v',f{i}',points,ys(flr));
    end
    clear y_plane_cut_test;
    if isempty(points)
        continue;
    end
    [vl,lines]=extract_vertex_n_lines(points);    %  modified from official function, so it's quick.

    % get the connections 
    C=make_component_graph(lines);
    [label,~]=graph_connected_components(C);
    
    % valid the connections
    % record the number of connections
    valid_label=[];
    for li=1:max(label)
        [is_closed,area]=is_reasonable_connection(vl,lines,label,li);  % area variable is saved for future serious judge.
        if is_closed
            valid_label=[valid_label li];
        end
    end
    num_valid_con=length(valid_label);
    
    switch status
        case 0    % initial
            if num_valid_con==2    %state transit
                status=1;
                [vll_phi,vllc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1));
                [vrl_phi,vrlc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(2));
                
                %record the part vertex;
                leftleg.v_phi(:,:,1)=vll_phi;
                leftleg.prevc=vllc;
                rightleg.v_phi(:,:,1)=vrl_phi;
                rightleg.prevc=vrlc;
            end
            
            
            
        case 1    % legs
            if num_valid_con==1    %state transit
                status=2;
                [torso.v_phi(:,:,1),torso.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1));
                %dos
            elseif num_valid_con~=2
                 disp('Something error in status 1; num_valid_con=')
                 disp(num2str(num_valid_con));
                 return;
            else
                for con=1:2
                   [v_phi_array(:,:,con),v_center_array(con,:)]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(con));
                end
                le=size(leftleg.v_phi,3);
                [leftleg.v_phi(:,:,le+1),leftleg.prevc]=center_neareast_pointset(v_phi_array,v_center_array,leftleg.prevc);
                [rightleg.v_phi(:,:,le+1),rightleg.prevc]=center_neareast_pointset(v_phi_array,v_center_array,rightleg.prevc);
            end
        case 2      %body no hand
            switch  num_valid_con
                case 3
                    status=3;
                    le=size(torso.v_phi,3);
                    [lefthand.v_phi,lefthand.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1));
                    [torso.v_phi(:,:,le+1),torso.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(2));
                    [righthand.v_phi,righthand.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(3));
                    %dos
                case 2
                    le=size(torso.v_phi,3);
                    for con=1:2
                        [v_phi_array(:,:,con),v_center_array(con,:)]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(con));
                    end
                    [torso.v_phi(:,:,le+1),torso.prevc]=center_neareast_pointset(v_phi_array,v_center_array,torso.prevc);
                case 1
                    le=size(torso.v_phi,3);
                    [torso.v_phi(:,:,le+1),torso.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1));
                otherwise
                  disp('Something error in status 2; num_valid_con=')
                  disp(num_valid_con);
                  return;
            end
        case 3       %body with hands
            switch num_valid_con
                case 1
                    status=4;

                    x_loxt=(max(lefthand.v_phi(:,1,end))+min(torso.v_phi(:,1,end)))/2;
                    x_roxt=(max(torso.v_phi(:,1,end))+min(righthand.v_phi(:,1,end)))/2;
                    [vl,lines]=lines_divid_by_xplane(vl,lines,x_loxt);
                    [vl,lines]=lines_divid_by_xplane(vl,lines,x_roxt);
                   
                    % get the connections 3
                    C=make_component_graph(lines);
                    [label,~]=graph_connected_components(C);
    
                     % valid the connections
                     % record the number of connections
                    valid_label=[];
                    for li=1:max(label)
                        [is_closed,area]=is_reasonable_connection(vl,lines,label,li);  % area variable is saved for future serious judge.
                        if is_closed
                            valid_label=[valid_label li];
                        end
                    end
                    num_valid_con=length(valid_label);
                    
                    lhe=size(lefthand.v_phi,3);
                    rhe=size(righthand.v_phi,3);
                    tle=size(torso.v_phi,3);
                    for con=1:3
                        [v_phi_array(:,:,con),v_center_array(con,:)]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(con));
                    end
%                     [head.v_phi(:,:,1),head.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1)); 
                    [torso.v_phi(:,:,tle+1),torso.prevc]=center_neareast_pointset(v_phi_array,v_center_array,torso.prevc);
                    [lefthand.v_phi(:,:,lhe+1),lefthand.prevc]=center_neareast_pointset(v_phi_array,v_center_array,lefthand.prevc);
                    [righthand.v_phi(:,:,rhe+1),righthand.prevc]=center_neareast_pointset(v_phi_array,v_center_array,righthand.prevc);   
                case 3
                    lhe=size(lefthand.v_phi,3);
                    rhe=size(righthand.v_phi,3);
                    tle=size(torso.v_phi,3);
                    for con=1:3
                        [v_phi_array(:,:,con),v_center_array(con,:)]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(con));
                    end
                    [torso.v_phi(:,:,tle+1),torso.prevc]=center_neareast_pointset(v_phi_array,v_center_array,torso.prevc);
                    [lefthand.v_phi(:,:,lhe+1),lefthand.prevc]=center_neareast_pointset(v_phi_array,v_center_array,lefthand.prevc);
                    [righthand.v_phi(:,:,rhe+1),righthand.prevc]=center_neareast_pointset(v_phi_array,v_center_array,righthand.prevc);    
                case 2
                    % transition status
                    % do nothing
                otherwise
                  disp('Something error in status 2; num_valid_con=')
                  disp(num_valid_con);
                  return;
            end
        case 4       % shoulder
          switch num_valid_con
                case 1
                    [vl,lines]=lines_divid_by_xplane(vl,lines,x_loxt);
                    [vl,lines]=lines_divid_by_xplane(vl,lines,x_roxt);
                   
                    % get the connections 3
                    C=make_component_graph(lines);
                    [label,~]=graph_connected_components(C);
    
                     % valid the connections
                     % record the number of connections
                    valid_label=[];
                    for li=1:max(label)
                        [is_closed,area]=is_reasonable_connection(vl,lines,label,li);  % area variable is saved for future serious judge.
                        if is_closed
                            valid_label=[valid_label li];
                        end
                    end
                    num_valid_con=length(valid_label);
                    if(num_valid_con<3)
                        status=5;
                        [head.v_phi(:,:,1),head.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1));
                    else
                    
                    lhe=size(lefthand.v_phi,3);
                    rhe=size(righthand.v_phi,3);
                    tle=size(torso.v_phi,3);
                    for con=1:3
                        [v_phi_array(:,:,con),v_center_array(con,:)]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(con));
                    end
%                     [head.v_phi(:,:,1),head.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1)); 
                    [torso.v_phi(:,:,tle+1),torso.prevc]=center_neareast_pointset(v_phi_array,v_center_array,torso.prevc);
                    [lefthand.v_phi(:,:,lhe+1),lefthand.prevc]=center_neareast_pointset(v_phi_array,v_center_array,lefthand.prevc);
                    [righthand.v_phi(:,:,rhe+1),righthand.prevc]=center_neareast_pointset(v_phi_array,v_center_array,righthand.prevc); 
                    
                    end
              otherwise
                  disp('emmmmmmmmmm, connections > 1......Check the head');
          end
       case 5       % head
          switch num_valid_con
                case 1
                    hle=size(head.v_phi,3);
                     [head.v_phi(:,:,hle+1),head.prevc]=radial_mesh_cut(vl,lines,label,num_ringp,valid_label(1));
              otherwise
                  disp('emmmmmmmmmm, connections > 1......Check the head');
          end
    end
    
end
arm_cutoff=-1.102;
leg_cutoff=-29.1;

[uplefthand,lowerlefthand]=divide_hand_or_leg(lefthand,arm_cutoff);
[uprighthand,lowerrighthand]=divide_hand_or_leg(righthand,arm_cutoff);
[upleftleg,lowerleftleg]=divide_hand_or_leg(leftleg,leg_cutoff);
[uprightleg,lowerrightleg]=divide_hand_or_leg(rightleg,leg_cutoff);

save('body.mat','uplefthand','lowerlefthand','uprighthand','lowerrighthand',...
    'upleftleg','lowerleftleg','uprightleg','lowerrightleg','torso','head');
else
    load('body.mat');
end









% plot 
figure,1; 

draw_bodypart_skin(upleftleg,'y');
draw_bodypart_skin(lowerleftleg,'r');
draw_bodypart_skin(lowerrightleg,'c');
draw_bodypart_skin(uprightleg,'m');
draw_bodypart_skin(uplefthand,'c');
draw_bodypart_skin(lowerlefthand,'b');
draw_bodypart_skin(uprighthand,'r');
draw_bodypart_skin(lowerrighthand,'k');
draw_bodypart_skin(torso,'g');
draw_bodypart_skin(head,'b');
axis equal;

function [upbd,lowbd]=divide_hand_or_leg(bodypart,cutoff)
%     bodypart.v_phi(1,2,:)>=cutoff
%     chm=repmat(bodypart.v_phi(:,2,:)>=cutoff,1,size(bodypart.v_phi,2),1);
    upbd.v_phi=bodypart.v_phi(:,:,bodypart.v_phi(1,2,:)>=cutoff);
%     chm=repmat(bodypart.v_phi(:,2,:)<=cutoff,1,size(bodypart.v_phi,2),1);
    lowbd.v_phi=bodypart.v_phi(:,:,bodypart.v_phi(1,2,:)<=cutoff);
end

    
