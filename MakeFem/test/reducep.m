figure
[x,y,z,v] = flow;
p = patch(isosurface(x,y,z,v,-3));
p.FaceColor = 'w';
p.EdgeColor = 'b';
daspect([1,1,1])
view(3)

reducepatch(p,0.15)
