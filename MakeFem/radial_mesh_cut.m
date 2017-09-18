function [v_phi,v1c]=radial_mesh_cut(v,lines,label,n,con)
lines1=lines(label(lines(:,1))==con,:);    %
v1=v(label==con,:);   %y=0.3
v1c=mean(v1);

num_phi=n;
phi=2*pi/num_phi:2*pi/num_phi:2*pi;
v_phi=[];
for i=1:length(phi)
    cp=cos(phi(i));
    sp=sin(phi(i));
    Rot_P=[cp 0 -sp;
           0  1   0;
           sp 0  cp];
    RotP= [cp 0  sp;0 1 0;-sp 0 cp];
    v_rel=v-repmat(v1c,size(v,1),1);
    v_rot=v_rel*Rot_P;
    for j=1:size(lines1,1)
        stp=v_rot(lines1(j,1),:);
        fnp=v_rot(lines1(j,2),:);
        if(stp(3)*fnp(3)<0) % signs are different
            lambda=0-fnp(3)/(stp(3)-fnp(3));
            x=lambda*(stp(1)-fnp(1))+fnp(1);
            if(x>0)
                int_v=[x stp(2) 0];
            end
        end
    end
    int_v=int_v*RotP+v1c;
    v_phi=[v_phi;int_v];
end