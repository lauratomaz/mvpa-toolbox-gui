function varargout = mvpa_gui(varargin)
% MVPA_GUI MATLAB code for mvpa_gui.fig
%      MVPA_GUI, by itself, creates a new MVPA_GUI or raises the existing
%      singleton*.
%
%      H = MVPA_GUI returns the handle to a new MVPA_GUI or the handle to
%      the existing singleton*.
%
%      MVPA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MVPA_GUI.M with the given input arguments.
%
%      MVPA_GUI('Property','Value',...) creates a new MVPA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mvpa_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mvpa_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mvpa_gui

% Last Modified by GUIDE v2.5 05-Oct-2015 17:50:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mvpa_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @mvpa_gui_OutputFcn, ...
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

% --- Executes just before mvpa_gui is made visible.
function mvpa_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mvpa_gui (see VARARGIN)

% Choose default command line output for mvpa_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mvpa_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mvpa_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%function edtSummary_Callback(hObject, eventdata, handles)
% hObject    handle to edtSummary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSummary as text
%        str2double(get(hObject,'String')) returns contents of edtSummary as a double

% --- Executes during object creation, after setting all properties.
function edtSummary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSummary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtResult_Callback(hObject, eventdata, handles)
% hObject    handle to edtResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtResult as text
%        str2double(get(hObject,'String')) returns contents of edtResult as a double

% --- Executes during object creation, after setting all properties.
function edtResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btnBrowseData.
function btnBrowseData_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
origin = pwd;
global subj;
[fileName, path] = uigetfile({'*.BRIK;*HEAD', 'Data Files(*.BRIK,*.HEAD)';'*.*', 'All Files(*.*)'}, 'Select the Data', 'MultiSelect', 'on');

fNames = [];

global maskName; 
global patName;

if(~isempty(fileName) && ~isequal(fileName, 0))
    
    set(handles.edtBrowseData, 'String', path);
    cd(path);
    
    patName = inputdlg('Enter the name of the Pattern:', 'Pattern Name', [1 50]);
    patName = patName{1};
    
    for i=1:+2:length(fileName)
        [~, fName1, ~] = fileparts(fileName{i});
        [~, fName2, ~] = fileparts(fileName{i+1});
        if(strcmp(fName1, fName2))
            fNames = [fNames; {fName1}];
        end
    end
    
    oldpointer = get(handles.figure1, 'pointer');
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    
    % computation goes here
    subj = load_afni_pattern(subj, patName, maskName, fNames);

    cd(origin);
    
    set(handles.figure1, 'pointer', oldpointer)
    FC = mySummarizeFn(subj);
    set(handles.edtSummary, 'String', FC); 
else
    set(handles.edtBrowseData, 'String', 'Files not selected!');
end;


% --- Executes on button press in btnBrowseMask.
function btnBrowseMask_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
origin=pwd;
[fileName, path] = uigetfile({'*.BRIK;*.HEAD','Mask Files (*.BRIK,*.HEAD)'; '*.*', 'All Files(*.*)'}, 'Select the Mask', 'MultiSelect', 'on');
                           
mNames = [];

global maskName; 

if(~isempty(fileName)  && ~isequal(fileName, 0))
    
    maskName = inputdlg('Enter the name of the Mask:', 'Mask Name', [1 50]);
    maskName = maskName{1};
    set(handles.edtBrowseMask, 'String', path);
    cd(path);
    
    global subj;
    
    for i=1:+2:length(fileName)
        [~, mName1, ~] = fileparts(fileName{i});
        [~, mName2, ~] = fileparts(fileName{i+1});
        if(strcmp(mName1, mName2))
            mNames = [mNames; {mName1}];
        end
    end
    
    if(length(mNames) > 1)
        h = msgbox('You selected more than one Mask!', 'Error','error', 'modal');
        set(handles.edtBrowseMask, 'String', '');
        cd(origin);
    else
        mNames = mNames{1};
        
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        drawnow;
        
        % the computation goes here
        subj = load_afni_mask(subj, maskName, mNames);

        set(handles.figure1, 'pointer', oldpointer)
        cd(origin);
        FC = mySummarizeFn(subj);
        set(handles.edtSummary, 'String', FC); 
    end
    fileName = '';
else
    set(handles.edtBrowseMask, 'String', 'No Mask Selected!');
end

% --- Executes on button press in btnBrowseCR.
function btnBrowseCR_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
origin=pwd;
[fileName, path] = uigetfile('*.mat', 'Select the Condition Regressor', 'MultiSelect', 'off');

