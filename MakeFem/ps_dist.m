function ps_dist=ps_dist(v)
     len=size(v,1);
     vp2=sum(v.^2,2);
     v1=repmat(vp2,1,len);
     v2=repmat(vp2',len,1);
     ps_dist=v1+v2-2*(v*v');
end