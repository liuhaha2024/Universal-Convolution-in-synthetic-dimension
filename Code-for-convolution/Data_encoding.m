%%%%%%This code is used to encode image data on to frequency comb%%%

clear all

% Import images to be processed
A_RGB=imread('flower.jpg');

% Convert a 2D Image to 1D matrix 
% 0-lev, 1-ver
swch = 0; 

% Create the CSV files that can be imported directly into waveshaper WSS-2000
% max_ij = fig_size^2/m
for ij=1:10       %%40*40/160=10, encoding 1600 pixel value on to 160 combs, for 10 times
num = ij;

fig_size = 40; %%40*40 pixels
m=160;  %%frequency combs

lamda0 = 1550e-9; %% Center wavelength of a frequency comb, unit: meter

% , comb tooth width 'df', 
fsr = 0.025; %FSR of the Frequency comb,THz
df = 0.0125; %spectral width of the comb, THz
df_ref = 3*fsr;%distance from the reference line to the coding region


% Convert the image to grayscale
A_gray=rgb2gray(A_RGB);

% Resize the image and restore the original
B=imresize(A_gray,[fig_size fig_size]); %%the grayscale image after resizing
figure
imshow(B);  % B or B_RGB
C=zeros(fig_size);
BB=cast(B,'like',C);

% Renormalization the edge pixel value of the original image. If the value
% BB>120, then BB=BB-5, else BB=BB+5
for i=1:fig_size
    for j=1:fig_size
       if BB(i,j)>120
           BB(i,j)=BB(i,j)-5;
       else
           BB(i,j)=BB(i,j)+5;
       end
    end
end

% Normalize the pixel values of the original image
BB=(BB+1)/256;

% Convert the original image to a one-dimensional format, horizontally-
% -'data_lev' and vertically 'data_ver'
data_ver=BB(:);
BBB=BB';
data_lev=BBB(:);


% Assign normalized, one-dimensional pixel values to the frequency comb-
% -intensity 'data'
data=(1-swch)*data_lev(1+m*(num-1):m*num)+swch*data_ver(1+m*(num-1):m*num);


% Light Source Flatness Calibration, Correction_160.mat
% It varies depending on the light source
% If the light source is uniform, Correction_160=ones(160,1)
load('Correction_160.mat');
data=data.*Correction_160;

% Create the frequency axis 'f'
N=m;
f_0 = 3e8/lamda0/1e12;
f=linspace(-(m-1)*fsr/2,(m-1)*fsr/2,N)';
f = f+f_0;

% Create a matrix in a CSV file where the first column represents the- 
% -encoding frequency 'f', the second column represents the width of the- 
% -encoding frequency 'df', and the third column represents the intensity- 
% -reduction of the encoding frequency (data).
a=zeros(N,3);
a(:,1)=f; % THz
a(:,2)=f*0+df;
a(:,3)=-10*log10(data+1e-9); % dB

% Plot a frequency comb 
figure(3)
plot(a(:,1),-a(:,3));hold on

% CSV filename
str='Broad_fsr25G_df12.5G_data_';
if swch == 0
    str=[str 'lev_' num2str(num) '.csv'];
else
    str=[str 'ver_' num2str(num) '.csv'];
end

% Write to a CSV file at intervals
b=zeros(N*2,3);
for i=1:N*2
    if mod(i,2) == 0
       b(i,1)=a(i/2,1); 
       b(i,2)=df*1e3;
       b(i,3)=a(i/2,3);
    end
    if mod(i,2)==1
        b(i,1)=a((i+1)/2,1)-fsr/2;
        b(i,2)=df*1e3;
        b(i,3)=21; % A reduction of 21 dB is considered to be close to zero
    end
end

% Coding of reference frequency comb teeth
% To adjust the position and strength of the reference comb teeth, 
% -please modify the following code
c=zeros(N*2+5,3); 
c(6:end,:)=b;
%%defining the position of reference comb line
for i=1:5
c(i,1)=b(1,1)-(6-i)*df;
c(i,2)=df*1e3;
c(i,3)=21;
end

load('r0.mat');
c(1,3)= -10*log10(1*r0+1e-9);
% c(1,3)=0; % Reference comb tooth strength


% The following code examples demonstrate how to write CSV files in- 
% -a format compatible with WSS-2000.
mt=linspace(1,N*2+5,N*2+5)';
portnum=linspace(1,1,N*2+5)';
temp_col={'Channel_number','Center_frequency_THz','Channel_bandwidth_GHz','Set_bandwidth_GHz','Attenuation_dB','Port_number'};
result_table = table(num2str(mt), round(c(:, 1),3), c(:, 2), c(:,2), round(c(:, 3),3), portnum, 'VariableNames', temp_col);

temp_file='temp_file.csv';
writetable(result_table,temp_file);

fid = fopen(temp_file, 'r');
if fid == -1
    error('error');
end

content = {};
line_count = 0;
while ~feof(fid)
    line_count = line_count + 1;
    content{line_count} = fgetl(fid); 
end
fclose(fid);

if ~isempty(content)
    content{1} = strrep(content{1}, 'Channel_number', 'Channel number');
    content{1} = strrep(content{1}, 'Center_frequency_THz', 'Center frequency [THz]');
    content{1} = strrep(content{1}, 'Channel_bandwidth_GHz', 'Channel bandwidth [GHz]');
    content{1} = strrep(content{1}, 'Set_bandwidth_GHz', 'Set bandwidth [GHz]');
    content{1} = strrep(content{1}, 'Attenuation_dB', 'Attenuation [dB]');
    content{1} = strrep(content{1}, 'Port_number', 'Port number');
end

fid = fopen(str, 'w');
for i = 1:line_count
    fprintf(fid, '%s\n', content{i});
end
fclose(fid);

delete(temp_file);
end

close all