global crName; 

if(~isempty(fileName)  && ~isequal(fileName, 0))
    
    crName = inputdlg('Enter the name of the Condition Regressor:', 'Condition Regressor Name', [1 50]);
    crName = crName{1};
    set(handles.edtBrowseCR, 'String', path);
    cd(path);
    
    global subj;
    
    [~, fName, ~] = fileparts(fileName);
    subj = init_object(subj, 'regressors', crName);
    
    x = load(fName);    
    variables = fields(x);
    
    oldpointer = get(handles.figure1, 'pointer');
    set(handles.figure1, 'pointer', 'watch')
    drawnow;

    % the computation goes here
    
    subj = set_mat(subj, 'regressors', crName, x.(variables{1}));
    cd(origin);
    
    %This is to create the cross validation indices based on blocks and not based on runs.
    subj = init_object(subj,'selector','blocks');
    blocks = runs_to_blocks(x.(variables{1}));
    subj = set_mat(subj,'selector','blocks',blocks);
    %And it will be used when the analysis starts.
    
    sConditions = get(handles.edtConditions, 'String');
    splitstring = textscan(sConditions, '%s', 'Delimiter', ',');
    splitstring = splitstring{1};
    splitstring = splitstring(~cellfun('isempty', splitstring));
    
    subj = set_objfield(subj,'regressors',crName,'condnames',splitstring);
    
    set(handles.figure1, 'pointer', oldpointer)
    
    FC = mySummarizeFn(subj);
    set(handles.edtSummary, 'String', FC); 
    fileName = '';
    set(handles.btnCreateCR,'Enable','on');
else
    set(handles.edtBrowseMask, 'String', 'No Condition Regressor Selected!');
end

% --- Executes on button press in btnCreateCR.
function btnCreateCR_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreateCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Ask the user to enter two integer numbers.
sCondReg = inputdlg({'Enter the number of Conditions for the Experiment:(integer number)', 'Enter the number of time-points'},... 
                    'Creating the Condition Regressor', [1 50; 1 40]);
if isempty(sCondReg),return,end; % Bail out if they clicked Cancel.

% Round to nearest integer in case they entered a floating point number.
integerValue1 = round(str2double(sCondReg{1}));
integerValue2 = round(str2double(sCondReg{2}));

%Check if the 1-of-n pattern matrix is the same as the entered value
%for the timepoints for the new Condition Regressor
outCheck = sanity_check(integerValue2);

if(outCheck == true)
    % Check for a valid integer.
    if (isnan(integerValue1) || isnan(integerValue2))
        % They didn't enter a number.  
        % They clicked Cancel, or entered a character, symbols, or something else not allowed.
        message = sprintf('Please enter integer values for the conditions and time-points.');
        uiwait(warndlg(message));
    else
       create_condreg(integerValue1, integerValue2); 
        set(handles.btnBrowseCR,'Enable','off');
    end
else
    message = sprintf('Please enter the same column dimension for the time-points as the pattern.');
    uiwait(warndlg(message));
end

function create_condreg(nConditions, nTimePoints)

h(nConditions) = struct('staticText', (nConditions), 'editText', (nConditions));
f = figure('Position', [500 360 450 300],...
           'Name', 'Creating Condition Regressor',...
           'WindowStyle', 'modal',...
           'Visible', 'off',...
           'Resize', 'off',...
           'NumberTitle', 'off');
       
posT.y = 260;
pos.y = 245;

matCondReg = zeros(nConditions, nTimePoints);

for i=1:nConditions
    h(i).staticText = uicontrol(f, 'Style', 'text',...
                             'String', sprintf('Condition %d is active: (eg. 10-20,30-40)', i),...
                             'Position', [25 posT.y 300 25],...
                             'HorizontalAlignment', 'left');
    h(i).editText = uicontrol(f, 'Style', 'edit',...
                              'Position', [20 pos.y 300 25]);
      pos.y = pos.y - 50;
      posT.y = posT.y - 50;
end
btnSave = uicontrol(f, 'Style', 'pushbutton',...
                       'String', 'Save',...
                       'Position', [300 pos.y-20 80 30],...
                       'Callback', {@btnSave_Callback, h, matCondReg});
f.Visible = 'on';

function btnSave_Callback(hObject, eventdata, h, matCondReg)

retData = cell(1, length(h));

for i=1:length(h)
    retData(i) = cellstr(get(h(i).editText, 'String'));
end

