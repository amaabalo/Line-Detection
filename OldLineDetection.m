function varargout = LineDetection(varargin)
% LINEDETECTION MATLAB code for LineDetection.fig 
%      LINEDETECTION, by itself, creates a new LINEDETECTION or raises the existing
%      singleton*.
%
%      H = LINEDETECTION returns the handle to a new LINEDETECTION or the handle to
%      the existing singleton*.
%
%      LINEDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINEDETECTION.M with the given input arguments.
%
%      LINEDETECTION('Property','Value',...) creates a new LINEDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LineDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LineDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LineDetection

% Last Modified by GUIDE v2.5 12-Jul-2016 12:58:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LineDetection_OpeningFcn, ...
    'gui_OutputFcn',  @LineDetection_OutputFcn, ...
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


% --- Executes just before LineDetection is made visible.
function LineDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LineDetection (see VARARGIN)

set(gcf, 'WindowKeyPressFcn', @escPressed);
set(gcf, 'WindowButtonDownFcn', @getLocation);
pan off

handles.current_image = 'Image.png';
handles.image_type = 'RGB';

handles.p = [0; 0];
handles.q = [0; 0];

handles.endofline = false;
handles.i = 0;
handles.interval = 2;
handles.sigma0 = Inf;
handles.customsigma0 = Inf;
handles.sr = 0;
handles.textoutput = '';
handles.images = [];

handles.imagewidth = 256;
handles.imageheight = 256;
handles.firstm = [];

handles.oldp = [];
handles.oldq = [];

handles.choosesigma = false;
handles.profilewidth = 31;

handles.plots = [];
handles.debugmode = false;
handles.folder = '';

fid = fopen('Image 1.txt', 'r');

% Change values in text boxes.
handles.current_image = fgetl(fid);
handles.image_type = fgetl(fid);

handles.p(2) = str2double(fgetl(fid));
set(handles.edit3, 'string', num2str(handles.p(2)));

handles.p(1) = str2double(fgetl(fid));
set(handles.edit1, 'string', num2str(handles.p(1)));

handles.q(2) = str2double(fgetl(fid));
set(handles.edit4, 'string', num2str(handles.q(2)));

handles.q(1) = str2double(fgetl(fid));
set(handles.edit2, 'string', num2str(handles.q(1)));

fclose(fid);

% Reset step through values
handles.i = 0;
handles.endofline = false;

% Is line being selected?
handles.lineselection = false;
handles.n = 0;

% Number of profiles being shown
handles.profilenumber = 0;

% Save the handles structure.
guidata(hObject,handles)

axes(handles.axes1);
imshow(handles.current_image);
hp = impixelinfo;
set(hp,'Position',[5 1 300 20]);


hold on
plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);

% Choose default command line output for LineDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LineDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LineDetection_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2);
set(handles.text14, 'String', 0);
set(handles.text17, 'String', '-');

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
filename = strcat(str{val}, '.txt');

fid = fopen(filename, 'r');

% Change values in text boxes.
handles.current_image = fgetl(fid);
handles.image_type = fgetl(fid);

handles.p(2) = str2double(fgetl(fid));
set(handles.edit3, 'string', num2str(handles.p(2)));

handles.p(1) = str2double(fgetl(fid));
set(handles.edit1, 'string', num2str(handles.p(1)));

handles.q(2) = str2double(fgetl(fid));
set(handles.edit4, 'string', num2str(handles.q(2)));

handles.q(1) = str2double(fgetl(fid));
set(handles.edit2, 'string', num2str(handles.q(1)));

fclose(fid);

% Reset values
handles.i = 0;
handles.endofline = false;
handles.sigma0 = Inf;
handles.customsigma0 = Inf;
handles.choosesigma = false;
handles.profilenumber = 0;
handles.plots = [];
handles.lineselection = false;
handles.n = 0;
handles.textoutput = '';


% Save the handles structure.
guidata(hObject,handles)

axes(handles.axes1);
img = imread(handles.current_image);
handles.current_image = imresize(img,[256 256]);
handles.imagewidth = size(handles.current_image,2);
handles.imageheight = size(handles.current_image,1);
guidata(hObject,handles);
disp(size(handles.current_image))
cla(handles.axes1,'reset');
imshow(handles.current_image);
hold on
plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
y1 = str2double(get(hObject,'string'));
handles.p(1) = y1;
guidata(hObject, handles)

