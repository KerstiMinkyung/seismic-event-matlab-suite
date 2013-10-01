function varargout = sems_config(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sems_config_OpeningFcn, ...
                   'gui_OutputFcn',  @sems_config_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% --- Executes just before sems_config is made visible.
function sems_config_OpeningFcn(hObject, eventdata, handles, varargin)

setappdata(0,'sems_config_fig',handles.sems_config_fig)
handles.config.name = 'New_Project';
set(handles.name_field,'String',handles.config.name)
handles.config.scnl = scnlobject;
set(handles.scnl_field,'String','No SNCL Selected')
handles.config.root_dir= [];
set(handles.root_dir_field,'String','No Root Directory Selected')
handles.config.config_path= [];
set(handles.config_path_field,'String','No Config Path Selected')
handles.config.log_path = [];
set(handles.log_path_field,'String','No Log Path Selected')
handles.config.ds = [];
set(handles.ds_field,'String','No Data Source Selected')
handles.config.start = floor(now-30);
set(handles.start_field,'String',datestr(handles.config.start))
handles.config.end = ceil(now);
set(handles.end_field,'String',datestr(handles.config.end))
handles.config.dur = handles.config.end - handles.config.start + 1;
handles.config.day = (handles.config.start : handles.config.end)';

%% DEFAULT EVENT DETECTION PARAMETERS
handles.config.edp.bp_low = 0.5;
handles.config.edp.bp_hi = 10;
handles.config.edp.hilb = 0;
handles.config.edp.l_sta = 1;
handles.config.edp.l_lta = 8;
handles.config.edp.th_on = 2.5;
handles.config.edp.th_off = 1.8;
handles.config.edp.min_sep = 3;
handles.config.edp.min_len = 2;
handles.config.edp.lta_mod = 'continuous';
handles.config.edp.fix = 8;
handles.config.edp.pad = [2,0];
set(handles.ed_field,'String','Default Event Detection Parameters');

%% DEFAULT EVENT METRIC PARAMETERS
handles.config.metric.pa = 1;
handles.config.metric.p2p = 1;
handles.config.metric.rms = 1;
handles.config.metric.rms_win = 4;
handles.config.metric.snr = 1;
handles.config.metric.sm_win = 5.12;
handles.config.metric.sm_nfft = 1024;
handles.config.metric.sm_smo = 4;
handles.config.metric.sm_tap = .02;
handles.config.metric.pf = 1;
handles.config.metric.fi = 1;
handles.config.metric.fi_lo = [1 2];
handles.config.metric.fi_hi = [10 20];
handles.config.metric.iet = 1;
handles.config.metric.erp = 1;
handles.config.metric.erp_win = 60*60;
set(handles.em_field,'String','Default Event Metrics');

%% DEFAULT FAMILY DETECTION PARAMETERS
handles.config.family.cc = .75;
handles.config.family.cc_win = 8;
handles.config.family.cc_size = 1000;
handles.config.family.min = 2;
set(handles.fd_field,'String','Default Family Detection Settings');

%%
handles.output = [];
guidata(hObject, handles);

%% CHANGE ICON TO SEMS ICON
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.sems_config_fig,'javaframe');
jIcon=javax.swing.ImageIcon('C:\Work\SEMS\GUIs\sems_icon.gif');
jframe.setFigureIcon(jIcon);

%% UIWAIT makes sems_config wait for user response (see UIRESUME)
uiwait(handles.sems_config_fig);

%%
function sems_config_fig_CreateFcn(hObject, eventdata, handles)

%% MENU: FILE>>LOAD
function Menu_File_Callback(hObject, eventdata, handles)

function Menu_Load_Config_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
tmp_dir = cd;
try
   cd(handles.config.root_dir)
catch
end
[filename, pathname] = uigetfile('*.mat','Load Config');
if isnumeric(pathname)
elseif isdir(pathname)
newfilename = fullfile(pathname, filename);
load(newfilename);
end
if exist('config') == 1
handles.config = config;
set(handles.name_field,'String',handles.config.name)
set(handles.root_dir_field,'String',handles.config.root_dir)
set(handles.config_path_field,'String',handles.config.config_path)
set(handles.log_path_field,'String',handles.config.log_path)
set(handles.ds_field,'String',['TYPE: ',get(handles.config.ds,'type'),...
                         ' SERVER: ',get(handles.config.ds,'server'),...
                         ' PORT: ',num2str(get(handles.config.ds,'port'))])
set(handles.scnl_field,'String',scnl2str(handles.config.scnl))
set(handles.start_field,'String',datestr(handles.config.start))
set(handles.end_field,'String',datestr(handles.config.end))
handles.config.dur = handles.config.end - handles.config.start + 1;
handles.config.day = (handles.config.start : handles.config.end)';
set(handles.ed_field,'String','User-Defined Event Detection Parameters')
set(handles.em_field,'String','User-Defined Event Metrics')
set(handles.fd_field,'String','User-Defined Family Detection Settings')
end

