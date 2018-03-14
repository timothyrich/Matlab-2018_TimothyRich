function Traditional_extinction_with_blocks_3_12_18
% Based on Word1 by JP (November 2017)
% Modified by JP and TJR in January-March 2018

% Task is to read a single word presented to the left or the right of
% central fixation. Four conditions: left solitary, right solitary, 
% bilateral left distractor, bilateral right distractor. Experiment
% operator types the subject's response after each trial (must by typed in
% all caps).

% Required Files, Toolboxes, and locally written subroutines
% Developed under MacOS 10.6.8 and Matlab R2012a (64 bit)
% Psychtoolbox 3.0.11 and associated Eyelink toolbox  
% EX routines dated 6/29/15 or later from Palmer lab
% CC routines dated 11/20/17 or later from Palmer lab
% EL routines dated 9/5/14 or later from Palmer lab
% EyelinkGetKey as modified by JP for multiple keyboards (see EL routine folder)
% Requires a calibration file in the Palmer lab style (e.g. 'VS95_090214.cal')
% To use eyelink needs SR Research's "Eyelink Developers Kit for the Mac OS X"

filename = EXAskFilename('Data file name?','data.mat','.mat',8);

% TO OVERRIDE SYNCHRONIZATION FAILURE
Screen('Preference','SkipSyncTests',1);

try 
    
% key parameters
os.SetResolution = 0;                               % define initially to help try-catch
h.LabMonitor = 0;                                   % set to 1 for lab, 0 otherwise
h.contrast = .015;                                  % contrast .01 to 1 
h.contrastAlt = .025;                               % alternate contrast, just in case
h.duration = 0.06;                                  % stimulus duration (min==.02)
h.FontSize = 24;                                    % font size in "points" 
h.spacingDeg = 2;                                   % spacing of words from center (deg)

s.conditions = [1 2 3 4];                           % 1. Left solitary
                                                    % 2. Right solitary
                                                    % 3. Bilateral left target
                                                    % 4. Bilateral right target
% s.conditions = 1;                                 % for debugging a single condition
h.ncond = length(s.conditions);                     % calc number of conditions
h.nblocks = 3;                                      % number of blocks (3-4 mins/block)
h.ntrials = 4;                                      % number of trials (multiple of ncond)

% initialize other variables, graphics, etc
[h, cal, window, os, s] = Initialize(h,s);

% prompt and wait for keypress to start
DrawMyText(window,'Press any key to start',0,0,cal.white);
Screen(window,'Flip');                 	 
while KbCheck(-3) == 0; end                         % wait until a key is pressed.
Screen(window,'Flip');                 	

% counterbalance main conditions using index vector
conditionindex = EXBalance1(h.ntrials,h.ncond);

% define sizes of relevant vectors for data output
response = zeros(h.ntrials,1);        
leftindex = zeros(h.ntrials,1);              
rightindex = zeros(h.ntrials,1);
mystring = cell(h.ntrials,1);
myword = cell(h.ntrials,1);

