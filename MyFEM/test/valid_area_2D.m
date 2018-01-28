        p1=[0 0 0];
        p2=[1 0 0];
        p3=[1 1 0];
        p4=[0 1 0];


J=quad_area(p1,p2,p3,p4)*0.5;




function area=quad_area(p1,p2,p3,p4)
    m1=p1-p2;
    m2=p2-p3;
    avec=cross(m1,m2);
    area=dot(avec,avec,2).^(1/2);    %三角形面积
    
    m1=p3-p4;
    m2=p4-p1;
    avec=cross(m1,m2);
    area=area+dot(avec,avec,2).^(1/2);
    area=area * 0.5;
end