%
%     Demonstrations for introducting auditory filters
%     DemoAF_Basics
%     Irino, T.
%     Created:  18 Mar 2010
%     Modified: 18 Mar 2010
%     Modified: 11 May 2010 (Figure number)
%     Modified: 27 May 2010 (marker)
%     Modified: 11 Jun 2010 (Figure number)
%     Modified: 25 May 2015 (introduction of SwPrint)
%     Modified: 12 Dec 2017 (introduction of DemoAF_ExcitationPattern)
%     Modified: 21 Jan 2017 (exist('b1') == 0)
%     Modified:   1 Jul  2020  GT&GT impulse response/ freq. responseをここで  plot
%
%
%     Note3 (2017/12/13)
%      DemoAF_ExcitationPatternをDemoAF_Basics中に導入。
%

if exist('b1') == 0,  %　単独で実行する場合用
    %%% Param values from PUI 2003 %%%
    n = 4;
    b1 = 1.81;
    c1 = -2.96;
    b2 = 2.17;
    c2 = 2.20;
    frat0 = 0.466;
    frat1 = 0.0109;
    
    Nrsl = 2^12;
    fs = 44100;
    
end; % exist('b1') == 0,

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf;
%%% Frequnecy dependency %%%%
disp('Figure 1: Frequency response');
fpList = [250 500 1000 2000 4000 8000];
fpXTick = [100 250 500 1000 2000 4000 8000 16000];
ERBNXTick = Freq2ERB(fpXTick);

Ps = 50;
frat = frat0 + frat1*Ps;
for fp = fpList
    fr1 = Fp2toFr1(n,b1,c1,b2,c2,frat,fp);
    cGCresp = CmprsGCFrsp(fr1,fs,n,b1,c1,frat,b2,c2,Nrsl);
    
    cGCFrsp = cGCresp.cGCFrsp;
    cGCFrspdB = 20*log10(cGCFrsp/max(cGCFrsp));
    freq = cGCresp.freq;
    ERBNnum = Freq2ERB(freq);
    
    plot(ERBNnum,cGCFrspdB)
    ax = axis;
    axis([ERBNXTick([1 end]) -70 5]);
    set(gca,'XTick',ERBNXTick);
    set(gca,'XTickLabel',fpXTick);
    hx = xlabel('Frequency (Hz)');
    hy = ylabel('Filter Gain (dB)');
    title('Frequnecy response');
    hold on
end;
drawnow
hold off
DemoAF_PrintFig([DirWork 'DemoAF_Basic_FilterBank'],SwPrint);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2); clf;
%%% Frequnecy dependency %%%%
disp('Figure 2: Center freq. vs. ERB width');
freq = 100:100:12000;
[ERBNnum ERBN] = Freq2ERB(freq);
loglog(freq,ERBN);
axis([50 15000 20 2500]);
xlabel('Center frequency (Hz)');
ylabel('Equivalent Rectangular Bandwidth (Hz)');
title('Center freq. vs. ERB width');
grid on
%set(gca,'Xtick',[50 100 200 500 1000 2000 5000 10000]);
%set(gca,'Xticklabel',[50 100 200 500 1000 2000 5000 10000]);
%set(gca,'Ytick',[20 50 100 200 500 1000 2000]);
%set(gca,'Yticklabel',[20 50 100 200 500 1000 2000]);
drawnow
hold off
DemoAF_PrintFig([DirWork 'DemoAF_Basic_BandWidth'],SwPrint);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3); clf;
Marker = ['o','x','d','*','^','p','s'];
%%% Level dependency %%%%
disp('Figure 3: Filter level dependency');
fp = 2000;
PsList = 30:10:90;
cGCFrspdBMax = [];
cnt = 0;
for Ps = PsList
    cnt = cnt +1;
    frat = frat0 + frat1*Ps;
    fr1 = Fp2toFr1(n,b1,c1,b2,c2,frat,fp);
    cGCresp = CmprsGCFrsp(fr1,fs,n,b1,c1,frat,b2,c2,Nrsl);
    
    cGCFrsp = cGCresp.cGCFrsp;
    if cnt == 1, cGCFrspRef = max(cGCFrsp); end;
    cGCFrspdB = 20*log10(cGCFrsp/cGCFrspRef);
    freq = cGCresp.freq;
    cGCFrspdBMax(cnt) = max(cGCFrspdB);
    
    plot(freq,cGCFrspdB)
    hold on;
    plot(fp,cGCFrspdBMax(cnt),Marker(cnt))
    axis([0 4000 -70 5]);
    set(gca,'XTick',[0:1000:4000]);
    
    text(fp*1.05, cGCFrspdBMax(cnt), int2str(Ps));
    hx = xlabel('Frequency (Hz)');
    hy = ylabel('Filter Gain (dB)');
