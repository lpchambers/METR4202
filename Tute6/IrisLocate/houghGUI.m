function varargout = houghGUI(varargin)
% HOUGHGUI M-file for houghGUI.fig
%      HOUGHGUI, by itself, creates a new HOUGHGUI or raises the existing
%      singleton*.
%
%      H = HOUGHGUI returns the handle to a new HOUGHGUI or the handle to
%      the existing singleton*.
%
%      HOUGHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOUGHGUI.M with the given input arguments.
%
%      HOUGHGUI('Property','Value',...) creates a new HOUGHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before houghGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to houghGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help houghGUI

% Last Modified by GUIDE v2.5 09-Jun-2007 16:44:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @houghGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @houghGUI_OutputFcn, ...
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


% --- Executes just before houghGUI is made visible.
function houghGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to houghGUI (see VARARGIN)

% Choose default command line output for houghGUI
handles.output = hObject;

S = repmat(logical(uint8(0)),400,400);
output_coord = plot_circle(200,200,75);

for i=1:size(output_coord,1)
    S(round(output_coord(i,2)),round(output_coord(i,1))) = 1;
end
axes(handles.axes1);
imshow(S);
handles.S = S;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes houghGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = houghGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbLoad.
function pbLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.tif'});
S = imread([pathname filename]);
handles.S = S;
axes(handles.axes1);
imshow(S);
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pbDetect.
function pbDetect_Callback(hObject, eventdata, handles)
% hObject    handle to pbDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
R = get(handles.sldR,'Value');
[C,HM] = Houghcircle(handles.S,[R,R]);
[maxval, maxind] = max(max(HM));

axes(handles.axes2);
imshow(HM);

axes(handles.axes3);
imshow(handles.S);hold on;

output_coord = plot_circle(C(1),C(2),C(3));
plot(output_coord(:,1),output_coord(:,2));
plot(C(1),C(1),'r*');hold off;


set(handles.txtX,'string',C(1));
set(handles.txtY,'string',C(2));
set(handles.txtVal,'string',maxval);

% --- Executes on slider movement.
function sldR_Callback(hObject, eventdata, handles)
% hObject    handle to sldR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.txtR,'string',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function sldR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





function txtX_Callback(hObject, eventdata, handles)
% hObject    handle to txtX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtX as text
%        str2double(get(hObject,'String')) returns contents of txtX as a double


% --- Executes during object creation, after setting all properties.
function txtX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtY_Callback(hObject, eventdata, handles)
% hObject    handle to txtY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtY as text
%        str2double(get(hObject,'String')) returns contents of txtY as a double


% --- Executes during object creation, after setting all properties.
function txtY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtVal_Callback(hObject, eventdata, handles)
% hObject    handle to txtVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtVal as text
%        str2double(get(hObject,'String')) returns contents of txtVal as a double


% --- Executes during object creation, after setting all properties.
function txtVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pbReturn.
function pbReturn_Callback(hObject, eventdata, handles)
% hObject    handle to pbReturn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Close Current figure window.
close(gcf);


