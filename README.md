# Signal Processing (SP) project 4: Frequency-domain mean-smoothing filter using convolution
Replicating a time-frequency domain filter in the frequency domain using convolution.

# Credit
The dataset and proposal of the exercise is from the Udemy course [Signal Processing Problems, solved in Matlab and in Python](https://www.udemy.com/course/signal-processing/). I highly recommend this course for those interested in signal processing.

# Exercise
"Convolution in time domain equals multiplication in frequency domain" or vice versa "Multiplication in time equals convolution in the frequency domain". 

With this in mind, I will replicate in the frequency domain the mean-smooth filter in the time-domain that I developed in a
[previous exercise](https://github.com/MariaGoniIba/SP1-Time-series-denoising). These are both versions:

Time-domain:
```
% implement the running mean filter in the time-domain
k = 5; % filter window is actually k*2+1
for i=k+1:n-k-1
    % each point is the average of k surrounding points
    filtsig(i) = mean(signal(i-k:i+k));
end
```

Frequency-domain:
```
% For dot product, both vectors have to be same length. Therefore I zero-pad
% The number of zeros is length of the kernel -1
% Therefore, the length of the convolution result will be = length signal + length kernel -1
kernel_len = 2*k + 1; % kernel width
convresult_len = length(signal) + kernel_len -1;

% Convolution kernel
convKer = ones(1,kernel_len) * 1/kernel_len;
convKerFFT = fft(convKer, convresult_len);
signalFFT = fft(signal, convresult_len);
filtsigcnv = ifft(convKerFFT.* signalFFT);
% trim zero-padding
filtsigcnv = filtsigcnv(k+1:end-k);
```

Here I plot the original noisy signal and both filtered solutions. 
I add a 0.2 offset to the convolution solution to visualize better that it is the same as the time-domain solution.
<p align="center">
    <img width="800" src="https://github.com/MariaGoniIba/SP4-Frequency-domain-mean-smoothing-filter-Convolution/blob/main/Solution.png">
</p>

