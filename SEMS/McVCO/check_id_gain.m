function M = check_id_gain(M)

subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            X = M.(SU).(ST).(CH);
            if ~isempty(X.start)
                cut_id = find(X.id ~= X.real_id);
                cut_gain = find(X.gain ~= X.real_gain);
                cut = unique([cut_id; cut_gain]);
                X.bvl(cut) = [];
                X.id(cut) = [];
                X.gain(cut) = [];
                X.start(cut) = [];
                M.(SU).(ST).(CH) = X;
            end
        end
    end
end
