%% addpath
clear all; close all; 
addpath('bss_eval');
addpath('example');

addpath(genpath('inexact_alm_rpca'));

%% Examples
fid = fopen('dataset_dir_list.txt');
while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    filename =  native2unicode(tline);
    wavinA= wavread(['example/',filename]);
    wavinE= wavread(['example/',filename]);   
    wavlength=length(wavinA);    
    [wavinmix,Fs]= wavread(['example/',filename]);   
    %% GNSDR computation
    [e1,e2,e3] = bss_decomp_gain( wavinmix', 1, wavinE');
    [sdr_,sir_,sar_] = bss_crit( e1, e2, e3);

    %% Run RPCA
   [path,name,ext]=fileparts(filename)
    parm.outname=['example' filesep 'output' filesep path filesep name];
   
    
    disp(parm.outname)
    disp('===============================')
    outdir=['example' filesep 'output' filesep path]
    if exist(outdir)==0
        mkdir(outdir)
    end
    parm.lambda=1;
    parm.nFFT=1024;
    parm.windowsize=1024;
    parm.masktype=1; %1: binary mask, 2: no mask
    parm.gain=1;
    parm.power=1;
    parm.fs=Fs;

    Parms=rpca_mask_fun(wavinA,wavinE,wavinmix,parm); % SDR(\hat(v),v),                    

    %% NSDR=SDR(estimated voice, voice)-SDR(mixture, voice)
    NSDR=Parms.SDR-sdr_;                               
    %%                               
    fprintf('SDR:%f\nSIR:%f\nSAR:%f\nNSDR:%f\n',Parms.SDR,Parms.SIR,Parms.SAR,NSDR);
end
fclose(fid);