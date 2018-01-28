function angle = transform_slope_to_angle(v1,v2)
%12/3 ���õ��ĽǶȷ�Χ��-pi��pi���0��2pi
    vec = v2-v1;
    angle = atan2(vec(:,2),vec(:,1)); 
    angle = angle .* (angle >= 0) + (angle + 2 * pi) .* (angle < 0); 
end