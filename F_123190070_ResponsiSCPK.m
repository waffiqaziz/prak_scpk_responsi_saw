% Waffiq Aziz / 123190070 / Plug-F
% link dataset : https://www.kaggle.com/wisnuanggara/daftar-harga-rumah

function varargout = F_123190070_ResponsiSCPK(varargin)
% F_123190070_RESPONSISCPK MATLAB code for F_123190070_ResponsiSCPK.fig
%      F_123190070_RESPONSISCPK, by itself, creates a new F_123190070_RESPONSISCPK or raises the existing
%      singleton*.
%
%      H = F_123190070_RESPONSISCPK returns the handle to a new F_123190070_RESPONSISCPK or the handle to
%      the existing singleton*.
%
%      F_123190070_RESPONSISCPK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in F_123190070_RESPONSISCPK.M with the given input arguments.
%
%      F_123190070_RESPONSISCPK('Property','Value',...) creates a new F_123190070_RESPONSISCPK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before F_123190070_ResponsiSCPK_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to F_123190070_ResponsiSCPK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help F_123190070_ResponsiSCPK

% Last Modified by GUIDE v2.5 25-Jun-2021 20:41:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @F_123190070_ResponsiSCPK_OpeningFcn, ...
                   'gui_OutputFcn',  @F_123190070_ResponsiSCPK_OutputFcn, ...
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


% --- Executes just before F_123190070_ResponsiSCPK is made visible.
function F_123190070_ResponsiSCPK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to F_123190070_ResponsiSCPK (see VARARGIN)

% Choose default command line output for F_123190070_ResponsiSCPK
handles.output = hObject;
clc; % clear command window

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes F_123190070_ResponsiSCPK wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% MENAMPILKAN DATA PADA UITABLE
    % data nama rumah
    dataNama = readtable('DATA RUMAH.xlsx','Range','B1:B1011'); % read table
    dataNama = table2cell(dataNama);
    
    % data harga rumah
    dataHarga = readtable('DATA RUMAH.xlsx','Range','C2:C1011'); % read table
    dataHarga = table2cell(dataHarga);
    
    % merubah format harga
    fun = @(x) sprintf('%0.2f', x);
    longHarga = cellfun(fun, dataHarga, 'UniformOutput',0);
    
    % data kolom 3-7
    data = readtable('DATA RUMAH.xlsx','Range','D2:H1011'); % read table
    data = table2cell(data); % ubah menjadi cell arrays
    
    % gabungkan pada satu cell
    data = [dataNama,longHarga,data];
    
    % tampilkan dalam UITABLE
    set(handles.uitable1,'data',data); % tampilkan di UITABLE


% --- Outputs from this function are returned to the command line.
function varargout = F_123190070_ResponsiSCPK_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% KETERANGAN BOBOT KRITERIA
    % 30% untuk harga rumah, 
    % 20% untuk luas bangunan, 
    % 23% luas tanah, 
    % 10% jumlah kamar tidur,
    % 7% jumlah kamar mandi, 
    % 10% untuk jumlah garasi. 

%% READ TABLE
    data1 = readtable('DATA RUMAH.xlsx','Range','C2:H1011');
    data1 = table2array(data1); % ubah ke bentuk array
     
%% BOBOT untuk masing-masing kriteria
    bobot = [0.30, 0.20, 0.23, 0.20, 0.07, 0.10];

%% NILAI ATRIBUT, dimana 0= atribut biaya &1= atribut keuntungan
    % harga rumah, luas bangunan, luas tanah, jumlah kamar tidur,
    % jumlah kamar mandi, untuk jumlah garasi. 
    k = [0, 1, 1, 1, 1, 1];

%% NORMALISASI MATRIX
    % matriks m x n dengan ukuran sebanyak variabel x(input)
    [m, n] = size(data1); % 1010 x 6

    % membuat matriks R, yang merupakan matriks kosong
    R = zeros(m,n);

    for j = 1 : n
        if k(j) == 1 % statement untuk kriteria dengan atribut keuntungan
            R(:,j) = data1(:,j)./max(data1(:,j));
        else
            R(:,j) = min(data1(:,j))./data1(:,j);
        end
    end
    
%% PROSES PERANGKINGAN
    for i = 1 : m
        V(i) = sum(bobot.*R(i,:)) ;
    end

%% OLAH DATA UNTUK DITAMPILKAN PADA HASIL
    % reshape cell arrays menjadi 1010x1
    dataRanking = (reshape(V,[1010,1])); 

    % ambil nama rumah dan harga
    dataNama = readtable('DATA RUMAH.xlsx','Range','B1:B1011');
    dataHarga = readtable('DATA RUMAH.xlsx','Range','C2:C1011');
    
    % ubah ke bentuk table
    dataRanking = table(dataRanking);
    
    % UNTUK PENGECEKAN gabungkan antara data ranking 
    % dengan data nama rumah
    % dataAll = [dataNama,dataRanking]

    % ubah ke bentuk array
    dataRanking = table2array(dataRanking);
    dataNama = table2array(dataNama);

%% SORTING DATA 
    % sorting rating dari terbesar -> terkecil (menurun)
    [dataRanking,sortIdx] = sort(dataRanking,'descend');

    % sorting berdasarkan index dari perhitungan rating
    dataNama = dataNama(sortIdx);

    % ubah ke bentuk cell array
    dataHarga = table2cell(dataHarga);

    % sorting berdasarkan indeks ranking
    dataHarga = dataHarga(sortIdx); 

%% MERUBAH FORMAT DATA HARGA
    fun = @(x) sprintf('%0.2f', x);
    longHarga = cellfun(fun, dataHarga, 'UniformOutput',0);
    
%% GABUNGKAN 2 CELL ARRAY (NAMA dan HARGA RUMAH)
    dataAllSort = [dataNama,longHarga]; 

%% TAMPILKAN PADA GUI (UITABLE)
    set(handles.uitable2,'Data',dataAllSort(1:20,:)); % ranking
