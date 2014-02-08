function plot_mcvco_voltages(S,varargin)

M = [];
for n = 1:nargin-1
    v = varargin{n};
    if ischar(v);
        switch lower(v)
            case 'akutan'
                M.Akutan = S.Akutan;
            case 'aniakchak'
                M.Aniakchak = S.Aniakchak;
            case 'augustine'
                M.Augustine = S.Augustine;
            case 'dutton'
                M.Dutton = S.Dutton;
            case 'fourpeaked'
                M.Fourpeaked = S.Fourpeaked;
            case 'gareloi'
                M.Gareloi = S.Gareloi;
            case 'greatsitkin'
                M.GreatSitkin = S.GreatSitkin;
            case 'iliamna'
                M.Iliamna = S.Iliamna;
            case 'kanaga'
                M.Kanaga = S.Kanaga;
            case 'katmai'
                M.Katmai = S.Katmai;
            case 'korovin'
                M.Korovin = S.Korovin;
            case 'littlesitkin'
                M.LittleSitkin = S.LittleSitkin;
            case 'makushin'
                M.Makushin = S.Makushin;
            case 'okmok'
                M.Okmok = S.Okmok;
            case 'pavlof'
                M.Pavlof = S.Pavlof;
            case 'peulik'
                M.Peulik = S.Peulik;
            case 'redoubt'
                M.Redoubt = S.Redoubt;
            case 'regional'
                M.Regional = S.Regional;
            case 'semisopochnoi'
                M.Semisopochnoi = S.Semisopochnoi;
            case 'shishaldin'
                M.Shishaldin = S.Shishaldin;
            case 'spurr'
                M.Spurr = S.Spurr;
            case 'tanaga'
                M.Tanaga = S.Tanaga;
            case 'veniaminof'
                M.Veniaminof = S.Veniaminof;
            case 'westdahl'
                M.Westdahl = S.Westdahl;
            case 'wrangell'
                M.Wrangell = S.Wrangell;
        end
    elseif is_sst(v)
        t_rng = v;
    end
end
if isempty(M)
    M = S;
    clear S
end
M = check_id_gain(M);

subnets = fieldnames(M);
C = 0;
figure, hold on
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            t = M.(SU).(ST).(CH).start;
            b = M.(SU).(ST).(CH).bvl;
            C = C + 1;
            stalab{C} = [ST,':',CH];
            try
                if C == 1
                    colorscat(t,t*0-C,t*0+20,b,'range',[5,15],'cbar',1,'cbardir','reverse')
                else
                    colorscat(t,t*0-C,t*0+20,b,'range',[5,15],'cbar',0)
                end
            catch
            end
        end
    end
end

ylim([-C-1 0])
set(gca,'YTick',[-C:-1])
set(gca,'YTickLabel',stalab(end:-1:1))

dynamicDateTicks
grid on