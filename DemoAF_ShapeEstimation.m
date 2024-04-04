%
%     Demonstrations for introducting auditory filters
%     DemoAF_ShapeEstimation
%     Estimation of Auditory filter frequency response
%     Irino, T.
%     Created:  16 Mar 2010
%     Modified: 16 Mar 2010
%     Modified: 11 May 2010
%     Modified: 21 May 2010
%     Modified: 11 Jun 2010 (Figure number)
%     Modified: 14 Jun 2010 (Gammatone & Gammachirp)
%     Modified: 25 Jun 2010 (Fig. 12)
%     Modified: 25 May 2015 (introduction of SwPrint)
%     Modified:  1 Jul 2020  (octaveでoptimizationができるように）
%
%     


%% %% 
   str = ['load ' NameRsltNN ];
   eval(str);

   Nrsl = 2^12;
   ParamNN.Nrsl = Nrsl;   %  このパラメータ matの中に必要
   str = ['save ' NameRsltNN ' ProbeLevel ParamNN ' ]; % 再度 save
   eval(str);

   b_init  = 1.019; 
   K_init  = 4; 
   [frsp_init, freq] = GammaChirpFrsp(ParamNN.fp,ParamNN.fs,4,...
                                      b_init,0,0,ParamNN.Nrsl);
%% optimization
   ParamOpt = [b_init K_init];
  % [ParamOpt, fval] = fminsearch(@DemoAF_PowerSpecModel,...
   %                               ParamOpt,[],ParamNN,ProbeLevel);
   [ParamOpt, fval] = fminsearch(@DemoAF_PowerSpecModel_Load,ParamOpt);
   
   
   b_opt = ParamOpt(1);
   K_opt = ParamOpt(2);
  
   str1 = ['b = ' num2str(b_opt,3) ', K = ' num2str(K_opt,3)];
   str2 = ['RMS error = ' num2str(fval,3) ' (dB)'];

   if SwEnglish == 0,
     disp(['推定結果']);
     disp(['パラメータ値: ', str1]);
     disp(['推定誤差: ', str2]);
   else
     disp(['Estimation Result']);
     disp(['Parameter values: ' str1]);
     disp([ str2]);
   end;       

%% % plot results
   [frsp_opt,  freq] = GammaChirpFrsp(ParamNN.fp,ParamNN.fs,4,...
                                      b_opt,0,0,ParamNN.Nrsl);

   figure(13)
   disp('Figure 13: Estimated filter shape')
   plot(freq, 20*log10(abs(frsp_opt) /max(abs(frsp_opt))), ...
        freq, 20*log10(abs(frsp_init)/max(abs(frsp_init))), '--')
   xlabel('Frequency (Hz)');
   ylabel('Filter Gain (dB)');
   legend('Estimated GT','Default GT');
   axis([0, ParamNN.fp*2, -50 5]);
   DemoAF_PrintFig([DirWork 'DemoAF_Exp_NotchNoiseGTestim'],SwPrint);
   pause(1)
   
   
%% % plot Estimation points
   figure(14)
   disp('Figure 14: Result and Prediction')  
   [ErrorVal] = DemoAF_PowerSpecModel(ParamOpt,ParamNN,ProbeLevel,1);

   plot(ParamNN.FreqNotchWidth,ProbeLevel,'*-',...
        ParamNN.FreqNotchWidth,ProbeLevel - ErrorVal,'ro');
   legend('Measured level','Model prediction');
   xlabel('Notch bandwidth (Hz)');   
   ylabel('Degree of masking (dB)');
   grid on;
   DemoAF_PrintFig([DirWork 'DemoAF_Exp_NotchNoiseThreshGTestim'],SwPrint);
   

   

