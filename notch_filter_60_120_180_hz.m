%%
% MUSTAFA GÜÇLÜ - 05110000994
% BACHIR TCHANA TANKEU - 05120000820
% Second Order IIR Notch Filter Design v1.0
% Ege University EEE Signal Processing Project 
% May 2016 - GNU GPL v3 Licensed 


clear all
close all
clc

fs=600; % Sampling rate
f1=60; % fundamental harmonic
f2=120; % second harmonic
f3=180; % third harmonic
BW=4; % 3 dB bandwidth
r=1-BW/fs*pi; % the required magnitude of the poles

% Notch filter with a notch frequency of 60 Hz ==> H1(z)
theta1=f1/fs*360*pi/180; % the center frequency to obtain the angle of the pole location
K1=(1-2*r*cos(theta1)+r^2)/(2-2*cos(theta1)); % the unit-gain scale factor
b1=K1*[1 -2*cos(theta1) 1] % coefficients for the numerator
a1=[1 -2*r*cos(theta1) r^2] % coefficients for the denominator

% Notch filter with a notch frequency 120 Hz ==> H2(z)
theta2=f2/fs*360*pi/180; % the center frequency to obtain the angle of the pole location
K2=(1-2*r*cos(theta2)+r^2)/(2-2*cos(theta2)); % the unit-gain scale factor
b2=K1*[1 -2*cos(theta2) 1] % coefficients for the numerator
a2=[1 -2*r*cos(theta2) r^2] % coefficients for the denominator

% Notch filter with a notch frequency of 180 Hz ==> H3(z)
theta3=f3/fs*360*pi/180; % the center frequency to obtain the angle of the pole location
K3=(1-2*r*cos(theta3)+r^2)/(2-2*cos(theta3)); % the unit-gain scale factor
b3=K1*[1 -2*cos(theta3) 1] % coefficients for the numerator
a3=[1 -2*r*cos(theta3) r^2] % coefficients for the denominator

%%
% MUSTAFA GÜÇLÜ - 05110000994
% BACHIR TCHANA TANKEU - 05120000820

load 'ecgbn.dat'; % Load noisy ECG recording
T=1/600; % Sampling interval
t=0:T:1499*T; % Recover time

b=conv(conv(b1,b2),b3); %convolution for the numerators
a=conv(conv(a1,a2),a3); %convolution for the denominators
[H w]=freqz(b,a);
subplot(2,1,1);
plot(w*fs/(2*pi),20*log10(abs(H))); %frequency domain
grid on;
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title('\midH(e^j^\Omega)\mid');
subplot(2,1,2);
plot(w*fs/(2*pi),angle(H)); %frequency domain
grid on;
xlabel('Frequency (Hz)');
ylabel('Phase');
title('\angleH(e^j^\Omega)');

y=filter(b,a,ecgbn); % filtering for ECG Signal with Noise
figure;
subplot(2,1,1);
plot(t,ecgbn); % Input Signal with noise
grid on;
xlabel('time (s)');
ylabel('Amplitude');
title('ECG Signal with Noise');
subplot(2,1,2);
plot(t,y); %Filtered Signal at 60Hz, 120Hz, and 180Hz
grid on;
xlabel('time (s)');
ylabel('Amplitude');
title('The Signal after 3-Notch Filter');