splitData = cell(1,length(retData));
for j=1:length(retData)
    if(j > 1)
        [splitData] = [splitData; textscan(char(retData(j)), '%s', 'Delimiter', '-,')];
    else
        [splitData] = textscan(char(retData(j)), '%s', 'Delimiter', '-,');
    end
end

for m=1:length(splitData)
    for n=1:+2:length(splitData{m})
        nStart = str2double(splitData{m}(n));
        nEnd = str2double(splitData{m}(n+1));
        while(nEnd >= nStart)
           matCondReg(m,nStart) = 1; 
           nStart = nStart + 1;
        end 
    end
end

handles=guidata(mvpa_gui);

[filename, path] = uiputfile('*.mat', 'Save Condition Regressor Matrix as');
if isequal(filename,0) || isequal(path,0), return;
else
   save([path,filename],'matCondReg'); 
   set(handles.edtCreateCR, 'String', path);
   set(handles.btnCreateCR, 'Enable', 'Off');
   set(handles.btnBrowseCR, 'Enable', 'On');
end
close(gcf);

% --- Executes on button press in btnBrowseRS.
function btnBrowseRS_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
origin=pwd;
[fileName, path] = uigetfile('*.mat', 'Select the Run Selector', 'MultiSelect', 'off');

global rsName;

if(~isempty(fileName)  && ~isequal(fileName, 0))
    
    rsName = inputdlg('Enter the name of the Run Selector:', 'Run Selector Name', [1 50]);
    rsName = rsName{1};
    set(handles.edtBrowseRS, 'String', path);
    cd(path);
    
    global subj;
    
    [~, fName, ~] = fileparts(fileName);    
    subj = init_object(subj,'selector',rsName);
    
    x = load(fName);        
    variables = fields(x);    
    
    subj = set_mat(subj, 'selector', rsName, x.(variables{1}));
    cd(origin);
    
    
    FC = mySummarizeFn(subj);
    set(handles.edtSummary, 'String', FC); 
    fileName = '';
else
    set(handles.edtBrowseMask, 'String', 'No Run Selector Selected!');
end

% --- Executes on button press in btnCreateRS.
function btnCreateRS_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreateRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Ask the user to enter two integer numbers.
sRunSel = inputdlg({'Enter the number of Runs for the Experiment:(integer number)', 'Enter the number of time-points'},... 
                    'Creating the Run Selector', [1 50; 1 40]);

if isempty(sRunSel),return,end; % Bail out if they clicked Cancel.

% Round to nearest integer in case they entered a floating point number.
integerValue1 = round(str2double(sRunSel{1}));
integerValue2 = round(str2double(sRunSel{2}));

%Check if the 1-of-n pattern matrix is the same as the entered value
%for the timepoints for the new Condition Regressor
outCheck = sanity_check(integerValue2);

if(outCheck == true)
    % Check for a valid integer.
    if (isnan(integerValue1) || isnan(integerValue2))
        % They didn't enter a number.  
        % They clicked Cancel, or entered a character, symbols, or something else not allowed.
        message = sprintf('Please enter integer values for the runs and time-points.');
        uiwait(warndlg(message));
    else
       create_runsel(integerValue1, integerValue2); 
       set(handles.btnBrowseRS,'Enable','off');
    end
else
    message = sprintf('Please enter the same dimension for the time-points as the Pattern.');
    uiwait(warndlg(message));
end


function create_runsel(nRuns, nTimePoints)

h(nRuns) = struct('staticText', (nRuns), 'editText', (nRuns));
f = figure('Position', [500 360 450 300],...
           'Name', 'Creating Run Selector',...
           'WindowStyle', 'modal',...
           'Visible', 'off',...
           'Resize', 'off',...
           'NumberTitle', 'off');

%pos.x = 20;
posT.y = 260;
pos.y = 245;
%pos.width = 300;
%pos.height = 30;

matRunSel = zeros(1, nTimePoints);

for i=1:nRuns
    h(i).staticText = uicontrol(f, 'Style', 'text',...
                             'String', sprintf('Run %d is active: (1-200)', i),...
                             'Position', [25 posT.y 300 25],...
                             'HorizontalAlignment', 'left');
    h(i).editText = uicontrol(f, 'Style', 'edit',...
                              'Position', [20 pos.y 300 25]);
      pos.y = pos.y - 50;
      posT.y = posT.y - 50;
end
btnSaveRun = uicontrol(f, 'Style', 'pushbutton',...
                       'String', 'Save',...
                       'Position', [300 pos.y-20 80 30],...
                       'Callback', {@btnSaveRun_Callback, h, matRunSel});
