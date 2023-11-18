% main_program.pl

:- consult('symptom.pl').
:- consult('kb_symptom.pl').
:- consult('hotlines.pl').
:- consult('hospitals.pl').
:- consult('healthcare_tips.pl').
:- consult('mental_health_screening.pl').

% greeting, bye, and contains function

:- dynamic(user_name/1).
% Main interaction loop
chat :-
    response_start,
    repeat,
    read_line_to_string(user_input, UserInput),
    response(UserInput),
    contains_bye(UserInput),
    !.

response(Statement) :-
    (
     
     contains_greeting(Statement) -> write('Hi, How can I assist you today?');
     contains_thankyou(Statement) -> write('Your welcome, Is there anything I can assist you?');
     contains_diagnose(Statement) -> response_to_diagnose;
     contains_mental(Statement) -> response_mental_health_screening;
     contains_hotline(Statement) -> response_hotline;
     contains_hospitals(Statement) -> response_hospitals;
     contains_bye(Statement) -> farewell;
     write('I did not understand that. Can you please rephrase?')
    ).

response_start :-
    write('Hello! This is MediGuide, your healthcare assistance. We\'re here to assist you with symptoms diagnosis, mental health issues, hotlines number or even finding hospitals too.'), nl,
    write('What should I call you?'), nl,
    read_line_to_string(user_input, Name),
    assertz(user_name(Name)),
    write('Nice to meet you, '),
    write(Name), 
    write('! How can I assist you today?'), nl.

farewell :-
    write('Goodbye! Thank you for using our service. Have a great day.'), nl.

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

contains_thankyou(Statement) :-
    member(Word, ['thanks', 'thx', 'thank you', 'okay', 'ok', 'thank']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).

atom_contains(Atom, Substring) :-
    sub_atom(Atom, _, _, _, Substring).

atom_lowercase(Atom, LowercaseAtom) :-
    atom_chars(Atom, Chars),
    maplist(lowercase_char, Chars, LowercaseChars),
    atom_chars(LowercaseAtom, LowercaseChars).

lowercase_char(Char, LowercaseChar) :-
    char_code(Char, Code),
    (Code >= 65, Code =< 90, !, LowercaseCode is Code + 32; LowercaseCode = Code),
    char_code(LowercaseChar, LowercaseCode).
%--------------------------------------------------------------------------------------
% Diagnosis 

response_to_diagnose :-
    diagnose(Illness), nl,
    healthcare_tips_for_potential_illnesses(Illness).

healthcare_tip_for_potential_illness([]).
healthcare_tips_for_potential_illnesses([PotentialIllness | Rest]) :-
    write('Here are some healthcare tips for '), write(PotentialIllness), write(': '), nl,
    healthcare_tips(PotentialIllness, Tips),
    write(Tips), nl,
    healthcare_tips_for_potential_illnesses(Rest).

contains_diagnose(Statement) :-
    member(Word, [
        'diagnosis', 'check up', 'examination', 'health assessment',
        'health check', 'medical checkup', 'physical examination',
        'symptoms analysis', 'health evaluation', 'medical assessment'
    ]),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).
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
    member(Word, ['hospitals', 'medical facilities', 'healthcare centers', 'location', 'clinic']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).

trim_whitespace(String, Trimmed) :-
    atom_string(Atom, String),
    atom_string(Trimmed, Atom).

response_hospitals :-
    write('Sure! In which city in Thailand are you currently living in?'), nl,
    read_line_to_string(user_input, RawLocation),
    trim_whitespace(RawLocation, Location),
    atom_lowercase(Location, LowercaseLocation),

    write('What type of hospitals are you interested in? Do you wanna go to private or goverment ones?'), nl,
    read_line_to_string(user_input, Preference),
    atom_lowercase(Preference, LowercasePreference),
    get_hospitals(LowercaseLocation, LowercasePreference, HospitalList), nl,
    write('Here are some hospitals near '), write(Location), nl,
    nl,
    print_hospitals_details(HospitalList),

print_hospitals_details([]).
print_hospitals_details([Hospital | T]) :-
    write('- '), write(Hospital), nl,
    print_hospital_details(Hospital),
    print_hospitals_details(T).

print_hospital_details(Hospital) :-
    hospital(_, Hospital, Type, _, Address, OpeningTimes),
    write('Type: '), write(Type), nl,
    write('Address: '), write(Address), nl,
    write('Opening Times: '), write(OpeningTimes), nl,
    nl.
%--------------------------------------------------------------------------------

% mental health

contains_mental(Statement) :-
    atom_lowercase(Statement, LowerStatement),
    member(Word, ['mental', 'emotional', 'psychological', 'well-being']),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).

response_mental_health_screening :-
    mental_health_screening_options(Options),
    write('Which mental health screening would you like to perform?'), nl,
    display_options(Options),
    read_line_to_string(user_input, SelectedOption),
    process_mental_health_screening(SelectedOption).

