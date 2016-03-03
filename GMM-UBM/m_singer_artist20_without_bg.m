load('result/gmm_ubm.mat')

for ispeaker = 10001 : 10020
    cepsmat = [];
    files = dir(['dataset/50_fold_artist20_whithout_bg/', num2str(ispeaker), '/train/*.wav']);
    
    for ifile = 1 : length(files)
        [d, sr] = audioread(['dataset/50_fold_artist20_whithout_bg/', num2str(ispeaker), '/train/', files(ifile).name]);
        ceps = melcepst(d, sr, 'M', 12, floor(3*log(sr)), 160);
        for icol = 1 : size(ceps, 2)
            ceps(:, icol) = ceps(:, icol) - mean(ceps(:, icol));
        end
        cepsmat = [cepsmat; ceps];
    end
    
    gmm_speaker = gmmmap(gmm_ubm, cepsmat, 32);
    
    save(['result/gmm_speaker_', num2str(ispeaker), '.mat'], 'gmm_speaker');
end