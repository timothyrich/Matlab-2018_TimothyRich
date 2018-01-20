%% Homework_ch2_Timothy Rich

%% Q 2.1: Replacing letters in strings

% a) Start with a string containing A PACK OF LIES and replace the P with an L and the L with a P.

str1='A PACK OF LIES';
str1(3)='L';
str1(11)='P';

% b) Start with a string containing It’s pouring with rain and replace the p with an r and the r with a p.

str2='It"s pouring with rain';
str2(6)='r';
str2(19)='p';
% how do you write an apostrophe within a letter string?

% c) Now try to do this for both a) and b) in a single line of code.

str1='A PACK OF LIES';
ind1=[3 11]; str1(ind1)=['L' 'P'];
% not sure if this is what you're looking for here
str2='It"s pouring with rain';
ind2=[6 19]; str2(ind2)=['r' 'p']

%% Q 2.2: More replacing letters in strings.
%Starting with the string:

str = 'nosey little cook';

% a) Create a vector called id1 so that when you type:
disp(str(id1))

% you get:         cosy little nook
% (Hint, write the phrase "nosey little cook" on a piece of paper and number each letter)
 
str = 'nosey little cook';
id1=[14 2 3 5 6:13 1 15:17];
disp(str(id1))

%% Q 2.3: Creating vectors.
 
% Create the following vectors using both linspace and the colon ‘:’ technique

% v = [20    18    16    14    12    10     8     6];
vect1=linspace(20,6,8);
vect1=20:-2:6;

% v = [1.1000 1.3268 1.5537 1.7805 2.0074 2.2342 2.4611 2.6879 2.9147 3.1416];
vect2=linspace(1.1,pi,10);
vect2=1.1:0.2268:pi;

% v = [20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1];
vect3=linspace(20,1,20);
vect3=20:-1:1;

%% Q 2.4: More indexing into strings.
 
%Start with the following string of 20 ‘x’s:
str = 'xxxxxxxxxxxxxxxxxxxx';

% a) Use indexing to make the 2, 5, 8th and so on ... letters in the string "z" and the 3rd, 6th and 9th and so on ... letter "p".  I.e. "xzpxzpxzpxzpxzpxzpxz"
ind1=linspace(2,20,7);
ind2=linspace(3,18,6);
str(ind1)='z';
str(ind2)='p';

% b) make the 5th , 6th  and 7th letters ‘r’.
ind3=5:7;
str(ind3)='r';

% c) Demonstrate that the eight letter in the string is a 'z'
disp(str(8));

% d) Flip str so it is backwards (‘zxpzxpzxpzxpzrrrxpzx’). Hint (use 2.3c)
vect1=linspace(20,1,20);
reversedstr=str(vect1);

% e) Demonstrate that the 6th, 13th and 17th letters in the reversed string are ‘pzx’.
vect2=[6 13 17];
disp(reversedstr(vect2));

%% Q 2.5: Indexing into vectors
 
% You ran an experiment where you took 20 measurements every 2.36 seconds starting 1.2 seconds into the experiment.
% a) Create a vector that describes the moments in time that these measurements were taken.
vect1=1.2:2.36:46.04;

% b) When was the fifth measurement taken?
disp(vect1(5));

% c) Display the last measurement, using the command 
% end
disp(vect1(end));

%% Q 2.6: Still more indexing

% Imagine you are running an experiment where 16 stimuli flash onto the
% screen. Subjects are asked to hit the 'h' key if they see a happy face 
% and a ‘s’ of they see a sad face.
% The sad faces were presented on trials: 1     2     6     7    10    13    14    15
% Start with stimlist='hhhhhhhhhhhhhhhh'
% a) Turn stimlist into a string showing which trials contained happy faces and which trials contained sad faces.
stimlist='hhhhhhhhhhhhhhhh';
sad=[1 2 6 7 10 13 14 15];
stimlist(sad)='s';

% During trials 1-4 and 9-12 sad music was playing. During the other trials happy music was playing. 
% b) Create two vectors, sadvect and happyvect that contain the trials when sad and happy music was playing, respectively. 
sadvect=[1:4 9:12];
happyvect=[5:8 13:16];

% At the end of the experiment, you end up with a string showing how the subject categorized the faces.

resplist='ssshhhshsshhsssh';

% c) Create strings stimlisthappy and resplisthappy that contain the values in stimlist and resplist when happy music was playing
stimlisthappy=stimlist(happyvect);
resplisthappy=resplist(happyvect);

% d) Find out which stimulus was being presented on the 3rd happy music trial.
disp(stimlisthappy(3));

% e) Find out which responses were made on the 3rd, 4th and 5th sad music trial.
resplistsad=resplist(sadvect);
disp(resplistsad(3:5))