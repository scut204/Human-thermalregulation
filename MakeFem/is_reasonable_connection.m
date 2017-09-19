function [is_closed,area]=is_reasonable_connection(vl,lines,label,li)

    %
    ll=lines(label(lines(:,1))==li,:); 
    v=vl(label==li,:);
    
    if(size(ll,1)<size(v,1))  % 肯定是开区间
        is_closed=false;
    elseif(size(ll,1)==size(v,1))
            is_closed=true;
    else
        % 目前先忽略内部环不去消除它
            disp('something wrong with lines or this function.')
            disp('num_vertex   num_lines')
            disp([ size(v,1) size(ll,1)])
            is_closed=true;
    end
            
    area=(max(v(:,1))-min(v(:,1)))*(max(v(:,3))-min(v(:,3)));
end