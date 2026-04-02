%%%%%%This code is used to restore image from measured frequency comb spectra,and compare results directly calculated by computer%%%

clear all

% the speed of light 
c=3e8;  % m/s

% Store data
M = linspace(0,0,1600);

for i=1:10
    temp = num2str(i);
    % File name to import
    filename = ['./flower_broad_121/' temp '.csv'];  
    L=29;V=0;
    data = csvread(filename,L,V); %%experimental data of measured frequency comb spectra

    % Import Data
    lamda = data(:,1); %nm
    f = c./lamda/1e3; %THz
    P = data(:,2); %mW
    df=f(1)-f(2);

    % Seeking the Peak
    [pks,locs]=findpeaks(P,'MinPeakDistance',0.015/df,'MinPeakHeight',1.9e-7);

    % Plot to observe peak detection
    figure
    hold on
    box on
    plot(f,P)
    plot(f(locs),pks,'o')
    xlim([192,196.3])
    ylim([0,12e-7])
    pbaspect([5,1,1])

    % Data normalization
    flower_lev_1 =round(flip(pks(1:end-3))/(pks(end)+pks(end-1)+pks(end-2))*255+1)';
    M(160*(i-1)+1:160*i) = flower_lev_1;
    
    if i == 9
        close all
    end
end



% For lev
flower_lev = reshape(M,40,40);
flower_broad_121 = flower_lev';

% Import the original image
A_RGB=imread('flower.jpg');
A_gray=rgb2gray(A_RGB);
B=imresize(A_gray,[40 40]);

% Frequency-convoluted image
t=cast(flower_broad_121,'like',B);
t_freq = t(2:end-1,2:end-1);

% Convolution results directly calculated by computer
ker = [1,2,1]/4;
x = double(B)';
x = x(:)';
y = conv(x,ker,'same');
out = reshape(y,40,40)';
out = out(2:end-1,2:end-1);
t_comp = cast(out,'like',B);


% Original image, frequency convolution, computer convolution
figure
imshow(B);
figure
imshow(t_freq);
figure
imshow(t_comp)






