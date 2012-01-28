function [w] = zero_gaps(w)

v=get(w,'data');

for n=1:length(v)
    if v(n)<-1e9           %Gap points are very large and negative
        v(n)=0;
    end
end

w=set(w,'data',v);

