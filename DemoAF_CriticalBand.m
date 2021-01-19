%
%     Demonstrations for introducting auditory filters
%     DemoAF_CriticalBand
%     Irino, T.
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 11 Mar 2010
%     Modified: 16 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 11 Apr 2010
%     Modified: 10 May 2010 (Unicode for MATLAB 2010a)
%     Modified: 27 May 2010
%     Modified: 11 Jun 2010 (Figure number)
%     Modified: 25 May 2015 (sound --> audioplayer+playblocking, MATLAB2013a-)
%     Modified: 25 May 2015 (introduction of SwPrint)
%     Modified:  1 Jul 2020  (octaveでoptimizationができるように）
%     Modified:  2 Jul 2020  (debug, StrAns）
%
%     Reference:
%     Houtsma, A.J.M., Rossing, T.D., Wagenaars, W.M.,
%     "Auditory Demostrations," p.10, IPO/ASA CD, Philips, 1126-061,
%     Sept., 1987.
%
%
%

DemoAF_MkProbeTone

%% %% PlaySnd with/without Masking noise
%%   bwList = [4000, 1000, 250, 100, 10, 5];
bwList = [0 4000, 1000, 250, 100, 10];

for nBW = 1:length(bwList)
    
    if nBW == 1, % no masking noise
        disp(' ');
        if SwEnglish == 0,
            disp('５dBずつ減衰するプローブ音系列を２回再生します。');
            disp('何個聞こえるか答えてください。');
        else
            disp('You will hear 2000-Hz tone in several descreasing steps of 5 dBs. ');
            disp('Count how many steps you can hear.');
            disp('Series are presented twice.');
        end;
        PlaySnd = pipStair;
    else  % with masking noise
        disp(['------------------------']);
        if nBW == 2,
            if SwEnglish == 0,
                disp('次に帯域雑音を重畳します。');
                disp('帯域雑音の種類ごとに,何個聞こえるか答えてください。');
                % making Bandpass noise and playback together
            else
                disp('Now the signal is masked with bandpass noise.');
                disp('How many steps can you hear? ');
            end;
        end;
        
        bw = bwList(nBW);
        BPN = [];
        if SwEnglish == 0,
            disp(['帯域幅 ' int2str(bw) ' (Hz)']);
        else
            disp(['Bandwidth: ' int2str(bw) ' (Hz)']);
        end;
        AmpBPN = AmpPip*0.2;
        fBand = [ max(0,fp-bw/2),  fp+bw/2];
        BPN = MkBPNoise(fs,fBand,length(pipStair)/fs*1000); % in ms
        PlaySnd = AmpBPN*BPN + pipStair;
        if max(abs(PlaySnd))> 1
            error('Sound amp. exceeds the limit (1.0).');
        end;
        
    end;
    
    
    %%   %% Playback & collect response
    NumFig = 11;
    StrAns ='Steps >> '; % default for SwSound == 0
    if SwSound == 1,
        if SwEnglish == 0,
            kk = input('リターンで再生開始 >> ');
            disp(['再生中...　　（Figure ' int2str(NumFig) ' にスペクトル表示中）']);
            StrAns ='聞こえた数 >> ';
        else
            kk = input('Start by return >> ');
            disp(['Playing now...     (Spectrum is shown in Figure ' int2str(NumFig) '.)']);
            StrAns ='Steps >> ';
        end;
    end; %  if SwSound == 1,
    
    % %% plot Spectrogram of the initial part
    figure(NumFig); clf;
    Nrsl = 2^16;
    [frsp, freq] = freqz(PlaySnd(1:Nrsl),1,Nrsl,fs);
    plot(freq,20*log10(abs(frsp)));
    axis([0, fp*2.5, -20 80]);
    xlabel('Frequency (Hz)');
    ylabel('Level (dB)');
    drawnow
    
    if SwSound == 1,
        % Play sound
        ap = audioplayer(PlaySnd(:),fs);
        playblocking(ap);
    else
        pause(3);
    end;
    close(NumFig);
    
    % response collection
    rsp = [];
    while length(rsp) == 0,
        rsp     = input(StrAns);
    end;
    Resp1(nBW) = rsp;
    disp(' ');
    disp(' ');
    
end;   %   for nb = 0:length(bwList)

%%
figure(10); clf;
disp('Figure 10: Result')
[frList nsort]  = sort(bwList); % sort order
RespPl = (Resp1(nsort) - Resp1(1))*(-5); % relative level from no masker
frListPl = [frList.^(0.3)]; % only for plot purpose. non-linear axis

plot(frListPl,RespPl,'*-');
set(gca,'Xtick',frListPl);
set(gca,'XtickLabel',frList);
ax = axis;
axis([ax(1:2), ax(3), ax(4)+5]);
xlabel('Noise bandwidth (Hz)');
ylabel('Degree of masking (dB)');
grid on;

DemoAF_PrintFig([DirWork 'DemoAF_Exp_CriticalBandThresh'],SwPrint);

