% First method: smooth-filter in the time domain
% Second method: smooth-filter in the frequency domain

clear; clc; close all
% create signal
srate = 1000; % Hz
time  = 0:1/srate:3; % 3 seconds
n     = length(time);
p     = 15; % poles for random interpolation

% noise level, measured in standard deviations
noiseamp = 5; 

% amplitude modulator and noise level
ampl   = interp1(rand(p,1)*30,linspace(1,p,n));
noise  = noiseamp * randn(size(time));
signal = ampl + noise;

% figure(1)
% % plot(time,ampl) %plot original signal
% plot(time, signal) % add noise to the signal
% title('Noisy signal')

% initialize filtered signal vector
filtsig = zeros(size(signal)); % using zeros for the edges
%filtsig = signal; % dealing with edge effects setting them up to the original signal

% implement the running mean filter in the time-domain
k = 5; % filter window is actually k*2+1
for i=k+1:n-k-1
    % each point is the average of k surrounding points
    filtsig(i) = mean(signal(i-k:i+k));
end

% To perform the dot product, the signal has to be zero-padded at the beginning since both vectors need to be of same length. 
% The number of zeros is length of the kernel -1
% Therefore, the length of the convolution result will be = length signal + length kernel -1
kernel_len = 2*k + 1; % kernel width
convresult_len = length(signal) + kernel_len -1;

% Convolution kernel.The median is 1/npts * sum(value of each point)
convKer = ones(1,kernel_len) * 1/kernel_len;
convKerFFT = fft(convKer, convresult_len);
signalFFT = fft(signal, convresult_len);
filtsigcnv = ifft(convKerFFT.* signalFFT);
% trim zero-padding
filtsigcnv = filtsigcnv(k+1:end-k);

% plot the noisy and filtered signals
figure(2), clf, hold on
offset = 0.2; % add offset for better visualization
plot(time,signal, time,filtsig, time,filtsigcnv + 2*offset ,'linew',2)

% draw a patch to indicate the window size
tidx = dsearchn(time',1);
ylim = get(gca,'ylim');
patch(time([ tidx-k tidx-k tidx+k tidx+k ]),ylim([ 1 2 2 1 ]),'k','facealpha',.25,'linestyle','none')
plot(time([tidx tidx]),ylim,'k--')

xlabel('Time (sec.)'), ylabel('Amplitude')
legend({'Noisy signal';'Filtered';'Conv smooth';'Window';'window center'})
