cepsmat = [];
for ispeaker = 10001 : 10020    
    files = dir(['dataset/50_fold_artist20_whithout_bg/', num2str(ispeaker), '/train/*.wav']);
    
    for ifile = 1 : length(files)
        wavfile=['dataset/50_fold_artist20_whithout_bg/', num2str(ispeaker), '/train/', files(ifile).name];       
        [d, sr] = wavread(wavfile);
        disp(wavfile);
        disp('wavfile======up===ing==');
        ceps = melcepst(d, sr, 'M', 12, floor(3*log(sr)),160);
        for icol = 1 : size(ceps, 2)
            ceps(:, icol) = ceps(:, icol) - mean(ceps(:, icol));
        end
        cepsmat = [cepsmat; ceps];
    end
end

save('result/cepsmat_ubm.mat', 'cepsmat');

gmm_ubm = gmm(size(cepsmat, 2), 32, 'diag');
options = zeros(1, 18);
options(3) = 1e-10;
options(14) = 20;
gmm_ubm = gmmem(gmm_ubm, cepsmat, options);

save('result/gmm_ubm.mat', 'gmm_ubm');