% f.Position = [500 360 450 figHeight];
f.Visible = 'on';

function btnSaveRun_Callback(hObject, eventdata, h, matRunSel)

L = length(h);
retData = cell(1, L);

for i=1:length(h)
    retData(i) = cellstr(get(h(i).editText, 'String'));
end

splitData = cell(1,length(retData));
for j=1:length(retData)
    if(j > 1)
        [splitData] = [splitData; textscan(char(retData(j)), '%s', 'Delimiter', '-')];
    else
        [splitData] = textscan(char(retData(j)), '%s', 'Delimiter', '-');
    end
end

for m=1:length(splitData)
    for n=1:+2:length(splitData{m})
        nStart = str2double(splitData{m}(n));
        nEnd = str2double(splitData{m}(n+1));
        while(nEnd >= nStart)
           matRunSel(1, nStart) = m; 
           nStart = nStart + 1;
        end 
    end
end

handles=guidata(mvpa_gui);

[filename, path] = uiputfile('*.mat', 'Save Run Selector Vector as');
if isequal(filename,0) || isequal(path,0), return;
else
%    disp(['User saved file as: ',fullfile(path,filename)])
   save([path,filename],'matRunSel'); 
   set(handles.edtCreateRS, 'String', path);
   set(handles.btnCreateRS, 'Enable', 'Off');
   set(handles.btnBrowseRS, 'Enable', 'On');