cd(tmp_dir)
guidata(gcf, handles);

%% MENU: FILE>>SAVE
function Menu_Save_Config_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
tmp_dir = cd;
config = handles.config;
try
   cd(config.root_dir)
catch
end
defaultname = [config.name,'_config'];
[filename, pathname] = uiputfile('*.mat','Save Config As',defaultname);
if isnumeric(pathname)
elseif isdir(pathname)
newfilename = fullfile(pathname, filename);
save(newfilename, 'config');
end
cd(tmp_dir)

%% PROJECT NAME (handles.config.name)
function name_lab_CreateFcn(hObject, eventdata, handles)

function name_field_CreateFcn(hObject, eventdata, handles)

function name_push_CreateFcn(hObject, eventdata, handles)

function name_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.name_field,'Enable','on');
elseif button_state == get(hObject,'Min')
	set(handles.name_field,'Enable','off');
   handles.config.name = get(handles.name_field,'String');
   if ~isempty(handles.config.root_dir) && ~isempty(handles.config.name)
      handles.config.config_path = fullfile(handles.config.root_dir,...
                                          [handles.config.name,'_config']);
      set(handles.config_path_field,'String',handles.config.config_path);                                 
      handles.config.log_path = fullfile(handles.config.root_dir,...
                                          [handles.config.name,'_log']); 
      set(handles.log_path_field,'String',handles.config.log_path);                                 
   end
end
guidata(gcf, handles);

%% PROJECT ROOT DIRECTORY (handles.config.root_dir)
function root_dir_lab_CreateFcn(hObject, eventdata, handles)

function root_dir_field_CreateFcn(hObject, eventdata, handles)

function root_dir_push_CreateFcn(hObject, eventdata, handles)

function root_dir_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
tmp = uigetdir('C:\','Event Detection Root Directory');
if tmp ~= 0
   handles.config.root_dir= tmp;
   set(handles.root_dir_field,'String',tmp);
   name = handles.config.name;
   if ~isempty(handles.config.root_dir) && ~isempty(handles.config.name)
      handles.config.config_path = fullfile(handles.config.root_dir,...
                                          [handles.config.name,'_config']);
      set(handles.config_path_field,'String',handles.config.config_path);                                 
      handles.config.log_path = fullfile(handles.config.root_dir,...
                                          [handles.config.name,'_log']); 
      set(handles.log_path_field,'String',handles.config.log_path);                                 
   end
end
guidata(gcf, handles);

%% PROJECT CONFIG PATH (handles.config.config_path)
function config_path_field_Callback(hObject, eventdata, handles)

function config_path_field_CreateFcn(hObject, eventdata, handles)

function config_path_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.config_path_field,'Enable','on');
elseif button_state == get(hObject,'Min')
	set(handles.config_path_field,'Enable','off');
   handles.config.config_path = get(handles.config_path_field,'String');
end
guidata(gcf, handles);

%% PROJECT LOG PATH (handles.config.log_path)
function log_path_field_Callback(hObject, eventdata, handles)

function log_path_field_CreateFcn(hObject, eventdata, handles)

function log_path_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
	set(handles.log_path_field,'Enable','on');
elseif button_state == get(hObject,'Min')
	set(handles.log_path_field,'Enable','off');
   handles.config.log_path = get(handles.log_path_field,'String');
end
guidata(gcf, handles);

%% DATA SOURCE (handles.config.ds)
function ds_lab_CreateFcn(hObject, eventdata, handles)

function ds_field_CreateFcn(hObject, eventdata, handles)

function ds_push_CreateFcn(hObject, eventdata, handles)

function ds_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
[ds scnl] = ds_scnl;
handles.config.ds = ds;
set(handles.ds_field,'String',['TYPE: ',get(ds,'type'),...
                         ' SERVER: ',get(ds,'server'),...
                         ' PORT: ',num2str(get(ds,'port'))])
guidata(gcf, handles);

%% SCNL (handles.config.scnl)
function scnl_lab_CreateFcn(hObject, eventdata, handles)

function scnl_field_CreateFcn(hObject, eventdata, handles)

function scnl_push_CreateFcn(hObject, eventdata, handles)

function scnl_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
[ds scnl] = ds_scnl;
if ~isempty(scnl)
handles.config.scnl = scnl;
set(handles.scnl_field,'String',scnl2str(scnl))
end
guidata(gcf, handles);

%% START TIME (handles.config.start)
function start_lab_CreateFcn(hObject, eventdata, handles)

function start_field_CreateFcn(hObject, eventdata, handles)

function start_push_CreateFcn(hObject, eventdata, handles)

