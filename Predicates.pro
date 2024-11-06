% Predicates.pro will contain all the rules needed.

% Predicate to check if a line is the 'puzzle' header
is_puzzle_header(Line) :-
    split_string(Line, " ", "", ["puzzles", N]),
    number_string(Number, N),
    format('Puzzle number: ~w~n', [Number]).

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
is_grid_line(Line, Tokens) :-
    split_string(Line, " ", "", Tokens),
    Tokens \= [],
    maplist(valid_grid_symbol, Tokens).

% Valid grid symbols
valid_grid_symbol("_").
valid_grid_symbol("╝").
valid_grid_symbol("╔").
valid_grid_symbol("╚").
valid_grid_symbol("╗").
valid_grid_symbol("═").
valid_grid_symbol("║").
valid_grid_symbol(NumberStr) :-
    number_string(_, NumberStr). % Accept numbers as valid symbols