% run a series of blocks
k = 1;
for j = 1:h.nblocks
    block = j
    % run a block of trials
    for i = 1:h.ntrials
        condition = s.conditions(conditionindex(i));
        list = Shuffle(1:h.nwords);                     % permute index vector
        
        if condition == 1                               % Condition 1: Left solitary
            leftindex(i) = list(1);
            rightindex(i) = 0;
            leftword = char(s.words(leftindex(i)));
            rightword = nan;
            leftwordB = nan;
            rightwordB = nan;
            myword{i} = leftword;
            
        elseif condition == 2                           % Condition 2: Right solitary
            rightindex(i) = list(2);
            leftindex(i) = 0;
            leftword = nan;
            rightword = char(s.words(rightindex(i)));
            leftwordB = nan;
            rightwordB = nan;
            myword{i} = rightword;
            
        elseif condition == 3                           % Condition 3: Bilateral left target
            leftindex(i) = list(3);
            rightindex(i) = list(4);
            leftword = char(s.words(leftindex(i)));
            rightword = nan;
            leftwordB = nan;
            rightwordB = char(s.words(rightindex(i)));
            myword{i} = leftword;
            
        elseif condition == 4                           % Condition 4: Bilateral right target
            leftindex(i) = list(5);
            rightindex(i) = list(6);
            leftword = nan;
            rightword = char(s.words(rightindex(i)));
            leftwordB = char(s.words(leftindex(i)));
            rightwordB = nan;
            myword{i} = rightword;
            
        end
        
        % data output
        [response(i),mystring{i}] = ATrial(h, cal, window, os, leftword,...
            rightword,leftwordB, rightwordB, condition, myword{i});
        save(filename, 'h','s', 'conditionindex', 'leftindex', 'rightindex',...
            'response','myword','mystring');
    end
    if block < h.nblocks
        DrawMyText(window,'Press any key to proceed to next block',0,0,cal.white);
        WaitSecs(2);
        Screen(window,'Flip');
        while KbCheck(-3) == 0; end                     % wait until a key is pressed.
        Screen(window,'Flip');
    else
        DrawMyText(window,'This series of blocks has concluded. Press any key to end.'...
            ,0,0,cal.white);
        WaitSecs(2);
        Screen(window,'Flip');
        while KbCheck(-3) == 0; end                     % wait until a key is pressed.
        Screen(window,'Flip');
    end
    k = k+1;
end

% overall summary of percent correct and standard error for this run
for i = 1:h.ncond
    index = (conditionindex == i);
    fprintf(1,'Condition %1.0f: Percent correct = %6.2f',i,100*mean(response(index)));
    fprintf(1,', SEM = %6.2f\n',std(response(index)/sqrt(sum(index))));
end

% End of experiment; Handle errors by restoring screen, etc
catch ME                                            % matches "try" at begining of program
    MyShutDown(os);                                 % shut down nicely
    rethrow(ME);                                    % print out error message
end

% Final Exit:  restore screen, keyboard and exit
MyShutDown(os);
%--------------------------------------------------------------------------

function [response,mystring] = ATrial(h,cal,window,os,leftword,rightword,...
    leftwordB,rightwordB,condition, myword)         % run one trial of the experiment

WaitSecs(h.iti);                                    % start with between trial wait                

% display fixation 
DrawFixation(window,h.fixationsize,cal.white);
Screen(window,'Flip');               
WaitSecs(h.fixationtime);
c = MyCalcContrast(h,h.contrast);                   % calc contrast 
c2 = MyCalcContrast(h,h.contrastAlt);               % alternate calc contrast

DrawFixation_andcue(window,h,h.fixationsize,...
    cal.white,condition,h.contrast);                % display pre-cue
Screen(window,'Flip');                     
WaitSecs(.1);

% display stimulus
DrawFixation_andcue(window,h,h.fixationsize,cal.white,condition,h.contrast);
DrawMyText(window,leftword,-h.spacing,0,[c,c,c]); 	% draw left side text
DrawMyText(window,rightword,h.spacing,0,[c,c,c]); 	% draw right side text
DrawMyText(window,leftwordB,-h.spacing,0,[c,c,c]); 	% draw left side distractor text
DrawMyText(window,rightwordB,h.spacing,0,[c,c,c]); 	% draw right side distractor text
t1 = Screen(window,'Flip');                 	 
WaitSecs(h.duration);

DrawFixation_andcue(window,h,h.fixationsize,cal.white,condition,h.contrast);
% erase stimulus word and wait
t2 = Screen(window,'Flip');                 	
WaitSecs(1);

% type input for response
[xc,yc]=EXGetCenter(window);
mystring=GetEchoString(window,'',xc-50,yc,cal.white,cal.black);
Screen(window,'Flip');                 	 
if mystring=='a'
    disp('Aborting...');
    MyShutDown(os);
end

% auditory feedback if incorrect
if ~strcmp(mystring, myword)
    beep;
    response=0;
else
    response=1;
end

