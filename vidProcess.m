function varargout = VidProcess(varargin)

% initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VidProcess_OpeningFcn, ...
                   'gui_OutputFcn',  @VidProcess_OutputFcn, ...
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


% --- Executes just before VidProcess is made visible.
function VidProcess_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for VidProcess
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes VidProcess wait for user response (see UIRESUME)
% uiwait(handles.MainWin);
axes(handles.TitlePicture);
img = imread('data\webcam-128.png');
imshow(img);

% --- Outputs from this function are returned to the command line.
function varargout = VidProcess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ProcessList.
function ProcessList_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ProcessList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ProcessList


% --- Executes during object creation, after setting all properties.
function ProcessList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
vid = videoinput('winvideo',1);
set(vid, 'FramesPerTrigger', 300);
start(vid);
% run until figure is closed
axes(handles.MainAxes);
while(ishandle(hObject))
    % wait for frame time
    pause(0.01);
    avail = get(vid,'FramesAvailable');
    if(avail > 0)
        % get frame
        [frame, ~] = getdata(vid, avail);
        img = frame(:,:,:,1);
        imshow(img);
    end
end

delete(vid);
clear vid;