end;
text(fp*1.15,2.5,'Input Level (dB)');
title('Level-dependent filter shape');
drawnow
hold off
DemoAF_PrintFig([DirWork 'DemoAF_Basic_FilterLevelDepend'],SwPrint);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input Output function %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4); clf;
disp('Figure 4: Input-output function');
OutputLevel = cGCFrspdBMax+PsList+33;
plot(PsList,OutputLevel,PsList,PsList,'--');
hold on
for cnt =1:length(OutputLevel);
    plot(PsList(cnt),OutputLevel(cnt),Marker(cnt));
end;
axis([PsList([1 end]), PsList(1), PsList(end)+5]);
set(gca,'XTick',PsList);
hx = xlabel('Input Level (dB)');
set(gca,'YTick',PsList);
hy = ylabel('Output Level (dB)');
title('Input-Output function');
% legend('IO function','linear line',4);
drawnow
DemoAF_PrintFig([DirWork 'DemoAF_Basic_IOfunc'],SwPrint);

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Exciation Pattern %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5); clf;
disp('Figure 5: Excitation Pattern');
DemoAF_ExcitationPattern
drawnow
DemoAF_PrintFig([DirWork 'DemoAF_Basic_ExcitPattern'],2);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Impulse response of gammatone & gammachirp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6);
disp('Figure 6: Impulse response of GT and GC')
fp = 2000;
fs = 44100;
n = 4;
b = 1.019;   % default Gammatone
cGt = 0;
cGc = -3;
[gt, LenGt] = GammaChirp(fp,fs,n,b,cGt);
gmEnv = GammaChirp(fp,fs,n,b,cGt,0,'envelope');
[gc, LenGc] = GammaChirp(fp,fs,n,b,cGc);
tPl = 8;
nPl = 1:tPl*fs/1000;
tms = (nPl-1)/fs*1000;
bz = 2.5;
gme = [1; -1]*gmEnv(nPl);
plot(tms,gc(nPl)+bz,tms,gt(nPl),'--', ...
    tms,gme,':k', tms,gme+bz,':k',[0 tPl],[ 0, bz; 0, bz],'k');
ax = axis;
axis([0 tPl, -1.2, 3.7]);
set(gca,'YTickLabel',' ');
%grid on
xlabel('Time (ms)');
ylabel('Amplitude (a.u.)');
legend('Gammachirp','Gammatone','Location','East');
title('Impulse Response');
DemoAF_PrintFig([DirWork 'DemoAF_Basic_GTGCimpRsp'],SwPrint);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Frequency response of gammatone & gammachirp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(7);
disp('Figure 7: Fourier spectrum of GT and GC')
Nfrsl = 1024;
[frspGT, freq] = freqz(gt,1,Nfrsl,fs);
[frspGC, freq] = freqz(gc,1,Nfrsl,fs);
GTdB = 20*log10(abs(frspGT));
GTdB = GTdB-max(GTdB);
GCdB = 20*log10(abs(frspGC));
GCdB = GCdB-max(GCdB);
plot(freq,GCdB,freq,GTdB,'--');
axis([0 fp*2, -50, 5]);
legend('Gammachirp','Gammatone');
title('Fourier Spectrum');
xlabel('Frequency (Hz)');
ylabel('Filter Gain (dB)');
DemoAF_PrintFig([DirWork 'DemoAF_Basic_GTGCfreqRsp'],SwPrint);

%%
