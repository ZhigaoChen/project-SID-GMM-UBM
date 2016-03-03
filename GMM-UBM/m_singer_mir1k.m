
load('result/gmm_ubm.mat')

for ispeaker = 10001 : 10019
    cepsmat = [];
    files = dir(['dataset/10_fold_mir1k/', num2str(ispeaker), '/train/*.wav']);
    
    for ifile = 1 : length(files)
        disp(['dataset/10_fold_mir1k/', num2str(ispeaker), '/train/', files(ifile).name]);
        [d, sr] = wavread(['dataset/10_fold_mir1k/', num2str(ispeaker), '/train/', files(ifile).name]);
        ceps = melcepst(d, sr, 'M', 12, floor(3*log(sr)), 160);
        for icol = 1 : size(ceps, 2)
            ceps(:, icol) = ceps(:, icol) - mean(ceps(:, icol));
        end
        cepsmat = [cepsmat; ceps];
    end
    
    gmm_speaker = gmmmap(gmm_ubm, cepsmat, 32);
    
    save(['result/gmm_speaker_', num2str(ispeaker), '.mat'], 'gmm_speaker');
end