fprintf(1,'Target: %s\n',myword);
fprintf(1,'Response: %s\n',mystring);
fprintf(1,'Duration: %5.3f\n',t2-t1);
%--------------------------------------------------------------------------

function [h, cal, window, os, s] = Initialize(h,s)
% Initialize everything for the experiment

% misc variables
h.Font = 'Arial';                                   % font selector
h.FontStyle = 0;                                    % (0) 0 for normal, 1 for bold
h.fixationsize = 10;                                % size of fixation cross in pixels
h.fixationtime = 1;                                 % duration of fixation display
h.aftertime = 0.5;                                  % duration of blanks after displays
h.iti = 1.0;                                        % duration of intertrial time
h.initialseed = ClockRandSeed;                      % initialize random number generator and save seed
h.abortkeycode = KbName('a');                       % abort key
h.ckeycode = KbName(',<');                          % correct key
h.ekeycode = KbName('.>');                          % error key
h.background = 0.0;                                 % fraction of RGB for background
h.pixelsize = 32;  

%open xls file and create cell array
listFile = 'wordlist_4letter.xls';
[s.words] = readWordList(listFile);

h.nwords = length(s.words);                         % save the length of this array        

% monitor parameters that depend on the exact set up (Palmer lab vs default)
if h.LabMonitor == 1
    h.hres = 1024;                                  % version to work in new lab w/ eyelink 1000
    h.vres = 640; 
    h.tres = 120;                                   % temporal resolution in hertz
    h.pixelsperdegree = 23.8;                       % pixels per degree (new lab setup)
    h.calibrationfile = 'sony11_061917.cal';        % lab calibration file
	os.SetResolution = 1;                           % 1 to reset resolution of monitor, 0 to not
else
    h.hres = 1280;                                  % generic values
    h.vres = 800; 
    h.tres = 60;                                    % temporal resolution in hertz
    h.pixelsperdegree = 23.8;                       % pixels per degree (new lab setup) 
    h.calibrationfile = 'unit.cal';                 % generic calibration file
    os.SetResolution = 0;                           % 1 to set resolution of monitor, 0 to not
end

% convert spatial variable s to pixels
h.spacing = h.pixelsperdegree*h.spacingDeg;         % spacing from center 

% set resolution if specified
if os.SetResolution == 1
	os.oldRes = SetResolution(0,h.hres,...
        h.vres,h.tres,h.pixelsize);                 % returns old resolution
end

% get calibration info amd make Gamma correction array (inverse gamma)
cal = CCGetCalibration(h.calibrationfile);          % get calibration info and put in record "cal"
gammaInverse = CCMakeInverseGamma(cal);             % calcualte lookup table for calibration

% set values for OpenWindow call                    % use "full" color (32 bit mode)
myscreen = 0;                                       % use 0 for single monitor systems
backgroundSRGB = [h.background...                   % calculations about color used 
    h.background h.background];                     % "standardized" RGB (0-1)
cal.backroundRGB = round(255*backgroundSRGB);       % final calls to all display routines
                                                    % use integer RGB (0-255)

% create graphics "window" for entire screen with a given background color and do other intialization
window=Screen(myscreen,'OpenWindow',...
    cal.backroundRGB,[],h.pixelsize);               % [] arg causes default window size (entire screen)
BackupCluts(myscreen);                              % save cluts (to be restored by sca)
Screen('LoadNormalizedGammaTable',...
    myscreen, gammaInverse);                        % this loads the gamma correction into hardware
HideCursor;                                         % hide cursor during displays
ListenChar(2);                                      % flush char buffer; 
                                                    % remember to use cntl-C if program aborts
% set text properties
Screen('TextFont',window,h.Font);
Screen('TextSize',window,h.FontSize);      
Screen('TextStyle',window,h.FontStyle);
Screen('Preference', 'TextAntiAliasing', 0);        % want text in binary colors
%--------------------------------------------------------------------------

