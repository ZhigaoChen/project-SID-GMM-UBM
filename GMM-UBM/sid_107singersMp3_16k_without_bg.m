clear
clc
load 'result_107singersMp3_20_fold_16k_without_bg/gmm_ubm.mat';
for theta =0.07% 0 : 0.01 : 0.1
    %best theta=0.07
    disp('theta:');
    disp(theta);
    miss = 0;
    falsepos = 0;
    correct = 0;
    %==============true false positve negtive=======
    TP=0;
    TN=0;
    FP=0;
    FN=0;
    %====================likehood mat=================
    likehood_mat=[];
    for ispeaker = [10001 : 10107]
        cepsmat = [];
        files = dir(['dataset/107singersMp3_20_fold_16k_without_bg/', num2str(ispeaker), '/test/*.wav']);
        for ifile = 1 : length(files)
            [d, sr] = wavread(['dataset/107singersMp3_20_fold_16k_without_bg/', num2str(ispeaker), '/test/', files(ifile).name]);
            ceps = melcepst(d, sr, 'M', 12, floor(3*log(sr)), 160);
            for icol = 1 : size(ceps, 2)
                ceps(:, icol) = ceps(:, icol) - mean(ceps(:, icol));
            end
            cepsmat = [cepsmat; ceps];
        end
        topmix = gmmprob_index(gmm_ubm, cepsmat, 32);
        prob_ubm = gmmprob_ntop(gmm_ubm, topmix, cepsmat);
        likelihood = zeros(1, 107);
        for imodel = 10001 : 10107
            %disp('imodel====================');
            %disp(imodel);
            load(['result_107singersMp3_20_fold_16k_without_bg/gmm_speaker_', num2str(imodel), '.mat']);
            prob_speaker = gmmprob_ntop(gmm_speaker, topmix, cepsmat);
            %disp('==========prob_speaker');
            %disp(prob_speaker);
            likelihood(imodel) = prob_speaker - prob_ubm;
            %disp('likelihood===================');
            %disp(likelihood(imodel));
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
            if ispeaker == imodel && likelihood(imodel) < theta
                miss = miss + 1;
                %disp('miss=======below============');
                %disp(ispeaker);
                %disp('=======================');
                %disp(miss);
            end
            if ispeaker ~= imodel && likelihood(imodel) >= theta
                falsepos = falsepos + 1;
                %disp('false ispeaker============is below');
                %disp(imodel);
                %disp('falsepos===================');
                %disp(falsepos);
            end
        end
        misstate = miss/107;
        %disp(misstate);
        %disp('misstate===================');
        falseposrate = falsepos/321 ;
        %disp('falseposrate===================');
        %disp(falseposrate);
        [likelihoodmax, speakeridest] = max(likelihood);
        %disp('now ispeaker is  below===========**********');
        %disp(ispeaker);
        %disp('likehood is below==========');
        %disp(likelihood(10001:10107));
        %disp('maxlikelihood speakeridest is below=========*********');
        likehood_mat=[likehood_mat;likelihood(10001:10107)];
        %disp(speakeridest);
        if ispeaker ~= speakeridest && likelihoodmax < theta
            correct = correct + 1;
            %disp(ispeaker);
        end
        if speakeridest == ispeaker && likelihoodmax >= theta
            correct = correct + 1;
            %disp(ispeaker);
            %disp(correct);
        end
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