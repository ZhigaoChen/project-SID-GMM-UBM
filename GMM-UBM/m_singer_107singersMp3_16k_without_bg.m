load('result/gmm_ubm.mat')

for ispeaker = 10001 : 10107
    cepsmat = [];
    files = dir(['dataset/107singersMp3_20_fold_16k_without_bg/', num2str(ispeaker), '/train/*.wav']);
    
    for ifile = 1 : length(files)
        [d, sr] = audioread(['dataset/107singersMp3_20_fold_16k_without_bg/', num2str(ispeaker), '/train/', files(ifile).name]);
        
        disp(['dataset/107singersMp3_20_fold_16k_without_bg/', num2str(ispeaker), '/train/', files(ifile).name]);
        disp('wavfile======up===ing==');
        ceps = melcepst(d, sr, 'M', 12, floor(3*log(sr)), 160);
        for icol = 1 : size(ceps, 2)
            ceps(:, icol) = ceps(:, icol) - mean(ceps(:, icol));
        end
        cepsmat = [cepsmat; ceps];
    end
    
    gmm_speaker = gmmmap(gmm_ubm, cepsmat, 32);
    
    save(['result/gmm_speaker_', num2str(ispeaker), '.mat'], 'gmm_speaker');
end