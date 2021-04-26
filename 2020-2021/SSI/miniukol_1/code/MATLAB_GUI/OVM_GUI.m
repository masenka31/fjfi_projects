function varargout = OVM_GUI(varargin)
%OVM_GUI MATLAB code file for OVM_GUI.fig
%      OVM_GUI, by itself, creates a new OVM_GUI or raises the existing
%      singleton*.
%
%      H = OVM_GUI returns the handle to a new OVM_GUI or the handle to
%      the existing singleton*.
%
%      OVM_GUI('Property','Value',...) creates a new OVM_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to OVM_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      OVM_GUI('CALLBACK') and OVM_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in OVM_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OVM_GUI

% Last Modified by GUIDE v2.5 13-Nov-2020 23:11:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OVM_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OVM_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before OVM_GUI is made visible.
function OVM_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
clc
% Choose default command line output for OVM_GUI
handles.output = hObject;

% START USER CODE
% Create a timer object to fire at 1/10 sec intervals
% Specify function handles for its start and run callbacks
handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly
    'Period', 0.1, ...                        % Initial period is 1 sec.
    'TimerFcn', {@update_display,hObject}); % Specify callback function
% END USER CODE



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OVM_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OVM_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function EditSa_Callback(hObject, eventdata, handles)
% hObject    handle to EditSa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSa as text
%        str2double(get(hObject,'String')) returns contents of EditSa as a double


% --- Executes during object creation, after setting all properties.
function EditSa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditVmax_Callback(hObject, eventdata, handles)
% hObject    handle to EditVmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditVmax as text
%        str2double(get(hObject,'String')) returns contents of EditVmax as a double


% --- Executes during object creation, after setting all properties.
function EditVmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditVmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditA_Callback(hObject, eventdata, handles)
% hObject    handle to EditA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditA as text
%        str2double(get(hObject,'String')) returns contents of EditA as a double


% --- Executes during object creation, after setting all properties.
function EditA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditDa_Callback(hObject, eventdata, handles)
% hObject    handle to EditDa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditDa as text
%        str2double(get(hObject,'String')) returns contents of EditDa as a double


% --- Executes during object creation, after setting all properties.
function EditDa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditDa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditV0_Callback(hObject, eventdata, handles)
% hObject    handle to EditV0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditV0 as text
%        str2double(get(hObject,'String')) returns contents of EditV0 as a double


% --- Executes during object creation, after setting all properties.
function EditV0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditV0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditDsafe_Callback(hObject, eventdata, handles)
% hObject    handle to EditDsafe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditDsafe as text
%        str2double(get(hObject,'String')) returns contents of EditDsafe as a double


% --- Executes during object creation, after setting all properties.
function EditDsafe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditDsafe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditDb_Callback(hObject, eventdata, handles)
% hObject    handle to EditDb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditDb as text
%        str2double(get(hObject,'String')) returns contents of EditDb as a double


% --- Executes during object creation, after setting all properties.
function EditDb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditDb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditB_Callback(hObject, eventdata, handles)
% hObject    handle to EditB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditB as text
%        str2double(get(hObject,'String')) returns contents of EditB as a double


% --- Executes during object creation, after setting all properties.
function EditB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



function EditRozestupy_Callback(hObject, eventdata, handles)
% hObject    handle to EditRozestupy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditRozestupy as text
%        str2double(get(hObject,'String')) returns contents of EditRozestupy as a double


% --- Executes during object creation, after setting all properties.
function EditRozestupy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditRozestupy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditVozy_Callback(hObject, eventdata, handles)
% hObject    handle to EditVozy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditVozy as text
%        str2double(get(hObject,'String')) returns contents of EditVozy as a double