function DrawFixation(window,size,color)
% DrawFixation draws a fixation point consisting of a cross
% pass in:  window, size in pixels and color in clut index 
% symmetric fixation works bit differently for old and new systems, this version for new 
% 10/29/06	jp created
% 8/7/14    jp kludged fixation to make it symetric, don't understand details?
% 9/8/14    redid again for newer system
% 3/21/15   revised color arg for 32-bit color

[xc,yc] = EXGetCenter(window);
half = round((size-1)/2);

% this method worked for new matlab/psychtoolbox
Screen('DrawLine',window,color,xc,yc,xc,yc+half+1);
Screen('DrawLine',window,color,xc,yc,xc,yc-half);
Screen('DrawLine',window,color,xc,yc,xc+half,yc);
Screen('DrawLine',window,color,xc,yc,xc-half-1,yc);
%--------------------------------------------------------------------------

function DrawFixation_andcue(window,h,size,color,condition,contrast)
% DrawFixation draws a fixation point consisting of a cross and "underline"
% cue of target word

[xc,yc] = EXGetCenter(window);
half = round((size-1)/2);

c = MyCalcContrast(h,10*contrast);

Screen('DrawLine',window,color,xc,yc,xc,yc+half+1);
Screen('DrawLine',window,color,xc,yc,xc,yc-half);
Screen('DrawLine',window,color,xc,yc,xc+half,yc);
Screen('DrawLine',window,color,xc,yc,xc-half-1,yc);
if condition == 1
        DrawMyText(window,'___',-h.spacing,25,c);
end
if condition == 2
        DrawMyText(window,'___',h.spacing,25,c);
end
if condition == 3
        DrawMyText(window,'___',-h.spacing,25,c);
end
if condition == 4
        DrawMyText(window,'___',h.spacing,25,c);
end
%--------------------------------------------------------------------------

function DrawMyText(window,s,x,y,color)
% DrawMyText(window,s,x,y,color);
% draw text centered at position x,y relative to center in a given color
% pass in window, string, x,y position relative to center, and clut index

[xcenter,ycenter] = EXGetCenter(window);            % get center of screen to position text
if ~isnan(s)
    rect = Screen(window,'TextBounds',s);           % TextBounds replaces TextWidth
    width=rect(3);                                  % 3rd element is width of text rectangle
    height = rect(4);
    xx = xcenter-width/2+x;                         % figure x coordinate
    yy = ycenter-height/2+y;                        % figure y coordinate
else
    xx = xcenter;
    yy = ycenter;
end
Screen(window,'DrawText',s,xx,yy,color);            % psychtoolbox call
%--------------------------------------------------------------------------

function c = MyCalcContrast(h,contrast)
% MyCalcContrast(h,contrast)
% routine to calculate RGB for desired gamut contrast

c = round((h.background+contrast*(1-h.background))*255);
%--------------------------------------------------------------------------

function MyShutDown(os)
% MyShutDown
% Exits program nicely.  No Eyelink code

sca;                                                % close screens and restore cluts
ListenChar(0);                                      % flush char buffer; remember to use 
                                                    % cntrl-C if program aborts
                                                    
if os.SetResolution == 1                            % restore initial resolution
	SetResolution(0,os.oldRes);
end

WaitSecs(0.2);                                      % allows for asyncronous system functions 
                                                    % to complete entirely 
%--------------------------------------------------------------------------

function [words,catgLabels,numTokens,wordLengs] = readWordList(filename) 

[~,t] = xlsread(filename); 

%first row is category name 
ncat = size(t,2); 
nrow = size(t,1); 

catgLabels = cell(1,ncat); 
numTokens  = zeros(1,ncat); 
words = cell(nrow-1,ncat);
wordLengs = zeros(nrow-1,ncat);

for c = 1:ncat
    i = 0;
    for r = 1:nrow
        if r==1
            catgLabels{c} = t{r,c};
        elseif ~isempty(t{r,c})
            i = i+1;
            words{i,c} = t{r,c};
            wordLengs(i,c)  = length(words{i,c});
        end
    end
    numTokens(c) = i; 
end















