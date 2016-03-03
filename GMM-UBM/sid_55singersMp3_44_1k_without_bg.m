clear
clc
load 'result_107singersMp3_20_fold_44.1k_without_bg/gmm_ubm.mat';
for theta =0.07 %0 : 0.01 : 0.1
    %best theta=0.07
    disp('theta:');
    disp(theta);
    %==============true false positve negtive=======
    TP=0;
    TN=0;
    FP=0;
    FN=0;
    %====================likehood mat=================
    likehood_mat=[];
    for ispeaker = [10001 : 10055]
        cepsmat = [];
        files = dir(['dataset/107singersMp3_20_fold_without_bg/', num2str(ispeaker), '/test/*.wav']);
        for ifile = 1 : length(files)
            [d, sr] = wavread(['dataset/107singersMp3_20_fold_without_bg/', num2str(ispeaker), '/test/', files(ifile).name]);
            ceps = melcepst(d, sr, 'M', 12, floor(3*log(sr)), 160);
            for icol = 1 : size(ceps, 2)
                ceps(:, icol) = ceps(:, icol) - mean(ceps(:, icol));
            end
            cepsmat = [cepsmat; ceps];
        end
        topmix = gmmprob_index(gmm_ubm, cepsmat, 32);
        prob_ubm = gmmprob_ntop(gmm_ubm, topmix, cepsmat);
        likelihood = zeros(1, 55);
        for imodel = 10001 : 10055
            load(['result_107singersMp3_20_fold_44.1k_without_bg/gmm_speaker_', num2str(imodel), '.mat']);
            prob_speaker = gmmprob_ntop(gmm_speaker, topmix, cepsmat);
            likelihood(imodel) = prob_speaker - prob_ubm;
            if ispeaker == imodel && likelihood(imodel) >= theta
                TP=TP+1;
            end
            if ispeaker ~= imodel && likelihood(imodel) < theta
                TN=TN+1;
            end
            if ispeaker == imodel && likelihood(imodel) < theta
                FN=FN+1;
            end
            if ispeaker ~= imodel && likelihood(imodel) >= theta
                FP=FP+1;
            end
        end
        [likelihoodmax, speakeridest] = max(likelihood);
        likehood_mat=[likehood_mat;likelihood(10001:10055)];
    end
    %disp('===TTTTTTFFFFFFFPPPPPPPPNNNNNNNNNN====')
    Acc=(TP+TN)/(TP+TN+FP+FN);
    Recall=TP/(TP+FN);
    Precision=TP/(TP+FP);
    disp('Acc:');
    disp(Acc);
    disp('Precision:');
    disp(Precision);
    disp('Recall:');
    disp(Recall);
    disp('F1:');
    disp(2*Precision*Recall/(Precision+Recall));
    %=====================ROC======================
    %answer=eye(19);
    %compute_eer(likelihood_mat,answer,'true');
end
imagesc(likehood_mat);
colorbar;