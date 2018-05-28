function test_fournodes_faces
include_flags;
      i=3;
        node1     = n_bc(1,i);          % first node 
        node2     = n_bc(2,i);          % second node
        node3     = n_bc(3,i);          % third node 
        node4     = n_bc(4,i);          % fourth node 
        p1=[x(node1) y(node1) z(node1)];   %获得点的坐标
        p2=[x(node2) y(node2) z(node2)];
        p3=[x(node3) y(node3) z(node3)];
        p4=[x(node4) y(node4) z(node4)];
        nv=cross(p2-p1,p3-p2);
        m = vrrotvec2mat(vrrotvec(nv,[0 0 1])); %m 是一个旋转矩阵 左乘向量从参数1到参数2
        src_P=[m*[p1;p2;p3;p4]']'
end