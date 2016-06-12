function varargout = mvpa_gui_feature_selection(varargin)
% MVPA_GUI_FEATURE_SELECTION MATLAB code for mvpa_gui_feature_selection.fig
%      MVPA_GUI_FEATURE_SELECTION, by itself, creates a new MVPA_GUI_FEATURE_SELECTION or raises the existing
%      singleton*.
%
%      H = MVPA_GUI_FEATURE_SELECTION returns the handle to a new MVPA_GUI_FEATURE_SELECTION or the handle to
%      the existing singleton*.
%
%      MVPA_GUI_FEATURE_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MVPA_GUI_FEATURE_SELECTION.M with the given input arguments.
%
%      MVPA_GUI_FEATURE_SELECTION('Property','Value',...) creates a new MVPA_GUI_FEATURE_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mvpa_gui_feature_selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mvpa_gui_feature_selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mvpa_gui_feature_selection

% Last Modified by GUIDE v2.5 24-Sep-2015 10:37:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mvpa_gui_feature_selection_OpeningFcn, ...
                   'gui_OutputFcn',  @mvpa_gui_feature_selection_OutputFcn, ...
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


% --- Executes just before mvpa_gui_feature_selection is made visible.
function mvpa_gui_feature_selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mvpa_gui_feature_selection (see VARARGIN)

% Choose default command line output for mvpa_gui_feature_selection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mvpa_gui_feature_selection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mvpa_gui_feature_selection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rbtnAnova.
function rbtnAnova_Callback(hObject, eventdata, handles)
% hObject    handle to rbtnAnova (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtnAnova


% --- Executes on button press in btnSend.
function btnSend_Callback(hObject, eventdata, handles)
% hObject    handle to btnSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