axes(handles.axes1);
imshow(handles.current_image);
hold on
plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
y2 = str2double(get(hObject,'string'));
handles.q(1) = y2;
guidata(hObject, handles)

axes(handles.axes1);
imshow(handles.current_image);
hold on
plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
x1 = str2double(get(hObject,'string'));
handles.p(2) = x1;
guidata(hObject, handles)

axes(handles.axes1);
imshow(handles.current_image);
hold on
plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
x2 = str2double(get(hObject,'string'));
handles.q(2) = x2;
guidata(hObject, handles)

axes(handles.axes1);
imshow(handles.current_image);
hold on
plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch handles.image_type
    case 'RGB'
        I0 = double(rgb2gray(handles.current_image))/255;%double(rgb2gray(imread(handles.current_image)))/255;
    case 'Grayscale'
        I0 = %double(imread(handles.current_image))/255;
end

handles.i = 0;
handles.profilenumber = 0;
handles.plots = [];
guidata(hObject, handles);

p = handles.p;
q = handles.q;

d = norm(q-p);
v = (q-p)/d;

I = repmat(I0,[1 1 3]);    

sigma0 = Inf;
handles.textoutput = strcat(handles.textoutput,sprintf('\n%s\n%s\n%s\n','Mode: Run Till End'));

for i = 0:2:1.2*d
    r0 = p+i*v;
    r = round(r0);
    I(r(1),r(2),1) = 1;
    I(r(1),r(2),2:3) = 0;
    m = [];
    start = -fix(handles.profilewidth/2);
    finish = fix((handles.profilewidth - 1)/2);
    for j = start:finish
        s0 = r0+j*[-v(2); v(1)];
        s = round(s0);
         
        if s(1)>handles.imagewidth 
            s(1) = handles.imagewidth;
        end
        if s(2)>handles.imageheight
            s(2) = handles.imageheight;
        end
        if s(1)<1
            s(1) = 1;
        end
        if s(2)<1
            s(2) = 1;
        end
        
        I(s(1),s(2),1) = 1;
        I(s(1),s(2),2:3) = 0;
        m = [m I0(s(1),s(2))];
    end
    if i==0
        handles.firstm = m;
        axes(handles.axes3);
        plot(m);
    end

    if i == 0
        if handles.choosesigma==false
            sigmas = [];
            for sigma = 0.25:5
                m = conv(m,fspecial('gaussian',[1 4*sigma],sigma),'same');
                
                a = round((handles.profilewidth - 11)/2) + 1;
                b = a + 10;
                mIn = m(a:b); % middle 11 pixels
                mConv = conv2(m,mIn,'same');
                [pks,lcs] = findpeaks(mConv);
                if handles.debugmode==true
                    figure(1)
                    plot(mConv);
                    pause
                end

                if length(pks) == 1
                    sigmas = [sigmas sigma];
                end
            end
            if handles.debugmode==true
                close(figure(1))
                handles.textoutput = strcat(handles.textoutput,sprintf('%s%s%s\n', 'Sigmas: [',num2str(sigmas),']'));
            end
            if size(sigmas)>0
                sigma0 = sigmas(1);
                set(handles.text17, 'String', num2str(sigma0));
            else 
                sigma0 = Inf;
                h = msgbox('sigma0 not found');
                return
            end
        else
            sigma0 = handles.customsigma0;
            m = conv(m,fspecial('gaussian',[1 4*sigma0],sigma0),'same');
            a = round((handles.profilewidth - 11)/2) + 1;
            b = a + 10;
            mIn = m(a:b);
            mConv = conv2(m,mIn,'same');
        end
    else
        m = conv(m,fspecial('gaussian',[1 4*sigma0],sigma0),'same');
        mConv = conv2(m,mIn,'same');

        [pks,lcs] = findpeaks(mConv);
        if length(pks) > 1
            break
        end
    end
end
ln = norm(r-p);
handles.textoutput = strcat(handles.textoutput,sprintf('\n%s\n','Line length: '),num2str(ln),' pixels');
guidata(hObject,handles);
set(handles.edit9,'String',handles.textoutput);
axes(handles.axes1);
imshow(I)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.profilenumber = handles.profilenumber + 1;
p = handles.p;
q = handles.q;

d = norm(q-p);
v = (q-p)/d;

