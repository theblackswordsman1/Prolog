% Predicates.pro - contains all the rules needed.

% Predicate to check if a line is the 'puzzle' header
is_puzzle_header(Line) :-
    split_string(Line, " ", "", ["puzzles", N]),
    number_string(_, N),
    format('Puzzle number: ~w~n', [N]).

% Predicate to check if a line is the 'size' line
is_size_line(Line, Width, Height) :-
    split_string(Line, " ", "", ["size", SizeStr]),
    split_string(SizeStr, "x", "", [WidthStr, HeightStr]),
    number_string(Width, WidthStr),
    number_string(Height, HeightStr).

% Predicate to check if a line is a 'number' line
is_number_line(Line, Numbers) :-
    split_string(Line, " ", "", NumStrs),
    NumStrs \= [],
    maplist(number_string, Numbers, NumStrs),
    Numbers \= [].

% Predicate to check if a line is a grid line
is_grid_line(Line) :-
    Line \= "",
    \+ is_puzzle_header(Line),
    \+ is_size_line(Line, _, _),
    \+ is_number_line(Line, _).

% Find symbols and their positions in the trimmed puzzle
get_symbols_positions(TrimmedPuzzle, (Width, _Height), SymbolsPositions) :-
    findall(symbol_at(Symbol, X, Y), (
        nth0(Y, TrimmedPuzzle, Line),
        split_string(Line, " ", "", Symbols),
        % Take only the grid symbols, excluding clues
        length(GridSymbols, Width),
        append(GridSymbols, _Clues, Symbols),
        nth0(X, GridSymbols, Symbol),
        Symbol \= ""
    ), SymbolsPositions).

% Predicate to collect right edge clues
get_right_edge_clues(TrimmedPuzzle, (Width, _Height), RightEdgeClues) :-
    findall(clue_at(Clue, Y), (
        nth0(Y, TrimmedPuzzle, Line),
        split_string(Line, " ", "", Symbols),
        nth0(Width, Symbols, Clue),
        Clue \= ""
    ), RightEdgeClues).
    
