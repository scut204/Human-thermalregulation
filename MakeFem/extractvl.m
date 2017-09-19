
function [v,lines]=extractvl(a)
    if ~ismatrix(a)
        error(message('MATLAB:UNIQUE:ANotAMatrix'));
    end
    
    numRows = size(a,1);
%     numCols = size(a,2);
    
    % Sort A and get the indices if needed.

        [sortA,indSortA] = sortrows(a);

    
    % groupsSortA indicates the location of non-matching entries.
    bound =1e-6;
    groupsSortA = sum((sortA(1:numRows-1,:) - sortA(2:numRows,:)).^2,2)>bound;    %这里可以好好学习这个思想
     groupsSortA = [true; groupsSortA];          % First row is always a member of unique list.
    
    % Extract Unique elements.
    sort_switch=true;
    if ~sort_switch
        invIndSortA = indSortA;
        invIndSortA(invIndSortA) = 1:numRows;               % Find the inverse permutation of indSortA.
        logIndA = groupsSortA(invIndSortA);                 % Create new logical by indexing into groupsSortA.
        v = a(logIndA,:);                                   % Create unique list by indexing into unsorted a.
    else
        v = sortA(groupsSortA,:);         % Create unique list by indexing into sorted list.
    end
    
    % Find indA.
%      indA = find(logIndA);           % Find the indices of the unsorted logical.
     indC = cumsum(groupsSortA); 
     lines(indSortA) = indC;                              % Re-reference indC to indexing of sortA.
     lines=reshape(lines,2,length(lines)/2);
     lines=lines';
end

% function ynvec=issame(gp1,gp2)
%     bound=1e-5;
%     if norm(p1-p2)<bound
%         yn=true;
%     else
%         yn=false;
%     end
% end