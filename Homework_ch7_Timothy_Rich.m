%% Homework chapter 7

%% Q7.1 Structures

% create a structure, mystruct that contains 3 fields.
% mystring : which contains your name
% mychange: a double (default for any number) containing the amount of loose change in your wallet or puse
% mygender: a logical, with 1 for female and 0 for male
mystruct(1).mystring = 'Tim';
mystruct(1).mychange = 2.79;
female = logical(1);
male = logical(0);
mystruct(1).mygender = male;

% now make a second element in that structure (mystruct(2).fieldname) with
% the same information for someone else (imaginary is fine).
mystruct(2).mystring = 'Anne';
mystruct(2).mychange = 0.44;
mystruct(2).mygender = female;

%% Q 7.2 Cell arrays

% Make a 3 (fields) x 2 (individuals) cell array that contains all the
% information of the structure above
cellarray{1} = mystruct;

% pull out the name of the second individual.
newCell = cellarray{1}(2);
newCell.mystring

% pull out the amount of change that you had and add it to amount of change
% the other individual had.
newCell2 = cellarray{1}(1);
newCell.mychange + newCell2.mychange
