:- consult('kb_symptom.pl').
:- consult('main_program.pl')

:- dynamic(symptoms_list/1).

%receive user input and get symptom -> convert to list
diagnose(Illness) :-
    retractall(symptoms_list(_)),
    write('What symptoms do you have? (separated by space): '),
    read_line_to_string(user_input, Symptoms),
    split_string(Symptoms, " ", " ", SymptomsList),
    assertz(symptoms_list(SymptomsList)),
    write('Symptoms List: '), write(SymptomsList), nl, 
    check_symptoms(SymptomsList, Illness).

% Call by diagnose -> check and suggest only the illness with more than half symptoms checked.
check_symptoms([], unknown) :-
    write('Can you provide more symptoms?'), nl,
    read_line_to_string(user_input, UserInput),
    response_more_diagnosis(UserInput).

response_more_diagnosis(Statement):-
    contains_no(Statement) ->
        write('Your welcome, Is there anything I can assist you?');
    split_string(Statement, " ", " ", NewSymptomsList),
    symptoms_list(OldSymptomsList),
    append(OldSymptomsList, NewSymptomsList, UpdatedSymptomsList),
    retractall(symptoms_list(_)),  % Remove the old list
    assertz(symptoms_list(UpdatedSymptomsList)),
    write('Symptoms List: '), write(UpdatedSymptomsList), nl, 
    check_symptoms(UpdatedSymptomsList, Illness).
    
    
    
contains_no(Statement) :-
    member(Word, ['no', 'n', 'nah', 'this is all', 'not really']),
    atom_lowercase(Statement, LowerStatement),
    atom_lowercase(Word, LowerWord),
    atom_contains(LowerStatement, LowerWord).

check_symptoms([Symptom | Rest], Illness) :-
    atom_string(TrimmedSymptom, Symptom),
    findall(PotentialIllness, symptom(TrimmedSymptom, PotentialIllness), PotentialIllnesses),
    count_matching_symptoms(Rest, PotentialIllnesses, MatchingSymptomsCount),
    length(PotentialIllnesses, TotalSymptoms),
    (MatchingSymptomsCount >= TotalSymptoms / 2 ->
        write('Suggested illness according to your symptoms: '), write(PotentialIllnesses), nl,
        Illness = PotentialIllnesses; 
        check_symptoms(Rest, Illness)
    ).

%-----------------------------------------------------------------------------
count_matching_symptoms([], _, 0).
count_matching_symptoms([Symptom | Rest], PotentialIllnesses, Count) :-
    atom_string(TrimmedSymptom, Symptom),
    findall(PotentialIllness, (member(PotentialIllness, PotentialIllnesses), symptom(TrimmedSymptom, PotentialIllness)), Matching),
    length(Matching, MatchingCount),
    count_matching_symptoms(Rest, PotentialIllnesses, RestCount),
    Count is MatchingCount + RestCount.

