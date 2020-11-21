function varargout = experiment_GUI(varargin)
% EXPERIMENT_GUI MATLAB code for experiment_GUI.fig
%      EXPERIMENT_GUI, by itself, creates a new EXPERIMENT_GUI or raises the existing
%      singleton*.
%
%      H = EXPERIMENT_GUI returns the handle to a new EXPERIMENT_GUI or the handle to
%      the existing singleton*.
%
%      EXPERIMENT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMENT_GUI.M with the given input arguments.
%
%      EXPERIMENT_GUI('Property','Value',...) creates a new EXPERIMENT_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experiment_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experiment_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experiment_GUI

% Last Modified by GUIDE v2.5 21-Nov-2020 15:01:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experiment_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @experiment_GUI_OutputFcn, ...
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

% --- Executes just before experiment_GUI is made visible.
function experiment_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experiment_GUI (see VARARGIN)

% Choose default command line output for experiment_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes experiment_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = experiment_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function studentID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studentID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function studentID_Callback(hObject, eventdata, handles)
% hObject    handle to studentID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of studentID as text
%        str2double(get(hObject,'String')) returns contents of studentID as a double
studentID = str2double(get(hObject, 'String'));
if isnan(studentID)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new studentID value
handles.metricdata.studentID = studentID;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function percentage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percentage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function percentage_Callback(hObject, eventdata, handles)
% hObject    handle to percentage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of percentage as text
%        str2double(get(hObject,'String')) returns contents of percentage as a double
percentage = str2double(get(hObject, 'String'));
if isnan(percentage)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new percentage value
handles.metricdata.percentage = percentage;
guidata(hObject,handles)

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trials = handles.metricdata.studentID * handles.metricdata.percentage;
set(handles.trials, 'String', trials);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.studentID = 0;
handles.metricdata.percentage  = 0;

set(handles.studentID, 'String', handles.metricdata.studentID);
set(handles.percentage,  'String', handles.metricdata.percentage);
set(handles.trials, 'String', 0);

set(handles.unitgroup, 'SelectedObject', handles.english);

set(handles.text4, 'String', 'lb/cu.in');
set(handles.text5, 'String', 'cu.in');
set(handles.text6, 'String', 'lb');

% Update handles structure
guidata(handles.figure1, handles);



% function percentage_Callback(hObject, eventdata, handles)
% % hObject    handle to percentage (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of percentage as text
% %        str2double(get(hObject,'String')) returns contents of percentage as a double


% --- Executes during object creation, after setting all properties.
function percentage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percentage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function studentID_Callback(hObject, eventdata, handles)
% hObject    handle to studentID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of studentID as text
%        str2double(get(hObject,'String')) returns contents of studentID as a double


% --- Executes during object creation, after setting all properties.
function studentID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to studentID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trials_Callback(hObject, eventdata, handles)
% hObject    handle to trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trials as text
%        str2double(get(hObject,'String')) returns contents of trials as a double


% --- Executes during object creation, after setting all properties.
function trials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
