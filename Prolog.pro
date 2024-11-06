% Prolog.pro - Main prolog file

% Load Predicates.pro with necessary predicates
:- ['Predicates.pro'].

% Prolog to read .txt file in terminal.
% commands to use: 
%   swipl
%   ['Prolog.pro'].
%   process_puzzle('puzzle_0.txt').

% Read file line by line and process each line
read_file_line_by_line('puzzle_0.txt', GridLines, GridSize) :-
    open('puzzle_0.txt', read, Stream, [encoding(utf8)]),
    read_lines(Stream, [], GridLines, none, GridSize),
    close(Stream).

read_lines(Stream, GridLinesIn, GridLinesOut, GridSizeIn, GridSizeOut) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    process_line(Line, GridLinesIn, GridLinesNext, GridSizeIn, GridSizeNext),
    read_lines(Stream, GridLinesNext, GridLinesOut, GridSizeNext, GridSizeOut).
read_lines(_, GridLines, GridLines, GridSize, GridSize).
    

% Process a line by matching it to different patterns
process_line(Line, GridLinesIn, GridLinesOut, GridSizeIn, GridSizeOut) :-
    (   is_puzzle_header(Line)
    ->  writeln('Puzzle header line'),
        GridLinesOut = GridLinesIn,
        GridSizeOut = GridSizeIn
    ;   is_size_line(Line, Width, Height)
    ->  format('Size line: Width=~w, Height=~w~n', [Width, Height]),
        GridLinesOut = GridLinesIn,
        GridSizeOut = (Width, Height)
    ;   is_number_line(Line, Numbers)
    ->  format('Number line: ~w~n', [Numbers]),
        GridLinesOut = GridLinesIn,
        GridSizeOut = GridSizeIn
    ;   is_grid_line(Line)
    ->  % Accumulate grid lines and display them
        append(GridLinesIn, [Line], GridLinesOut),
        format('Grid line: ~w~n', [Line]),
        GridSizeOut = GridSizeIn
    ;   writeln('Unrecognized line'),
        GridLinesOut = GridLinesIn,
        GridSizeOut = GridSizeIn
    ).

% Main predicate to process the puzzle
process_puzzle(File) :-
    read_file_line_by_line(File, GridLines, GridSize),
    exclude(==( ""), GridLines, TrimmedGridLines),
    get_symbols_positions(TrimmedGridLines, GridSize, SymbolsPositions),
    get_right_edge_clues(TrimmedGridLines, GridSize, RightEdgeClues),
    % Display symbols and their positions
    format('Symbols and positions:~n'),
    forall(member(symbol_at(Symbol, X, Y), SymbolsPositions),
          format('Symbol: ~w at Position: (~w, ~w)~n', [Symbol, X, Y])),
    % Display right edge clues
    format('Right edge clues:~n'),
    forall(member(clue_at(Clue, Y), RightEdgeClues),
          format('Clue: ~w at Row: ~w~n', [Clue, Y])).


