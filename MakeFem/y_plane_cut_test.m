function points=y_plane_cut_test(vertex,faces,p,y)
% Due to the cell mechanism, the function need to be more robust
% by tianyi,8/13
% vertex is a matrix of 3*m, so as fn matrix illustrated below.
% faces is a cell array consists of f3 f4 ... fn matrix.  fn means n-vertex
%       face.
% y is the threshold of meshcut value.
% p is the input/output(previous) points matrix


points=p;
persistent num;
if isempty(num)
    num=1;
end
    for i=1:size(faces,2)
        v=[vertex(:,faces(:,i)) vertex(:,faces(1,i))];
        np=0;
        for j=1:size(faces,1)
            lamda=( y-v(2,j) )/( v(2,j+1)-v(2,j) );
            if(lamda<1 && lamda >0)
                np=np+1;
                points(:,np,num)=lamda*(v(:,j+1)-v(:,j))+v(:,j);
            end
            
        end
        if(np>0)
            num=num+1;
        end
    end
end