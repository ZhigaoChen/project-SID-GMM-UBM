clear,clc;
[y_mix,fs_mix,bits_mix]=wavread('artist20_10001_test_2.wav');
[y_vocal,fs_vocal,bits_vocal]=wavread('artist20_10001_test_2_withoutbg.wav');
subplot(211);
plot(y_mix);
title('music before vocal separation');
subplot(212);
plot(y_vocal);
title('music after vocal separation');