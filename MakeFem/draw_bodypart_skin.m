function draw_bodypart_skin(bodypart,col)
if nargin<2
    col='r';
end
    v_phi=bodypart.v_phi;
    flrs=size(v_phi,3);
    nsmp=size(v_phi,1);
    for i=1:(flrs-1)
        for j=1:nsmp
            n=mod(1:31,30)+1;
            X=[v_phi(n(j),1,i) v_phi(n(j+1),1,i) v_phi(n(j+1),1,i+1) v_phi(n(j),1,i+1) v_phi(n(j),1,i)];
            Y=[v_phi(n(j),2,i) v_phi(n(j+1),2,i) v_phi(n(j+1),2,i+1) v_phi(n(j),2,i+1) v_phi(n(j),2,i)];
            Z=[v_phi(n(j),3,i) v_phi(n(j+1),3,i) v_phi(n(j+1),3,i+1) v_phi(n(j),3,i+1) v_phi(n(j),3,i)];
            plot3(X,Y,Z,col);
            if ~ishold
                hold on;
            end
            
        end
    end
end
        