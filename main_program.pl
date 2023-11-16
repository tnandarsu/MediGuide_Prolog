:- consult('symptom.pl').
%default greeting, bye, and contains function

greeting :-
    write('Hello! How can I assist you today? Type "bye" to exit.').

farewell :-
    write('Goodbye! Have a great day.').

contains_greeting(Statement) :-
    member(Word, ['hello', 'hi', 'hey', 'good morning', 'good afternoon']),
    atom_contains(Statement, Word).
    
contains_bye(Statement) :-
    atom_contains(Statement, 'bye').
%--------------------------------------------------------------------------
atom_contains(Atom, Substring) :-
    atom_chars(Atom, Chars),
    atom_chars(Substring, SubChars),
    sublist(SubChars, Chars).
    
sublist([], _).
sublist([H|T], [H|Rest]) :-
    sublist(T, Rest).
sublist(SubList, [_|Rest]) :-
    sublist(SubList, Rest).
%-------------------------------------------------------------------------------
contains_diagnose(Statement) :-
    member(Word, [
        'diagnosis', 'check up', 'examination', 'health assessment',
        'health check', 'medical checkup', 'physical examination',
        'symptoms analysis', 'health evaluation', 'medical assessment'
    ]),
    atom_contains(Statement, Word).
        
response_to_diagnose :-
    user_name(Name), 
    diagnose(Illness).
%-------------------------------------------------------------------------------  
:- dynamic(user_name/1).
response_start :-
    write('What should I call you?'),
    read_line_to_string(user_input, Name),
    assertz(user_name(Name)),
    write('Nice to meet you, '),
    write(Name), 
    write('! How can I assist you today?').

%check
response(Statement) :-
    (
     contains_diagnose(Statement) -> response_to_diagnose;
     contains_greeting(Statement) -> response_start;
     contains_bye(Statement) -> farewell;
     write('I did not understand that. Can you please rephrase?')
    ).

% Main interaction loop
chat :-
    greeting,
    repeat,
    read_line_to_string(user_input, UserInput),
    response(UserInput),
    contains_bye(UserInput),
    !.