function start_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
button_state = get(handles.start_push,'Value');
if button_state == get(handles.start_push,'Max')
   dv = datevec(handles.config.start);
   dvs = num2str(dv(1),'%04.0f');
   for n = 2:6
      dvs = [dvs,' ',num2str(dv(n),'%02.0f')];
   end
   set(handles.start_field,'String',dvs)
	set(handles.start_field,'Enable','on');
elseif button_state == get(handles.start_push,'Min')
	set(handles.start_field,'Enable','off');
   dvs = get(handles.start_field,'String');
   ind = strfind(dvs,' ');
   try
      dv(1) = str2num(dvs(1:ind(1)));
      for n = 2:5
         dv(n) = str2num(dvs(ind(n-1):ind(n)));
      end
      dv(6) = str2num(dvs(ind(5):end));
      set(handles.start_field,'String',datestr(dv))
      handles.config.start = datenum(dv);
   catch
      set(handles.start_field,'String',datestr(handles.start))
   end
   try
      handles.config.day = handles.config.start:handles.config.end;
      handles.config.dur = handles.config.end-handles.config.start+1;
   catch
   end
end
guidata(gcf, handles);

%% END TIME (handles.config.end)
function end_lab_CreateFcn(hObject, eventdata, handles)

function end_field_CreateFcn(hObject, eventdata, handles)

function end_push_CreateFcn(hObject, eventdata, handles)

function end_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
button_state = get(handles.end_push,'Value');
if button_state == get(handles.end_push,'Max')
   dv = datevec(handles.config.end);
   dvs = num2str(dv(1),'%04.0f');
   for n = 2:6
      dvs = [dvs,' ',num2str(dv(n),'%02.0f')];
   end
   set(handles.end_field,'String',dvs)
	set(handles.end_field,'Enable','on');
elseif button_state == get(handles.end_push,'Min')
	set(handles.end_field,'Enable','off');
   dvs = get(handles.end_field,'String');
   ind = strfind(dvs,' ');
   try
      dv(1) = str2num(dvs(1:ind(1)));
      for n = 2:5
         dv(n) = str2num(dvs(ind(n-1):ind(n)));
      end
      dv(6) = str2num(dvs(ind(5):end));
      set(handles.end_field,'String',datestr(dv))
      handles.config.end = datenum(dv);
   catch
      set(handles.end_field,'String',datestr(handles.end))
   end
   try
      handles.config.day = handles.config.start:handles.config.end;
      handles.config.dur = handles.config.end-handles.config.start+1;
   catch
   end
end
guidata(gcf, handles);

%% EVENT DETECTION (handles.config.edp)
function ed_lab_CreateFcn(hObject, eventdata, handles)

function ed_field_CreateFcn(hObject, eventdata, handles)

function ed_push_CreateFcn(hObject, eventdata, handles)

function ed_push_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
setappdata(0,'edp',handles.config.edp);
h = sta_lta_config;
waitfor(h);
handles.config.edp = getappdata(0,'edp');
set(handles.ed_field,'String','User-Defined Event Detection Parameters');
guidata(gcf, handles);

%% EVENT METRICS (handles.config.metric)
function em_lab_CreateFcn(hObject, eventdata, handles)

function em_field_CreateFcn(hObject, eventdata, handles)

function em_push_CreateFcn(hObject, eventdata, handles)

function em_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
setappdata(0,'metric',handles.config.metric);
h = metric_config;
waitfor(h);
handles.config.metric = getappdata(0,'metric');
set(handles.em_field,'String','User-Defined Event Metrics');
guidata(gcf, handles);

%% FAMILY DETECTION (handles.config.family)
function fd_lab_CreateFcn(hObject, eventdata, handles)

function fd_field_CreateFcn(hObject, eventdata, handles)

function fd_push_CreateFcn(hObject, eventdata, handles)

function fd_push_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
setappdata(0,'family',handles.config.family);
h = family_config;
waitfor(h);
handles.config.family = getappdata(0,'family');
set(handles.fd_field,'String','User-Defined Family Detection Settings');
guidata(gcf, handles);

%% OK/CANCEL PUSH BUTTONs
function ok_but_Callback(hObject, eventdata, handles)
h = getappdata(0,'sems_config_fig');
handles = guidata(h);
setappdata(0,'config',handles.config);
uiresume(h)
delete(h)

function can_but_Callback(hObject, eventdata, handles)
h = getappdata(0,'sems_config_fig');
handles = guidata(h);
uiresume(h)
delete(h)

%% Executes when user attempts to close sems_config_fig.
function sems_config_fig_CloseRequestFcn(hObject, eventdata, handles)
h = getappdata(0,'sems_config_fig');
handles = guidata(h);
if isequal(get(h, 'waitstatus'), 'waiting')
   uiresume(h);
else
   delete(h);
end

%% Outputs from this function are returned to the command line.
function varargout = sems_config_OutputFcn(hObject, eventdata, handles) 
varargout{1} = [];


