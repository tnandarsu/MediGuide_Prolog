:- discontiguous check_symptoms/2.

diagnose(Illness) :-
    retractall(symptoms_list(_)),
    write('What symptoms are you having now? (separated by commas): '),
    read_line_to_string(user_input, RawSymptoms),
    atom_lowercase(RawSymptoms, Symptoms),  % Convert to lowercase
    replace_and_with_comma(Symptoms, SymptomsWithCommas),
    split_string(SymptomsWithCommas, ",", " ", SymptomsList),
    remove_empty_strings(SymptomsList, CleanedSymptoms),
    remove_invalid_symptoms(CleanedSymptoms, ValidSymptoms),
    assertz(symptoms_list(ValidSymptoms)),
    format('This is the list of symptoms you are feeling: ~w. ', [ValidSymptoms]),
    check_symptoms(ValidSymptoms, Illness).

replace_and_with_comma(Input, Output) :-
    atomic_list_concat(Split, 'and', Input),
    atomic_list_concat(Split, ',', Output).
    
remove_empty_strings([], []).
remove_empty_strings([String|Rest], Cleaned) :-
    (String = "" -> remove_empty_strings(Rest, Cleaned) ; Cleaned = [String|RestCleaned], remove_empty_strings(Rest, RestCleaned)).

check_symptoms([], unknown) :-
    write('Can you provide more symptoms?'), nl,
    read_line_to_string(user_input, UserInput),
    response_more_diagnosis(UserInput).

response_more_diagnosis(Statement) :-
    (
        contains_no(Statement) ->
            write('You\'re welcome. Is there anything else I can assist you with?');
        split_string(Statement, ",", " ", NewSymptomsList),
        symptoms_list(OldSymptomsList),
        remove_invalid_symptoms(NewSymptomsList, ValidSymptoms),
        append(OldSymptomsList, ValidSymptoms, UpdatedSymptomsList),
        retractall(symptoms_list(_)),
        assertz(symptoms_list(UpdatedSymptomsList)),
        (
            UpdatedSymptomsList = [] ->
                write('Are you feeling well? Please provide valid symptoms.'),
                response_more_diagnosis(Statement);
            write('This is the list of symptoms you are feeling: '), write(UpdatedSymptomsList), nl,
            check_symptoms(UpdatedSymptomsList, Illness),
            healthcare_tips_for_potential_illnesses(Illness)
        )
    ).

remove_invalid_symptoms([], []).
remove_invalid_symptoms([Symptom | Rest], ValidSymptoms) :-
    atom_string(TrimmedSymptom, Symptom),
    (is_valid_symptom(TrimmedSymptom) ->
        ValidSymptoms = [Symptom | RestValid],
        remove_invalid_symptoms(Rest, RestValid);
        write('It seems like you provide the invalid symptom.'), nl,
        remove_invalid_symptoms(Rest, ValidSymptoms)
    ).
    
contains_no(Statement) :-
    atomic_list_concat(Words, ' ', Statement),
    NoWords = ['no', 'n', 'nah'],
    maplist(atom_lowercase, Words, LowerWords),
    maplist(atom_lowercase, NoWords, LowerNoWords),
    intersection(LowerWords, LowerNoWords, CommonWords),
    \+ length(CommonWords, 0). 

check_symptoms([Symptom | Rest], Illness) :-
    atom_string(TrimmedSymptom, Symptom),
    (is_valid_symptom(TrimmedSymptom) ->
        findall(PotentialIllness, symptom(TrimmedSymptom, PotentialIllness), PotentialIllnesses),
        count_matching_symptoms(Rest, PotentialIllnesses, MatchingSymptomsCount),
        length(PotentialIllnesses, TotalSymptoms),
        (MatchingSymptomsCount >= TotalSymptoms / 2 ->
            write('I will suggest some illnesses according to your symptoms: '), write(PotentialIllnesses), nl,
            Illness = PotentialIllnesses; 
            check_symptoms(Rest, Illness)
        );
        write('It seems like you provide the invalid symptom. '), write(Symptom), nl,
        check_symptoms(Rest, Illness)
    ).

is_valid_symptom(Symptom) :-
    symptom(Symptom, _).

%-----------------------------------------------------------------------------
count_matching_symptoms([], _, 0).
count_matching_symptoms([Symptom | Rest], PotentialIllnesses, Count) :-
    atom_string(TrimmedSymptom, Symptom),
    findall(PotentialIllness, (member(PotentialIllness, PotentialIllnesses), symptom(TrimmedSymptom, PotentialIllness)), Matching),
    length(Matching, MatchingCount),
    count_matching_symptoms(Rest, PotentialIllnesses, RestCount),
    Count is MatchingCount + RestCount.
