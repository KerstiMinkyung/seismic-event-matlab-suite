function EM = extract_families(EM, CM)

EM.fam_id = zeros(size(EM.evid));
%% Define familiy criteria
CMX = CM.cc075cnt;


k = 1;
done = 0;
while ~done
    [V, R] = max(sum(CMX));
    rr = find(CMX(:,R)>.75);
    if numel(rr)<2
        done = 1;
    else
        CMX(:, rr) = [];
        CMX(rr, :) = [];
        EM.fam_id(rr) = k;
        k = k+1;
    end
end