if handles.endofline==true
    handles.i = 0;
    handles.profilenumber = 0;
    handles.plots = [];
    handles.endofline=false;
end

switch handles.image_type
    case 'RGB'
        I0 = double(rgb2gray(imread(handles.current_image)))/255;
    case 'Grayscale'
        I0 = double(imread(handles.current_image))/255;
end

if handles.i==0
    handles.I = repmat(I0,[1 1 3]);
    guidata(hObject, handles);
end

r0 = p+handles.i*v;
r = round(r0);
handles.I(r(1),r(2),1) = 1;
handles.I(r(1),r(2),2:3) = 0;
m = [];
start = -fix((handles.profilewidth)/2);
finish = fix((handles.profilewidth - 1)/2);
for j = start:finish
    s0 = r0+j*[-v(2); v(1)];
    s = round(s0);
    handles.I(s(1),s(2),1) = 1;
    handles.I(s(1),s(2),2:3) = 0;
    m = [m I0(s(1),s(2))];
end

if handles.i==0
    handles.firstm = m;
    axes(handles.axes3);
    plot(m);
end
if handles.i==0
    handles.textoutput = strcat(handles.textoutput,sprintf('\n%s\n%s\n%s\n','Mode: Step Mode','Step 1','Line length: 0 pixels'));
    if handles.choosesigma==false
        sigmas = [];
        for sigma = 0.25:5
            m = conv(m,fspecial('gaussian',[1 4*sigma],sigma),'same');
            a = round((handles.profilewidth - 11)/2) + 1;
            b = a + 10;
            handles.mIn = m(a:b);
            handles.mConv = conv2(m,handles.mIn,'same');
            [pks,lcs] = findpeaks(handles.mConv);
            if handles.debugmode==true
                figure(1)
                plot(handles.mConv);
                pause
            end
            if length(pks)==1
                sigmas = [sigmas sigma];
            end
        end
        if handles.debugmode==true
            close(figure(1))
            handles.textoutput = strcat(handles.textoutput,sprintf('\n%s%s%s\n', 'Sigmas: [',num2str(sigmas),']'));
        end
        if size(sigmas)>0
            handles.sigma0 = sigmas(1);
            set(handles.text17, 'String', num2str(handles.sigma0));
        else 
            handles.sigma0 = Inf;
            h = msgbox('sigma0 not found');
            return
        end
        
    else
        handles.sigma0 = handles.customsigma0;
        m = conv(m,fspecial('gaussian',[1 4*handles.sigma0],handles.sigma0),'same');
        a = round((handles.profilewidth - 11)/2) + 1;
        b = a + 10;
        handles.mIn = m(a:b);
        handles.mConv = conv2(m,handles.mIn,'same');
        guidata(hObject, handles);
    end
else
    ln = norm(r-p);
    handles.textoutput = strcat(handles.textoutput,sprintf('\n%s\n%s\n%s\n','Mode: Step Mode',strcat('Step ', num2str(handles.i+1)),strcat('Line length:',num2str(ln),' pixels')));
    m = conv(m,fspecial('gaussian',[1 4*handles.sigma0],handles.sigma0),'same');
    handles.mConv = conv2(m,handles.mIn,'same');

    [pks,lcs] = findpeaks(handles.mConv);
    if length(pks) > 1
        handles.endofline = true;
    end
end

set(handles.edit9,'String',handles.textoutput);
set(handles.text14, 'String', num2str(handles.i + 1));
handles.i = handles.i + handles.interval;

if handles.i>1.2*d
    handles.endofline = true;
end

