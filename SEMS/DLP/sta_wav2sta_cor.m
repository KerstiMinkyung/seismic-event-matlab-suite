function sta_wav2sta_cor

%% CROSS-CORRELATE ALL STATION WAVEFORMS

Dir = make_dir_mstr;
% 'SW' - Structure containing names of Station Waveforms
SW = dir(Dir.Sta_Wav);
SW(1:2) = []; % Get rid of '.' and '..'

FM = [];
for n = 1:numel(SW)
clc
disp(SW{n})
    try
        load([Dir.Sta_Wav,'\',SW{n},'.mat'])
        W = W(isvertical(W));
        P = get_picks(W,'p');
        W = W(find(P));
        P = P(find(P));
        clear w
        for m = 1:numel(W)
            w(m) = extract(W(m),'TIME',P(m),P(m)+10.24/24/60/60);
        end
        C = correlation(w);
        C = taper(C);
        C = butter(C,[1 10]);
        C = xcorr(C);
        save(Dir.Sta_Cor,'C')
    catch
    end
end