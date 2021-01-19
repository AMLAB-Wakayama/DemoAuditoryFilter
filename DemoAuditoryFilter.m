%
%     Demonstrations for introducting auditory filters 
%     Irino, T. 
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 20 Mar 2010
%     Modified: 31 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 11 Apr 2010 (Unicode for MATLAB 2010a)
%     Modified: 11 Jun 2010 (Figure number、strDemo)
%     Modified: 27 Jul 2010 (SwSound, DemoAF_PrintFig)
%     Modified:  3 Sep 2010 (SwEnglish, Note)
%     Modified: 10 Sep 2010 (sound(PlaySnd(:),fs))
%     Modified: 25 May 2015 (sound --> audioplayer+playblocking, MATLAB2013a-)
%     Modified: 25 May 2015 (introduction of SwPrint)
%     Modified: 12 Dec 2017 (introduction of DemoAF_ExcitationPattern)
%     Modified: 28 Mar 2018 (isOctaveの導入)
%     Modified: 28 May 2019 (Octaveで、ShapeEstimationできないため、error出力)
%     Modified: 22 Jun 2019 (DirWork等の操作性の向上) 
%     Modified: 17 Apr 2020 (Win octave でもprintできた。）
%     Modified:  1 Jul 2020  (octaveでoptimizationができるように）
%
%     Note: 
%     このデモは、以下の文献用に書かれたものです。
%     入野,"はじめての聴覚フィルタ",日本音響学会誌, 66巻10号, pp.506-512, 2010.
%     デモの詳細は、本文を参照ください。
%　　　* MATLAB_R2010a用です。
%     * Octaveだとsound関数やplot関係の関数の変更が必要だと思われます。
%      デモ4の中の、fminsearch()も変更が必要らしいです。最小２乗法で解いてください。
%     
%     Note2 (2015/5/25)
%      sound()関数は、すぐ制御を戻してしまい、使い勝手が悪くなりました。
%      そこで、MATLABの最近の仕様に合わせてaudioplayer+playblockingに変更しました。
%      変更は、DemoAF_CriticalBand.m, DemoAF_NotchedNoise.mの中です。
%      MATLAB2013aでの動作は確認済み。
%
%     Note3 (2017/12/13)
%      DemoAF_ExcitationPatternをDemoAF_Basics中に導入。
%
%     Note4 (2018/3/28)
%    isOctave導入。Octaveでの日本語文字化けを避けるため、英語に切り替え。
%
%     Note5 (2019/5/28)
%    fminsearchの整合性がないため、Octaveでフィルタ形状推定ができない。
%    したがって、ノッチ雑音の実験はできるが、このデータはフィルタ形状推定で使えない。
%
%     Note6 (2019/6/22)
%    DirWorkの設定に関して変更。defaultをWin対応にもしたつもり。
%
%     Note7 (2020/7/1)
%     octaveでも動くように改良
%
clear

%  DirWork はこちらで割り当て。 SwDirWorkの選択は削除。 1 Jul 2020
ThisFile = mfilename;  % このプログラムの所在を調べDir1に入れる。
DirFullProg = which(ThisFile);
[Dir1 Name1] = fileparts(DirFullProg);
DirWork = [Dir1 '/Figs/'];
mkdir(DirWork) % 事前にFigsというdirectoryを作っておく必要あり。
chdir(Dir1); % プログラムのDirectoryに強制移動
disp(['図面やデータ等は： ' DirWork 'に出力／保存されます。']);


SwEnglish = 0;  % Japanese    日本語 (default)
SwEnglish = 1; % English     英語

isOctave = 0;
NameRsltNN = [DirWork 'DemoAF_RsltNN.mat']; 
if exist('OCTAVE_VERSION') == 5,  % Octaveなら１になる。
    isOctave =1;
    NameRsltNN = [DirWork 'DemoAF_RsltNN_octave.mat'];  % mat形式が異なるため。
    SwEnglish = 1; % Octaveだと英語に
end;


%SwSound = 0;   % No sound playback for　lecture demonstration　教室デモ用
SwSound = 1;  % playback sound (default)

% SwPrint = 0; % No print. e.g. when there is trouble with MATLAB2015a.
SwPrint = 1;

if SwEnglish == 0,
  strDemo0 = 'デモ:';
  strDemo(1) = {'  1) 聴覚フィルタの基礎'};
  strDemo(2) = {'  2) 臨界帯域幅'};
  strDemo(3) = {'  3) ノッチ雑音マスキング法'};
  strDemo(4) = {'  4) 聴覚フィルタ形状推定'};
  strDemoQ = 'デモ番号の選択 >>';

else    
  strDemo0 ='Demo:';
  strDemo(1) = {'  1) Auditory filter basics'};
  strDemo(2) = {'  2) Critical band'};
  strDemo(3) = {'  3) Notched noise masking'};
  strDemo(4) = {'  4) Estimation of filter shape'};
  strDemoQ ='Select demo number >> ';
end;

disp(strDemo0);
for nd =1:4,
    disp(char(strDemo(nd)));
end;
SwDemo = input(strDemoQ);
if length(SwDemo) == 0, SwDemo = 1; end;
 
disp(' ');
disp(['===  ' strDemo0  char(strDemo(SwDemo)) '  ===']);

%%
switch SwDemo
  case 1,
    close all
    DemoAF_Basics
 
  case 2,
    DemoAF_CriticalBand
   % Responses for ASJ review Fig.4 : 12 8 8 8 9 10 

  case 3,
    DemoAF_NotchedNoise
    % Responses for ASJ review Fig. 6 : 13 5 6 8 10 11 12 
    %%% save the result for filer-shape estimation in case 4
    str = ['save ' NameRsltNN ' ProbeLevel ParamNN ' ];
    eval(str);
 
 case 4,
    if exist(NameRsltNN) == 0,
        disp('No experimental data exists. Execute 3) first.');
    end;
    %%% load the result of exp. notched noise in case 3
    DemoAF_ShapeEstimation
           
end;

disp(' ');

