%
%     Demonstrations for introducting auditory filters
%     DemoAF_Excitation Pattern
%     Irino, T.
%     Created:  13 Dec 2017
%     Modified: 13 Dec 2017
%     Modified: 25 Dec 2017
%     Modified: 12 Ayg 2018 (EP, panel (a)-(f))
%
%     
%

if exist('b1') == 0
    %　DemoAF_Basics.mから通常呼ばれるのでここは不要。
    %　ただ、このプログラムを単独でも動かせるように。
    %
    
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
end;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Frequnecy dependency %%%%
%disp('Figure: Excitation Pattern');
FreqRange = [100 6000];
ERBRange = Freq2ERB(FreqRange);
NumCh = 100;
ERBpList = linspace(ERBRange(1),ERBRange(2),NumCh);
fpList = ERB2Freq(ERBpList);

%StrPanel = {' ',' ',' ',' ',' ',' '}; %Panelの区分表示なしの場合

StrPanel = {'(a)','(b)','(c)','(d)','(e)','(f)'};

for SwMasker = 1:2
    
    if SwMasker == 1,
        fmasker = 1000;
        PsList = [40 60 80];
        PeakValdB = [67.6  73.4  82.9];
        % IO function  DemoAF_Basics
        % Ps   30    40    50    60    70    80    90
        % Max  63.0000   67.5770   70.8027   73.4346   77.0846   82.9002   90.3385
    else
        fmasker = [200:200:2000];
        PsList    = 70;
        PeakValdB =77.08;
        
        % for check EP   21 Dec 17
        %      fmasker = [100:50:6000];
        %     PsList    = 50;
        %      PeakValdB =70;
    end;


    %% plot freq resp
    nPanel = 1+(SwMasker-1);
    subplot(3,2,nPanel);
    plot([1;1]*fmasker/1000, [0 PsList(end)],'b-');
    xlabel('Frequency (kHz)');
    ylabel('Sound Level (dB)');
    text(fpList(end)/1000*0.87,85,StrPanel(nPanel));
    axis([0, fpList(end)/1000, 40, 90]);
    set(gca,'XTick',[0:10]);

    %% plot Excitation Pattern
   for nPs = 1:length(PsList)
     Ps = PsList(nPs);
    frat = frat0 + frat1*Ps;
    EP = zeros(size(fpList));
    for nfp = 1:length(fpList)
        fp = fpList(nfp);
        fr1 = Fp2toFr1(n,b1,c1,b2,c2,frat,fp); 
        cGCresp = CmprsGCFrsp(fr1,fs,n,b1,c1,frat,b2,c2,Nrsl);

        cGCFrsp = cGCresp.cGCFrsp/max(abs(cGCresp.cGCFrsp));
        % cGCFrspdB = 20*log10(cGCFrsp/max(cGCFrsp));
        freq = cGCresp.freq;
        ERBNnum = Freq2ERB(freq);
        for nfm = 1:length(fmasker)
            [Val, nFatMasker] = min(abs(freq-fmasker(nfm)));
            EP(nfp) = EP(nfp)+cGCFrsp(nFatMasker).^2;
        end;
    end;
 
    % Excition Pattern on ERB_N
    nPanel = 3+(SwMasker-1);
    subplot(3,2,nPanel);
    EPdB = 10*log10(EP) + PeakValdB(nPs);
    plot(ERBpList,EPdB,'b-')
    text(ERBpList(end)*0.87,85,StrPanel(nPanel));
    axis([ERBpList([1 end]),40,90]);
    set(gca,'XTick',[5:5:35]);
    hx = xlabel('ERB_N number');
    hy = ylabel('Excitation Level(dB)');
    hold on
    if SwMasker == 1,
        [nEPdB] = min(find(EPdB<Ps/4+35 & ERBpList >15));
        text(ERBpList(nEPdB),EPdB(nEPdB)+2,[int2str(Ps)]);
    end;
    
    % Excition Pattern on frequency, kHz
    nPanel = 5+(SwMasker-1);
    subplot(3,2,nPanel);
    plot(fpList/1000,EPdB,'b-')
    text(fpList(end)/1000*0.87,85,StrPanel(nPanel));
    axis([0, fpList(end)/1000,40,90]);
    set(gca,'XTick',0:10);
    hx = xlabel('Frequency (kHz)');
    hy = ylabel('Excitation Level(dB)');
    if SwMasker == 1,
        text(fpList(nEPdB)/1000,EPdB(nEPdB)+2,[int2str(Ps)]);
    end;
 
    hold on
end; % for Ps = PsList

end; % for SwMasker = 1:2
drawnow
    
