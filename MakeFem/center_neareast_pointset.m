function [chosen_vphi,updvc]=center_neareast_pointset(v_phi_array,v_center_array,vi_c)
        distarr=sum((v_center_array-repmat(vi_c,size(v_phi_array,3),1)).^2,2);
        [~,minind]=min(distarr);
        chosen_vphi=v_phi_array(:,:,minind);
        updvc=v_center_array(minind,:);
end