% --- Executes during object creation, after setting all properties.
function EditVozy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditVozy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PustPustit.
function PustPustit_Callback(hObject, eventdata, handles)
% hObject    handle to PustPustit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Sa = str2double(get(handles.EditSa, 'string'));
v_max = str2double(get(handles.EditVmax, 'string'));
d_safe = str2double(get(handles.EditDsafe, 'string'));
da = str2double(get(handles.EditDa, 'string'));
db = str2double(get(handles.EditDb, 'string'));
v0 = str2double(get(handles.EditV0, 'string'));
A = str2double(get(handles.EditA, 'string'));
B = str2double(get(handles.EditB, 'string'));
n = str2double(get(handles.EditVozy, 'string'));
delta = str2double(get(handles.EditRozestupy, 'string'));

opt = get(handles.popupmenu1, 'Value'); 

vizualizace = get(handles.PopUpViz, 'Value');

% volime mimo
h = 0.05;

x0 = delta * (n - 1);
if delta == 0
    X = zeros(1,n);
else
    X = x0:-delta:0;
end
V = zeros(1,n); % vektor poèáteèních rychlostí - zvoleno 0
V(1) = v1(0,A, B, v0); % pøepoèet pro v1 (závisí na funkci v1)
XX = X;
VV = V;

[Hx,Hv] = OVM(XX,VV,Sa,v_max,d_safe,da,db,v0,A,B,n,delta,opt,h);

if vizualizace == 1
    
    t = 0;
    tmax = length(Hx(:,1)); % Podle delky for cyklu v OVM je 1001
    axes(handles.axes3);


    while t < tmax
        t = t + 1;
        bar([Hx(t,:)], [Hv(t,:)], 0, 'b');
        xmax = max(Hx(tmax,:));
        axis([0 xmax+5 0 v_max+1])
        xlabel('Vzdalenost'); 
        ylabel('Speed');
        title('Rychlost vozidel s pozicemi')
        pause(0.0001);        
    end

    axes(handles.axes5);
    t = 1;
    while t < tmax
        t = t + 1;
        p = plot(Hx(t,:), -1, 'ob');
        xmax = max(Hx(tmax,:));
        axis([0 xmax+5 -2 0])
        set(p(end), 'MarkerFaceColor', 'r'); 
        set(p(1), 'MarkerFaceColor', 'g');
        title('Vzajemne pozice vozidel');
        xlabel('Vzdalenost'); 
        pause(0.0001);
    end

else
    tmax = length(Hx(:,1));
    t_end = tmax*h;
    tline = h:h:t_end;
    axes(handles.axes3);
    for j = 1:length(Hx(1,:))
        plot(handles.axes3,tline,Hx(:,j))
        hold on
        title('Graf zavislosti vzdalenosti na case')
        xlabel('Cas [s]')
        ylabel('Vzdalenost')

    end
    hold off
    axes(handles.axes5);
    %figure;
    for j = 1:length(Hv(1,:))
        plot(handles.axes5, tline,Hv(:,j))
        hold on
        title('Graf zavislosti rychlosti na case')
        xlabel('Cas [s]')
        ylabel('Rychlost')
    end
    hold off
end

% --- Executes on button press in stopBtn.
function stopBtn_Callback(hObject, eventdata, handles)
% hObject    handle to stopBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% START USER CODE
% Only stop timer if it is running
if strcmp(get(handles.timer, 'Running'), 'on')
    stop(handles.timer);
end
% END USER CODE


% START USER CODE
function update_display(hObject,eventdata,hfigure)
% Timer timer1 callback, called each time timer iterates.
% Gets surface Z data, adds noise, and writes it back to surface object.

handles = guidata(hfigure);
Z = get(handles.surf,'ZData');
Z = Z + 0.1*randn(size(Z));

for j = 1:length(Hx(1,:))
    X_t = Hx(:,j);
    plot(handles.axes3,Hx(:,j))
    hold on
end
title('Graf zavislosti vzdalenosti na case')
xlabel('Cas')
ylabel('Vzdalenost')
set(handles.surf,'ZData',Z);
% END USER CODE


% --- Executes on selection change in PopUpViz.
function PopUpViz_Callback(hObject, eventdata, handles)
% hObject    handle to PopUpViz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PopUpViz contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopUpViz


% --- Executes during object creation, after setting all properties.
function PopUpViz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpViz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
