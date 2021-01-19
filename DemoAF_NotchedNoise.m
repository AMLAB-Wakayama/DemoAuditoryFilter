%
%     Demonstrations for introducting auditory filters
%     DemoAF_NotchedNoise
%     Irino, T.
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 11 Mar 2010
%     Modified: 16 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 10 May 2010 (Unicode)
%     Modified: 11 Jun 2010 (Figure number)
%     Modified: 25 May 2015 (sound --> audioplayer+playblocking, MATLAB2013a-)
%     Modified: 25 May 2015 (introduction of SwPrint)
%     Modified:  1 Jul 2020  (octave��optimization���ł���悤�Ɂj
%     Modified:  2 Jul 2020  (debug, StrAns�j
%
%
%

DemoAF_MkProbeTone

%% Parameter settings
ParamNN.fs = fs;
ParamNN.fp = fp;
ParamNN.FreqBand   = 0.4*fp;
ParamNN.FreqLowMax = [1:-0.1:0.5]*fp;
ParamNN.FreqLowMin = ParamNN.FreqLowMax-ParamNN.FreqBand;
ParamNN.FreqUppMin = [1:0.1:1.5]*fp;
ParamNN.FreqUppMax = ParamNN.FreqUppMin+ParamNN.FreqBand;
ParamNN.FreqNotchWidth = ParamNN.FreqUppMin-ParamNN.FreqLowMax;

%% Note: The following setting depends on your audio settings.
%% These are dummy values for Demonstration purpose.
ParamNN.N0         = 40;  % Noise level.  it is dummy value!
ParamNN.FloorLevel = 30;  % Dummy floor level for consistency.


%% %% PlaySnd with/without Masking noise

for nb = 0:length(ParamNN.FreqLowMax)
    if nb == 0, % no masking noise
        disp(' ');
        if SwEnglish == 0,
            disp('�TdB����������v���[�u���n����Q��Đ����܂��B');
            disp('���������邩�����Ă��������B');
        else
            disp('You will hear 2000-Hz tone in several descreasing steps of 5 dBs.');
            disp('Count how many steps you can hear.');
            disp('Series are presented twice.');
        end;
        
        PlaySnd = pipStair;
        numResp = length(ParamNN.FreqLowMax)+1;
        
    else
        disp(['------------------------']);
        if nb == 1,
            if SwEnglish == 0,
                disp('���Ƀm�b�`�G�����d�􂵂܂��B');
                disp('�m�b�`�G���̎�ނ��Ƃ�,���������邩�����Ă��������B');
            else
                disp('Now the signal is masked with notched noise.');
                disp('How many steps can you hear?');
            end;
        end;
        
        BPN1 = [];
        BPN2 = [];
        if SwEnglish == 0,
            disp(['�m�b�`�� ' int2str(ParamNN.FreqNotchWidth(nb)) ...
                '(Hz)']);
        else
            disp(['Notch width: ' int2str(ParamNN.FreqNotchWidth(nb)) ...
                '(Hz)']);
        end;
        
        % making Bandpass noise and playback together
        AmpBPN = AmpPip;
        fBand1 = [ParamNN.FreqLowMin(nb), ParamNN.FreqLowMax(nb)];
        BPN1 = MkBPNoise(fs,fBand1,length(pipStair)/fs*1000); % in ms
        fBand2 = [ParamNN.FreqUppMin(nb), ParamNN.FreqUppMax(nb)];
        BPN2 = MkBPNoise(fs,fBand2,length(pipStair)/fs*1000); % in ms
        
        PlaySnd = AmpBPN*(BPN1+BPN2) + pipStair;
        if max(abs(PlaySnd))> 1
            error('Sound amp. exceeds the limit (1.0).');
        end;
        numResp = nb;
    end;
    
    
    %%   %% Playback & collect response
    NumFig = 11;
    StrAns ='Steps >> '; % default for SwSound == 0
    if SwSound == 1,
        if SwEnglish == 0,
            kk = input('���^�[���ōĐ��J�n >> ');
            disp(['�Đ���...�@�@�iFigure ' int2str(NumFig) ' �ɃX�y�N�g���\�����j']);
            StrAns ='���������� >> ';
        else
            kk = input('Start by return >> ');
            disp(['Playing now...     (Spectrum is shown in Figure ' int2str(NumFig) '.)']);
            StrAns ='Steps >> ';
        end;
    end; %  if SwSound == 1,
    
    % %% plot Spectrogram of the initial part
    figure(NumFig);
    Nrsl = 2^16;
    [frsp, freq] = freqz(PlaySnd(1:Nrsl),1,Nrsl,fs);
    plot(freq,20*log10(abs(frsp)));
    axis([0, fp*2.5, -40 80]);
    axis([0, fp*2.5, -20 80]);
    xlabel('Frequency (Hz)');
    ylabel('Level (dB)');
    drawnow
    
    if SwSound == 1,
        % obsolete   sound(PlaySnd(:),fs);
        ap = audioplayer(PlaySnd(:),fs);
        playblocking(ap);
    else
        pause(3);
    end;
    close(NumFig);
    
    % response collection
    rsp = [];
    while length(rsp) == 0,
        rsp = input(StrAns);
    end;
    Resp1(numResp) = rsp;
    disp(' ');
    disp(' ');
    
end;   %  for nb = 0:length(ParamNN.FreqLowMax)

%% %% plot notchwidth vs. ProbeLevel
figure(12);
disp('Figure 12: Result')
ProbeLevel = (Resp1(1:length(ParamNN.FreqNotchWidth)) - Resp1(end))*(-5);
ProbeLevel = ProbeLevel + ParamNN.FloorLevel;
plot(ParamNN.FreqNotchWidth,ProbeLevel,'*-');
xlabel('Notch bandwidth (Hz)');
ylabel('Degree of masking (dB)');
ax = axis;
axis([ax(1:2), ax(3)-5, ax(4)+5]);
grid on;

DemoAF_PrintFig([DirWork 'DemoAF_Exp_NotchNoiseThreshMeaure'],SwPrint);

