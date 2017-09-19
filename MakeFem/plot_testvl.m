function plot_testvl(v,lines,clo)
    if nargin==2
       for i=1:size(lines,1)
        XX=[v(lines(i,1),1) v(lines(i,2),1)];
        YY=[v(lines(i,1),2) v(lines(i,2),2)];
        ZZ=[v(lines(i,1),3) v(lines(i,2),3)];
        plot3(XX,YY,ZZ);hold on;
       end
    else
        for i=1:size(lines,1)
          XX=[v(lines(i,1),1) v(lines(i,2),1)];
          YY=[v(lines(i,1),2) v(lines(i,2),2)];
          ZZ=[v(lines(i,1),3) v(lines(i,2),3)];
          plot3(XX,YY,ZZ,clo);hold on;
        end
    end
end