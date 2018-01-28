x=rand(1,3);
% x=x(end:-1:1);
y=rand(1,3);
% y=y(end:-1:1);
z=rand(1,3);
close all;
figure(1);hold on; view(3)
line([x x(1)],[y y(1)],[z z(1)]);
s=1:3;
s=num2str(s');
text(x,y,z,s);
nv=norm_vector([x' y' z']);
dot(nv,nv)
nv=repmat(nv',1,3);
quiver3(x,y,z,nv(1,:),nv(2,:),nv(3,:),'k'); 
% C=[x' y'];
% ngp=2;
%  [w,gp]   = gauss(ngp);
%  for m=1:ngp
%      for j=1:ngp
%             psi   = gp(j);
%             eta   = gp(m);
%             [~,J]=BmatHeat2D(eta,psi,C)
%      end
%  end
 
 function nv=norm_vector(C)
    m1=C(2,:)-C(3,:);
    m2=C(2,:)-C(1,:);
    avec=cross(m1,m2);
    nv=avec/dot(avec,avec,2).^(1/2);
    disp('is vertical')
    dot(m1,nv)
end