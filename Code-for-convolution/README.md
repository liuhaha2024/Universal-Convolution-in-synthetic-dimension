This content is for deming the results in paper entitled "Universal convolution from wave dynamics: photonic processing and encryption in synthetic dimension".

1. System requirements (The code has been tested on)
Software: Matlab 2017a or higher version.
Operating system: Windows 10 Professional.
Hardware requirements: The same as Matlab 2017a.

2. Installation guide
The code is for Matlab software. No additional installation is needed.

3. Demo
Instructions to run on data: This file contains two main Matlab codes (Data_encoding.m, Frequency_comb_decoding.m), for data encoding and restoring from experimentally measured frequency comb spectra. Two datasets are provide for testing, "Correction_160.mat" and "r0.mat". The original image is provide, "flower.jpg". The experimental datasets consisting of 10 CSV files are located in the "flower_broad_121" folder.
Expected output: The outputs of  "code Data_encoding.m" are ten CSV files for  encoding image data onto frequency comb by waveshaper (WSS-2000, Santec).  The code  "Frequency_comb_decoding.m" plots 3 figures including image of a flower from original, after frequency convolution and calculated by computer, respectively. 
Expected run time for demo on a "normal" desktop computer: less than 10 seconds.

4. Instructions for use
Make sure that all the files are in the same dictionary. The details have been commented in the Matlab codes.

