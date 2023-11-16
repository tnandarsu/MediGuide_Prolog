%:-consult('symptom.pl').
:-consult('hotlines.pl').
:-consult('hospitals.pl').

% greeting, bye, and contains function

greeting :-
    write('Hello! How can I assist you today? Type "bye" to exit.'), nl.

farewell :-
    write('Goodbye! Have a great day.'), nl.

contains_greeting(Statement) :-
    member(Word, ['hello', 'hi', 'hey', 'good morning', 'good afternoon']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).
 
contains_bye(Statement) :-
    member(Word, ['bye', 'exit', 'end', 'conclude', 'terminate', 'close', 'finsih']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).
%--------------------------------------------------------------------------
% to find substring in user response

atom_contains(Atom, Substring) :-
    sub_atom(Atom, _, _, _, Substring).
%-------------------------------------------------------------------------------

% Converts an atom to lowercase
atom_lowercase(Atom, LowercaseAtom) :-
    atom_chars(Atom, Chars),
    maplist(lowercase_char, Chars, LowercaseChars),
    atom_chars(LowercaseAtom, LowercaseChars).

% Converts a single character to lowercase
lowercase_char(Char, LowercaseChar) :-
    char_code(Char, Code),
    (Code >= 65, Code =< 90, !, LowercaseCode is Code + 32; LowercaseCode = Code),
    char_code(LowercaseChar, LowercaseCode).
%--------------------------------------------------------------------------------------
% Diagnosis 
contains_diagnose(Statement) :-
    member(Word, [
        'diagnosis', 'check up', 'examination', 'health assessment',
        'health check', 'medical checkup', 'physical examination',
        'symptoms analysis', 'health evaluation', 'medical assessment'
    ]),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).
        
response_to_diagnose :-
    user_name(Name), 
    write('Can you provide your symptoms, '), write(Name), write('?'),
    read_line_to_string(user_input, Symptoms),
    process_symptoms(Symptoms).

process_symptoms(Symptoms) :-
    atomic_list_concat(AtomList, ',', Symptoms),
    diagnose(Illness, AtomList),
    process_diagnosis(Illness).
    
process_diagnosis(unknown) :-
    write('I couldn\'t diagnose your illness based on the provided symptoms. Please consult a healthcare professional.'), nl.
    
process_diagnosis(Illness) :-
    write('Based on your symptoms, you may have '), write(Illness), write('. Please consult a healthcare professional for further evaluation.'), nl.
%-------------------------------------------------------------------------------  

% Hotlines
contains_hotline(Statement) :-
    member(Word, ['call','hotline', 'emergency number', 'contact', 'healthcare hotline']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).

response_hotline :-
    write_hotline_responses.
%---------------------------------------------------------------------------------

% Hospitals
contains_hospitals(Statement) :-
    member(Word, ['hospitals', 'hospital', 'medical facilities', 'healthcare centers']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).

trim_whitespace(String, Trimmed) :-
    atom_string(Atom, String),
    atom_string(Trimmed, Atom).

% Updated response_hospitals/0 predicate
response_hospitals :-
    write('Sure! In which city in Thailand are you currently located?'), nl,
    read_line_to_string(user_input, RawLocation),
    trim_whitespace(RawLocation, Location),
    atom_lowercase(Location, LowercaseLocation),
    get_hospitals(LowercaseLocation, HospitalList),
    nl,
    write('Here are some Hospitals near your area:'), nl,
    print_hospitals_details(HospitalList),
    nl.

% Updated print_hospitals/1 predicate to print details
print_hospitals_details([]).
print_hospitals_details([Hospital | T]) :-
    write('- '), write(Hospital), nl,
    print_hospital_details(Hospital),
    print_hospitals_details(T).

% New predicate to print details of a specific hospital
print_hospital_details(Hospital) :-
    hospital(_, Hospital, Type, _, Address, OpeningTimes),
    write('   Type: '), write(Type), nl,
    write('   Address: '), write(Address), nl,
    write('   Opening Times: '), write(OpeningTimes), nl.


%-------------------------------------------------------------------------------

% Introduction
:- dynamic(user_name/1).
response_start :-
    write('What should I call you?'), nl, 
    read_line_to_string(user_input, Name),
    assertz(user_name(Name)),
    write('Nice to meet you, '),
    write(Name), 
    write('! How can I assist you today?'), nl.

% Check
response(Statement) :-
    (
     contains_diagnose(Statement) -> response_to_diagnose;
     contains_greeting(Statement) -> response_start;
     contains_hotline(Statement) -> response_hotline;
     contains_hospitals(Statement) -> response_hospitals;
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
