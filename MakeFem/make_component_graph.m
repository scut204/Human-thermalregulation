function C=make_component_graph(lines)
    C=zeros(size(lines,1));
    C(sub2ind(size(C),lines(:,1),lines(:,2)))=1;
    C=C+C';
end