axes(handles.axes1);
imshow(handles.I);
s = size(handles.plots);
if s(1)~=5
    handles.plots = [handles.plots; handles.mConv];
    r = {'1';'2';'3';'4';'5'}; 
    
    axes(handles.axes2);
    j = plot(handles.plots');
    set(j,{'DisplayName'},r(1:s+1,1));
    guidata(hObject, handles);
else
    r = [];
    for i=1:4
        handles.plots(i,:) = handles.plots(i+1,:);
        r = [r handles.profilenumber - 5 + i];
    end   
    handles.plots(5,:) = handles.mConv;
    r(5) = handles.profilenumber;
    r = strread(num2str(r),'%s');
    axes(handles.axes2);
    j = plot(handles.plots');
    set(j,{'DisplayName'},r);
end        

title('Graph of mConv')
legend show Location NorthEastOutside

guidata(hObject, handles);


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
handles.i = max([0 handles.i-handles.interval]);
handles.interval = str2double(get(hObject, 'String'));
if handles.i~=0
    handles.i = handles.i + handles.interval;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popupmenu1_Callback(handles.popupmenu1, eventdata, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lineselection = true;
handles.oldp = handles.p;
handles.oldq = handles.q;
set(gcf, 'Pointer', 'crosshair');
guidata(hObject, handles);
return

function pushbutton6_KeyPressFcn(hObject, eventdata, handles)
        set(gcf, 'Pointer', 'Arrow');
        handles.pushbutton6.Value = 0;
        handles.lineselection = false;
        guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function getLocation(src, event)
handles = guidata(src);
if handles.lineselection==true
    cursorPoint = get(handles.axes1,'CurrentPoint');
    if handles.n==0
        handles.p(2) = round(cursorPoint(1,1));
        set(handles.edit3, 'string', num2str(handles.p(2)));

        handles.p(1) = round(cursorPoint(1,2));
        set(handles.edit1, 'string', num2str(handles.p(1)));

        handles.n = 1;
        guidata(src, handles);
    else 
        handles.q(2) = round(cursorPoint(1,1));
        set(handles.edit4, 'string', num2str(handles.q(2)));

        handles.q(1) = round(cursorPoint(1,2));
        set(handles.edit2, 'string', num2str(handles.q(1)));

        % Reset step through values
        handles.i = 0;
        handles.endofline = false;
        handles.sigma0 = Inf;

        handles.pushbutton6.Value = 0;
        handles.n = 0;
        handles.lineselection = false;
        set(gcf, 'Pointer', 'arrow');
        % Save the handles structure.
        guidata(src,handles)

        axes(handles.axes1);
        imshow(handles.current_image);
        hold on
        plot([handles.p(2),handles.q(2)],[handles.p(1),handles.q(1)],':r*','LineWidth',1)
        text(handles.p(2),handles.p(1),['P (' num2str(handles.p(2)) ',' num2str(handles.p(1)) ')'], 'Color', [1 1 1]);
        text(handles.q(2),handles.q(1),['Q (' num2str(handles.q(2)) ',' num2str(handles.q(1)) ')'], 'Color', [1 1 1]);
    end
end

function escPressed(sr, ev)
    handles = guidata(sr);
    if strcmp(ev.Key,'escape') && handles.lineselection==true
        if handles.n==1
            handles.p = handles.oldp;
            handles.n = 0;
            set(handles.edit3, 'string', num2str(handles.p(2)));
            set(handles.edit1, 'string', num2str(handles.p(1)));
        end
        set(gcf, 'Pointer', 'Arrow');
        handles.pushbutton6.Value = 0;
        handles.lineselection = false;
        guidata(sr, handles);
    end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
set(handles.radiobutton5,'Value',0);
set(handles.edit7,'enable','off');
set(handles.edit7,'String','Enter sigma');
handles.choosesigma = false;
guidata(hObject, handles);

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
set(handles.edit7,'enable','on');
set(handles.edit7,'String','');
set(handles.radiobutton4,'Value',0);

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
handles.choosesigma = true;
handles.customsigma0 = str2double(get(handles.edit7,'String'));
guidata(hObject, handles);


% --- Executes  during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
handles.profilewidth = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
if get(hObject,'Value')==1
    handles.debugmode = true;
else
    handles.debugmode = false;
end
guidata(hObject,handles)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.folder = uigetdir;
guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(handles.folder)
files = dir(handles.folder);
files = files(~[files.isdir] & ~strncmpi('.', {files.name}, 1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input = '';
y = regexp({files.name},'txt');
for i=1:size(y,2)
    z = y(i);
    if ~isempty(z{1})
        input = files(i).name;
        break;
    end
end
resultsfolder = strcat(handles.folder,'_results');
mkdir(resultsfolder);

report = strcat(resultsfolder, 'report.txt');
rid = fopen(report,'wt');
fprintf(rid,'%15s    %5s   %11s    %9s    %11s    %13s\n','Image Name','Sigma','Start Point','End Point','Line Length','Profile Width');

filename = strcat(handles.folder,'/',input);
fid = fopen(filename, 'r');

p = [0;0];
q = [0;0];
while ~feof(fid)
    current_line = fgetl(fid);
    while strncmpi('#',current_line, 1)
        current_line = fgetl(fid);
    end
    current_cfig = textscan(current_line,'%s %s %d %d %d %d %s %s',1,'CommentStyle',{'/*', '*/'});
    current_image = current_cfig{1}{1};
    current_image = strcat(handles.folder,'/',current_image);
    image_type = current_cfig{2}{1};
    p(2) = current_cfig{3};
    p(1) = current_cfig{4};
    q(2) = current_cfig{5};
    q(1) = current_cfig{6};
    if strcmp(current_cfig{7}{1},'default')
        profilewidth = 15;
    else
        profilewidth = str2double(current_cfig{7}{1});
    end
    current_sigma0 = current_cfig{8}{1};
    
    switch image_type
        case 'RGB'
            I0 = double(rgb2gray(imread(current_image)))/255;
        case 'Grayscale'
            I0 = double(imread(current_image))/255;
    end
    
%     handles.i = 0;
%     handles.profilenumber = 0;
%     handles.plots = [];
%     guidata(hObject, handles);
    disp(p)
    disp(q)
    d = norm(q-p);
    v = (q-p)/d;
%     if any(ISNAN(v))
%         fprintf(rid,'%10s    %5s   %11.2f    %13d\n',current_cfig{1}{1},'-',0,profilewidth);
%         continue
%     end
    
    I = repmat(I0,[1 1 3]);     %RGB
    
    sigma0 = Inf;
    sigmas = [];
    for i = 0:2:1.2*d
        r0 = p+i*v;
        r = round(r0);
        I(r(1),r(2),1) = 1; 
        I(r(1),r(2),2:3) = 0;
        m = [];
        start = -fix(profilewidth/2);
        finish = fix((profilewidth - 1)/2);
        for j = start:finish
            s0 = r0+j*[-v(2); v(1)];
            s = round(s0);
            
            if s(1)>handles.imagewidth
                s(1) = handles.imagewidth;
            end
            if s(2)>handles.imageheight
                s(2) = handles.imageheight;
            end
            if s(1)<1
                s(1) = 1;
            end
            if s(2)<1
                s(2) = 1;
            end
            I(s(1),s(2),1) = 1;
            I(s(1),s(2),2:3) = 0;
            m = [m I0(s(1),s(2))];
        end
%         if i==0
%             handles.firstm = m;
%             axes(handles.axes3);
%             plot(m);
%         end
        if i == 0
            if strcmp(current_sigma0,'auto')
                for sigma = 0.25:5
                    m = conv(m,fspecial('gaussian',[1 4*sigma],sigma),'same');
                    a = round((profilewidth - 11)/2) + 1;
                    b = a + 10;
                    mIn = m(a:b); % middle 11 pixels
                    mConv = conv2(m,mIn,'same');
                    [pks,lcs] = findpeaks(mConv);
                    if length(pks) == 1
                        sigmas = [sigmas sigma];
                        %sigma0 = sigma;
                        %break
                    end
                end

                disp(sigmas);
                if size(sigmas)>0
                    sigma0 = sigmas(1);
                else
                    sigma0 = Inf;
                end
                if sigma0==Inf
                    h = msgbox('sigma0 not found');
                    return
                end
            else
                sigma0 = str2double(current_sigma0);
                m = conv(m,fspecial('gaussian',[1 4*sigma0],sigma0),'same');
                a = round((profilewidth - 11)/2) + 1;
                b = a + 10;
                disp(a)
                disp(b)
                disp(size(m))
                mIn = m(a:b);
                mConv = conv2(m,mIn,'same');
            end
        else
            m = conv(m,fspecial('gaussian',[1 4*sigma0],sigma0),'same');
            mConv = conv2(m,mIn,'same');
            [pks,lcs] = findpeaks(mConv);
            if length(pks) > 1
                break
            end
        end
    end
    ln = norm(r-p);
    initial = strcat(num2str(p(2)),',',num2str(p(1)));
    final = strcat(num2str(r(2)),',',num2str(r(1)));
    fprintf(rid,'%15s    %5.2f   %11s    %9s    %11.2f    %13d\n',current_cfig{1}{1},sigma0,initial,final,ln,profilewidth);
    disp(current_cfig{1}{1})
end
fclose('all');
disp('done');
