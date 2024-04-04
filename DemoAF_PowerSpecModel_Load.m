%
%     Demonstrations for introducting auditory filters
%     DemoAF_PowerSpecModel
%     Error from Power Spectral model of masking
%     Irino, T.
%     Created:  16 Mar 2010
%     Modified: 16 Mar 2010
%     Modified: 12 May 2010
%     Modified: 1 Jul 2020   % for octave, Load ParamNN&ProbeLevel 
%
%     
function ErrorVal = DemoAF_PowerSpecModel_Load(ParamOpt);

   %  if nargin < 4, SwRslt = 0; end;
   SwRslt = 0;
   DirWork = ['./Figs/']; % current directory/Figs/
   NameRsltNN = [DirWork 'DemoAF_RsltNN.mat']; 
   if exist('OCTAVE_VERSION') == 5, %  isOctave = 1; end; % Octaveなら１になる。
    NameRsltNN = [DirWork 'DemoAF_RsltNN_octave.mat'];  % mat形式が異なるため。
   end;


   str = ['load ' NameRsltNN ];
   eval(str);

    b = ParamOpt(1);
    K = ParamOpt(2); % efficiency K (dB)
    [frsp, freq] = ...
      GammaChirpFrsp(ParamNN.fp,ParamNN.fs,4,b,0,0,ParamNN.Nrsl);
    WeightFunc = abs(frsp).^2;
    WeightFunc = WeightFunc/max(WeightFunc);
    dF = mean(diff(freq));
  
   ErrorVal = [];
   for npl = 1:length(ProbeLevel)
       nLowBPN = find(freq >= ParamNN.FreqLowMin(npl) & ...
                      freq <= ParamNN.FreqLowMax(npl));
       nUppBPN = find(freq >= ParamNN.FreqUppMin(npl) & ...
                      freq <= ParamNN.FreqUppMax(npl));
       IntgrMask  = sum(WeightFunc([nLowBPN nUppBPN]))*dF;
       ErrorVal(npl) = ProbeLevel(npl) - (10*log10(IntgrMask)+ParamNN.N0+K);
   end;

   if SwRslt == 0,  % when optimization
     ErrorVal = sqrt(mean(ErrorVal.^2));
   end;

%%
