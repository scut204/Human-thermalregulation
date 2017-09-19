function plot_divided_vl(vertex,lines,labels)
    num_con=max(labels);
    v=vertex;
    for i=1:num_con
        color=rand(1,3);
        for j=1:size(lines,1)
            if((labels(lines(j,1))==i)||(labels(lines(j,2))==i))
                XX=[v(lines(j,1),1) v(lines(j,2),1)];
                YY=[v(lines(j,1),2) v(lines(j,2),2)];
                ZZ=[v(lines(j,1),3) v(lines(j,2),3)];
                plot3(XX,YY,ZZ,'Color',color);hold on;
            end
        end
    end
end
        