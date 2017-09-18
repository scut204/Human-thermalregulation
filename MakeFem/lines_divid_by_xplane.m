function [vl_o,lines_o]=lines_divid_by_xplane(vl_i,lines_i,x_c)
    % first build a unsorted vertex set
    % default there will only be two points that divides the circle
    np=0;     % 记录切点数量
    vl=vl_i;
    n_v=size(vl,1);
    lines=lines_i;
    n_l=size(lines,1);
    ps=[];    %记录内插点的属性
    
    cut_lines_ind=[];   %记录切点在lines中的位置
    
    for i=1:n_l
        v=[vl(lines(i,1),:);vl(lines(i,2),:)];
        lamda=( x_c-v(1,1) )/( v(2,1)-v(1,1) );
            if(lamda<1 && lamda >0)
                % find the cut point
                np=np+1;
                ps=[ps;lamda*(v(2,:)-v(1,:))+v(1,:)];
                cut_lines_ind=[cut_lines_ind i];
        end
    end
    if np>=2
        [ps_sort,IA]=sort(ps(:,3),'descend');     %sort by z;
        p_interval=abs(ps_sort(1:end-1)-ps_sort(2:end));
        [~,itv_ind]=max(p_interval);
%         IC(IA)=1:length(IA); 
        p1_ind=IA(itv_ind);      %获得p1与p2在ps中的位置
        p2_ind=IA(itv_ind+1);
        
        
        ps=ps([p1_ind p2_ind],:);
        cti=cut_lines_ind([p1_ind p2_ind]);
        ind_app=n_v+(1:4);     % add the vertex index
        for i=1:2
            line_fr=lines(cti(i),vl(lines(cti(i),:),1)>x_c);
            line_bk=lines(cti(i),vl(lines(cti(i),:),1)<x_c);
            
            vl(ind_app(2*i-1),:)=ps(i,:);
            vl(ind_app(2*i),:)=ps(i,:);
            lines=[lines;line_fr ind_app(2*i-1);ind_app(2*i) line_bk]; 
        end
        lines(cti,:)=[];    % delete the original lines
        lines=[lines;ind_app(1) ind_app(3);ind_app(2) ind_app(4)];  
    elseif np==0
        disp('the cut process does not produce the cut line');
    else
        disp('There is something wrong,the np=')
        disp(np)
    end
    lines_o=lines;
    vl_o=vl;
    

end