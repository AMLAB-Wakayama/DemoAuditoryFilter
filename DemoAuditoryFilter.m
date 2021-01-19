%
%     Demonstrations for introducting auditory filters 
%     Irino, T. 
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 20 Mar 2010
%     Modified: 31 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 11 Apr 2010 (Unicode for MATLAB 2010a)
%     Modified: 11 Jun 2010 (Figure number�AstrDemo)
%     Modified: 27 Jul 2010 (SwSound, DemoAF_PrintFig)
%     Modified:  3 Sep 2010 (SwEnglish, Note)
%     Modified: 10 Sep 2010 (sound(PlaySnd(:),fs))
%     Modified: 25 May 2015 (sound --> audioplayer+playblocking, MATLAB2013a-)
%     Modified: 25 May 2015 (introduction of SwPrint)
%     Modified: 12 Dec 2017 (introduction of DemoAF_ExcitationPattern)
%     Modified: 28 Mar 2018 (isOctave�̓���)
%     Modified: 28 May 2019 (Octave�ŁAShapeEstimation�ł��Ȃ����߁Aerror�o��)
%     Modified: 22 Jun 2019 (DirWork���̑��쐫�̌���) 
%     Modified: 17 Apr 2020 (Win octave �ł�print�ł����B�j
%     Modified:  1 Jul 2020  (octave��optimization���ł���悤�Ɂj
%
%     Note: 
%     ���̃f���́A�ȉ��̕����p�ɏ����ꂽ���̂ł��B
%     ����,"�͂��߂Ă̒��o�t�B���^",���{�����w�, 66��10��, pp.506-512, 2010.
%     �f���̏ڍׂ́A�{�����Q�Ƃ��������B
%�@�@�@* MATLAB_R2010a�p�ł��B
%     * Octave����sound�֐���plot�֌W�̊֐��̕ύX���K�v���Ǝv���܂��B
%      �f��4�̒��́Afminsearch()���ύX���K�v�炵���ł��B�ŏ��Q��@�ŉ����Ă��������B
%     
%     Note2 (2015/5/25)
%      sound()�֐��́A���������߂��Ă��܂��A�g�����肪�����Ȃ�܂����B
%      �����ŁAMATLAB�̍ŋ߂̎d�l�ɍ��킹��audioplayer+playblocking�ɕύX���܂����B
%      �ύX�́ADemoAF_CriticalBand.m, DemoAF_NotchedNoise.m�̒��ł��B
%      MATLAB2013a�ł̓���͊m�F�ς݁B
%
%     Note3 (2017/12/13)
%      DemoAF_ExcitationPattern��DemoAF_Basics���ɓ����B
%
%     Note4 (2018/3/28)
%    isOctave�����BOctave�ł̓��{�ꕶ������������邽�߁A�p��ɐ؂�ւ��B
%
%     Note5 (2019/5/28)
%    fminsearch�̐��������Ȃ����߁AOctave�Ńt�B���^�`�󐄒肪�ł��Ȃ��B
%    ���������āA�m�b�`�G���̎����͂ł��邪�A���̃f�[�^�̓t�B���^�`�󐄒�Ŏg���Ȃ��B
%
%     Note6 (2019/6/22)
%    DirWork�̐ݒ�Ɋւ��ĕύX�Bdefault��Win�Ή��ɂ���������B
%
%     Note7 (2020/7/1)
%     octave�ł������悤�ɉ���
%
clear

%  DirWork �͂�����Ŋ��蓖�āB SwDirWork�̑I���͍폜�B 1 Jul 2020
ThisFile = mfilename;  % ���̃v���O�����̏��݂𒲂�Dir1�ɓ����B
DirFullProg = which(ThisFile);
[Dir1 Name1] = fileparts(DirFullProg);
DirWork = [Dir1 '/Figs/'];
mkdir(DirWork) % ���O��Figs�Ƃ���directory������Ă����K�v����B
chdir(Dir1); % �v���O������Directory�ɋ����ړ�
disp(['�}�ʂ�f�[�^���́F ' DirWork '�ɏo�́^�ۑ�����܂��B']);


SwEnglish = 0;  % Japanese    ���{�� (default)
SwEnglish = 1; % English     �p��

isOctave = 0;
NameRsltNN = [DirWork 'DemoAF_RsltNN.mat']; 
if exist('OCTAVE_VERSION') == 5,  % Octave�Ȃ�P�ɂȂ�B
    isOctave =1;
    NameRsltNN = [DirWork 'DemoAF_RsltNN_octave.mat'];  % mat�`�����قȂ邽�߁B
    SwEnglish = 1; % Octave���Ɖp���
end;


%SwSound = 0;   % No sound playback for�@lecture demonstration�@�����f���p
SwSound = 1;  % playback sound (default)

% SwPrint = 0; % No print. e.g. when there is trouble with MATLAB2015a.
SwPrint = 1;

if SwEnglish == 0,
  strDemo0 = '�f��:';
  strDemo(1) = {'  1) ���o�t�B���^�̊�b'};
  strDemo(2) = {'  2) �ՊE�ш敝'};
  strDemo(3) = {'  3) �m�b�`�G���}�X�L���O�@'};
  strDemo(4) = {'  4) ���o�t�B���^�`�󐄒�'};
  strDemoQ = '�f���ԍ��̑I�� >>';

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

