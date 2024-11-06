% Prolog.pro - Main prolog file

% Load Predicates.pro with necessary predicates
:- ['Predicates.pro'].

% Prolog to read .txt file in terminal.
% commands to use: 
%   swipl
%   ['Prolog.pro'].
%   process_puzzle('puzzle_0.txt').

% Read file line by line and process each line
read_file_line_by_line('puzzle_0.txt', GridLines, GridSize, ColumnClues) :-
    open('puzzle_0.txt', read, Stream, [encoding(utf8)]),
    read_lines(Stream, [], GridLines, none, GridSize, none, ColumnClues),
    close(Stream).

read_lines(Stream, GridLinesIn, GridLinesOut, GridSizeIn, GridSizeOut, ColumnCluesIn, ColumnCluesOut) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    process_line(Line, GridLinesIn, GridLinesNext, GridSizeIn, GridSizeNext, ColumnCluesIn, ColumnCluesNext),
    read_lines(Stream, GridLinesNext, GridLinesOut, GridSizeNext, GridSizeOut, ColumnCluesNext, ColumnCluesOut).
read_lines(_, GridLines, GridLines, GridSize, GridSize, ColumnClues, ColumnClues).
    

% Process a line by matching it to different patterns
process_line(Line, GridLinesIn, GridLinesOut, GridSizeIn, GridSizeOut, ColumnCluesIn, ColumnCluesOut) :-
    (   is_puzzle_header(Line)
    ->  writeln('Puzzle header line'),
        GridLinesOut = GridLinesIn,
        GridSizeOut = GridSizeIn,
        ColumnCluesOut = ColumnCluesIn
    ;   is_size_line(Line, Width, Height)
    ->  format('Size line: Width=~w, Height=~w~n', [Width, Height]),
        GridLinesOut = GridLinesIn,
        GridSizeOut = (Width, Height),
        ColumnCluesOut = ColumnCluesIn
    ;   is_number_line(Line, Numbers)
    ->  format('Number line: ~w~n', [Numbers]),
        GridLinesOut = GridLinesIn,
        GridSizeOut = GridSizeIn,
        ColumnCluesOut = Numbers  % Store column clues
    ;   is_grid_line(Line)
    ->  % Accumulate grid lines and display them
        append(GridLinesIn, [Line], GridLinesOut),
        format('Grid line: ~w~n', [Line]),
        GridSizeOut = GridSizeIn,
        ColumnCluesOut = ColumnCluesIn
    ;   writeln('Unrecognized line'),
        GridLinesOut = GridLinesIn,
        GridSizeOut = GridSizeIn,
        ColumnCluesOut = ColumnCluesIn
    ).


% Main predicate to process the puzzle
process_puzzle(File) :-
    read_file_line_by_line(File, GridLines, GridSize, ColumnClues),
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
          format('Clue: ~w at Row: ~w~n', [Clue, Y])),
    % Display column clues
    format('Column clues:~n'),
    (ColumnClues \= none ->
        findall(clue_at(Clue, X), (
            nth0(X, ColumnClues, Clue)
        ), ColumnCluesList),
        forall(member(clue_at(Clue, X), ColumnCluesList),
            format('Clue: ~w at Column: ~w~n', [Clue, X]))
    ;
        format('No column clues found~n')
    ).



