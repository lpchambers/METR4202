function varargout = CirclDetect(varargin)
% CIRCLDETECT M-file for CirclDetect.fig
%      CIRCLDETECT, by itself, creates a new CIRCLDETECT or raises the existing
%      singleton*.
%
%      H = CIRCLDETECT returns the handle to a new CIRCLDETECT or the handle to
%      the existing singleton*.
%
%      CIRCLDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIRCLDETECT.M with the given input arguments.
%
%      CIRCLDETECT('Property','Value',...) creates a new CIRCLDETECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CirclDetect_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CirclDetect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help CirclDetect

% Last Modified by GUIDE v2.5 10-Jun-2007 22:17:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CirclDetect_OpeningFcn, ...
                   'gui_OutputFcn',  @CirclDetect_OutputFcn, ...
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


% --- Executes just before CirclDetect is made visible.
function CirclDetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CirclDetect (see VARARGIN)

% Choose default command line output for CirclDetect
Image = repmat(logical(uint8(0)),200,200);
handles.Image = Image;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CirclDetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CirclDetect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function CentX_Callback(hObject, eventdata, handles)
% hObject    handle to CentX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentX as text
%        str2double(get(hObject,'String')) returns contents of CentX as a double


% --- Executes during object creation, after setting all properties.
function CentX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function CentY_Callback(hObject, eventdata, handles)
% hObject    handle to CentY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentY as text
%        str2double(get(hObject,'String')) returns contents of CentY as a double

% --- Executes during object creation, after setting all properties.
function CentY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on slider movement.
function RadSet_Callback(hObject, eventdata, handles)
% hObject    handle to RadSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.textR,'string',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function RadSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RadSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C = OElocate(handles.Image,[handles.setX;handles.setY]);
set(handles.RadDet,'String',C(3));

% --- Executes on button press in pushbutton1.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


function RadDet_Callback(hObject, eventdata, handles)
% hObject    handle to RadDet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RadDet as text
%        str2double(get(hObject,'String')) returns contents of RadDet as a double


% --- Executes during object creation, after setting all properties.
function RadDet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RadDet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in pbSet.
function pbSet_Callback(hObject, eventdata, handles)
% hObject    handle to pbSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.setX = str2double(get(handles.CentX,'String'));
handles.setY = str2double(get(handles.CentY,'String'));
handles.setR = get(handles.RadSet,'Value');

handles.Image = handles.Image*0;
output_coord = plot_circle(handles.setX,handles.setY,handles.setR);

for i=1:size(output_coord,1)
    handles.Image(round(output_coord(i,2)),round(output_coord(i,1))) = 1;
end
axes(handles.axes1);
imshow(handles.Image);

guidata(hObject, handles);