end
close(gcf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = sanity_check(regsSel)

% Check that the timepoints we're going to create for the 
% Run Selector and Condition Regressor have the same dimension
% as the timepoints for the pattern matrix
global patName;
global subj;

pat  = get_mat(subj,'pattern', patName);

output = true;

if size(pat,2) ~= regsSel
  message = sprintf('Wrong number of timepoints.');
  uiwait(errordlg(message, 'Error Creating Function', 'modal'));
  output = false;
end


% --- Executes on button press in btnChooseFS.
%function btnChooseFS_Callback(hObject, eventdata, handles)
% hObject    handle to btnChooseFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function edtBrowseData_Callback(hObject, eventdata, handles)
% hObject    handle to edtBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtBrowseData as text
%        str2double(get(hObject,'String')) returns contents of edtBrowseData as a double

% --- Executes during object creation, after setting all properties.
function edtBrowseData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtBrowseMask_Callback(hObject, eventdata, handles)
% hObject    handle to edtBrowseMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtBrowseMask as text
%        str2double(get(hObject,'String')) returns contents of edtBrowseMask as a double

% --- Executes during object creation, after setting all properties.
function edtBrowseMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtBrowseMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtBrowseCR_Callback(hObject, eventdata, handles)
% hObject    handle to edtBrowseCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtBrowseCR as text
%        str2double(get(hObject,'String')) returns contents of edtBrowseCR as a double

% --- Executes during object creation, after setting all properties.
function edtBrowseCR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtBrowseCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtCreateCR_Callback(hObject, eventdata, handles)
% hObject    handle to edtCreateCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtCreateCR as text
%        str2double(get(hObject,'String')) returns contents of edtCreateCR as a double

% --- Executes during object creation, after setting all properties.
function edtCreateCR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtCreateCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtBrowseRS_Callback(hObject, eventdata, handles)
% hObject    handle to edtBrowseRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtBrowseRS as text
%        str2double(get(hObject,'String')) returns contents of edtBrowseRS as a double

% --- Executes during object creation, after setting all properties.
function edtBrowseRS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtBrowseRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtCreateRS_Callback(hObject, eventdata, handles)
% hObject    handle to edtCreateRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtCreateRS as text
%        str2double(get(hObject,'String')) returns contents of edtCreateRS as a double

% --- Executes during object creation, after setting all properties.
function edtCreateRS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtCreateRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtChooseFS_Callback(hObject, eventdata, handles)
% hObject    handle to edtChooseFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtChooseFS as text
%        str2double(get(hObject,'String')) returns contents of edtChooseFS as a double

% --- Executes during object creation, after setting all properties.
function edtChooseFS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtChooseFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [result] = mySummarizeFn(subj)
    diary(fullfile(tempdir, 'mySubject.txt'))
    summarize(subj);
    diary off

    fid = fopen(fullfile(tempdir,'mySubject.txt'), 'r');
    result = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    result = result{1};
    result=result(~cellfun('isempty',result));
    delete(fullfile(tempdir, 'mySubject.txt'));

%function edtNameSubj_Callback(hObject, eventdata, handles)
% hObject    handle to edtNameSubj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtNameSubj as text
%        str2double(get(hObject,'String')) returns contents of edtNameSubj as a double

% --- Executes during object creation, after setting all properties.
function edtNameSubj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtNameSubj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%function edtConditions_Callback(hObject, eventdata, handles)
% hObject    handle to edtConditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtConditions as text
%        str2double(get(hObject,'String')) returns contents of edtConditions as a double

% --- Executes during object creation, after setting all properties.
function edtConditions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtConditions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btnCreateSubj.
function btnCreateSubj_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreateSubj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sSubj = get(handles.edtNameSubj, 'String');
sConditions = get(handles.edtConditions, 'String');
sExperiment = get(handles.edtExperiment, 'String');
global subj;
if(~isempty(sSubj) || ~isempty(sConditions) || ~isempty(sExperiment))
    subj = init_subj(sExperiment, sSubj);
    result = mySummarizeFn(subj);
    set(handles.edtSummary, 'String', result);
else
    message = sprintf('Please name the Subject, Conditions and Experiment.');
    uiwait(warndlg(message));
end

%function edtExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to edtExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtExperiment as text
%        str2double(get(hObject,'String')) returns contents of edtExperiment as a double

% --- Executes during object creation, after setting all properties.
function edtExperiment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btnBrowseData.
%function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to btnBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edtBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtBrowseData as text
%        str2double(get(hObject,'String')) returns contents of edtBrowseData as a double

% --- Executes during object creation, after setting all properties.
%function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtBrowseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear;

% --- Executes on selection change in mFeatureSelection.
%function mFeatureSelection_Callback(hObject, eventdata, handles)
% hObject    handle to mFeatureSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mFeatureSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mFeatureSelection

% --- Executes during object creation, after setting all properties.
function mFeatureSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mFeatureSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nFeature = get(handles.mFeatureSelection, 'Value');

global rsName;
global patName;
global crName;
global subj;

oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch')
drawnow;

% the computation goes here

% PRE-PROCESSING - z-scoring in time and no-peeking anova
% we want to z-score the EPI data (called patName),
% individually on each run (using the 'runs' selectors)
subj = zscore_runs(subj,patName,rsName);

% now, create selector indices for the n different iterations of
% the nminusone
subj = create_xvalid_indices(subj,rsName);
% substituing the runs by the new vector created after the run selector
%subj = create_xvalid_indices(subj,'blocks');

switch nFeature
    case 1
% run the anova multiple times, separately for each iteration,
% using the selector indices created above
         [subj] = feature_select(subj,sprintf('%s_z',patName),crName,sprintf('%s_xval', rsName));
        %[subj] = feature_select(subj,sprintf('%s_z',patName),crName,'blocks_xval');
    case 2
        [subj] = feature_select_kruskalwallis(subj,sprintf('%s_z',patName),crName,sprintf('%s_xval', rsName));
        %[subj] = feature_select_kruskalwallis(subj,sprintf('%s_z',patName),crName,'blocks_xval');
    otherwise
     h = msgbox('Please, select a valid option!','Warning', 'warn');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASSIFICATION - n-minus-one cross-validation

% set some basic arguments for a backprop classifier
class_args.train_funct_name = 'train_bp';
class_args.test_funct_name = 'test_bp';
class_args.nHidden = 0;

% now, run the classification multiple times, training and testing
% on different subsets of the data on each iteration
[subj results] = cross_validation(subj,sprintf('%s_z',patName),crName,sprintf('%s_xval', rsName),sprintf('%s_z_thresh0.05',patName),class_args);
%[subj results] = cross_validation(subj,sprintf('%s_z',patName),crName,'blocks_xval',sprintf('%s_z_thresh0.05',patName),class_args);

set(handles.figure1, 'pointer', oldpointer)

result = mySummarizeFn(subj);
res = results.total_perf;
set(handles.edtResult, 'String', sprintf('Results of the total perfomance = %.5f', res));
set(handles.edtSummary, 'String', result); 
subj = remove_object(subj, 'pattern', sprintf('%s_z',patName));
subj = remove_group(subj, 'mask', sprintf('%s_z_thresh0.05',patName));
subj = remove_group(subj, 'selector', sprintf('%s_xval',rsName));
%subj = remove_group(subj, 'selector', 'blocks_xval');
switch nFeature
    case 1
       subj = remove_group(subj, 'pattern', sprintf('%s_z_anova',patName)); 
    case 2
       subj = remove_group(subj, 'pattern', sprintf('%s_z_kruskalwallis',patName));
end
