% Prolog.pro - Main prolog file

% Load Predicates.pro with necessary predicates
:- ['Predicates.pro'].

% Prolog to read .txt file in terminal.
% commands to use: 
%   swipl
%   ['Prolog.pro'].
%   read_file_line_by_line('puzzle_0.txt').


% Read file line by line and process each line 
read_file_line_by_line('puzzle_0.txt') :-
    open('puzzle_0.txt', read, Stream, [encoding(utf8)]), % Specify utf-8 encoding.
    read_lines(Stream),
    close(Stream).

read_lines(Stream) :-
    \+ at_end_of_stream(Stream),  % Check if end of file is not reached
    read_line_to_string(Stream, Line),  % Read a line as a string
    process_line(Line), % Process the line
    % writeln(Line),  % Print the line
    read_lines(Stream).  % Recurse to the next line

read_lines(_). 

% Process a line by matching it to different patterns
process_line(Line) :-
    ( is_puzzle_header(Line))
    -> writeln('Puzzle header line')
    ; is_size_line(Line, Width, Height)
    -> format('Size line: Width=~w, Height=~w~n', [Width, Height])
    ; is_number_line(Line, Numbers)
    -> format('Number line: ~w~n', [Numbers])
    ; is_grid_line(Line, GridTokens)
    -> format('Grid line: ~w~n', [GridTokens])
    ; writeln('Unrecognized line').