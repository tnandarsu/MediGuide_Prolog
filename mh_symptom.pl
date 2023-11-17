% Include main program and knowledge base
:- consult('main_program.pl').
:- consult('kb_mh_symptom.pl').

% Rules for diagnosis
:- dynamic(has_symptom/2).
diagnose_mental_health(Illness) :-
    write('What symptoms are you experiencing? (separated by space): '),
    read_line_to_string(user_input, Symptoms),
    split_string(Symptoms, " ", " ", SymptomsList),
    check_mental_health_symptoms(SymptomsList, Illness).

check_mental_health_symptoms([], unknown).
check_mental_health_symptoms([Symptom | Rest], Illness) :-
    atom_string(TrimmedSymptom, Symptom),
    findall(PotentialIllness, mental_health_symptom(TrimmedSymptom, PotentialIllness), PotentialIllnesses),
    count_matching_symptoms(Rest, PotentialIllnesses, MatchingSymptomsCount),
    length(PotentialIllnesses, TotalSymptoms),
    (MatchingSymptomsCount >= TotalSymptoms / 2 ->
        write('Suggested mental health disorder according to your symptoms: '), write(PotentialIllnesses), nl,
        Illness = PotentialIllnesses; 
        check_mental_health_symptoms(Rest, Illness)
    ).

% Count the number of matching symptoms
count_matching_symptoms([], _, 0).
count_matching_symptoms([Symptom | Rest], PotentialIllnesses, Count) :-
    atom_string(TrimmedSymptom, Symptom),
    findall(PotentialIllness, (member(PotentialIllness, PotentialIllnesses), mental_health_symptom(TrimmedSymptom, PotentialIllness)), Matching),
    length(Matching, MatchingCount),
    count_matching_symptoms(Rest, PotentialIllnesses, RestCount),
    Count is MatchingCount + RestCount.
