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
global vidObj procMode;
vidObj = 0;
procMode = 'Original';
handles.output = hObject;
guidata(hObject, handles);
axes(handles.TitlePicture);
img = imread('data\webcam-128.png');
imshow(img);



% --- Outputs from this function are returned to the command line.
function varargout = VidProcess_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



% --- Executes on selection change in ProcessList.
function ProcessList_Callback(hObject, eventdata, handles)
global procMode;
contents = cellstr(get(hObject, 'String'));
procMode = contents{get(hObject, 'Value')};



% --- Executes during object creation, after setting all properties.
function ProcessList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
global vidObj procMode;
% stop video if active
if(vidObj ~= 0)
    set(hObject, 'String', 'Start');
    delete(vidObj);
    vidObj = 0;
    return;
end
% prepare video object
set(hObject, 'String', 'Stop');
vidObj = videoinput('winvideo',1);
set(vidObj, 'FramesPerTrigger', 300);
start(vidObj);
% run until figure is closed
axes(handles.MainAxes);
while(ishandle(hObject) && vidObj ~= 0)
    % get frame
    pause(0.01);
    avail = get(vidObj,'FramesAvailable');
    if(avail > 0)
        [frame, ~] = getdata(vidObj, avail);
        img = frame(:,:,:,1);
        img = im2double(img);
        value = get(handles.ValueSlider, 'Value');
        img = VidProcess_GetImage(img, procMode, value);
        imshow(img);
    end
end
delete(vidObj);
vidObj = 0;



function imgOut = VidProcess_GetImage(img, mode, value)
switch(mode)
    case 'Original'
        imgOut = img;
    case 'Negative'
        imgOut = 1 - img;
    case 'Scaled'
        imgOut = 5 * value * img;
    case 'Logarithmic'
        imgOut = img_Log(img, uint8(5*value));
    case 'Exponential'
        imgOut = img .^ (5*value);
    case 'Equalized'
        imgOut = img_HistEq(img);
    case 'FFT (highlighted)'
        imgOut = img_Fft(img);
    otherwise
        imgOut = img;
end



% --- Executes on slider movement.
function ValueSlider_Callback(hObject, eventdata, handles)
% global inValue;
% inValue = get(hObject, 'Value');



% --- Executes during object creation, after setting all properties.
function ValueSlider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
