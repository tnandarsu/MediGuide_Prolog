:- consult('kb_symptom.pl').

:- dynamic(symptoms_list/1).
symptoms_list([]).

%receive user input and get symptom -> convert to list
diagnose(Illness) :-
    write('What symptoms do you have? (separated by space): '),
    read_line_to_string(user_input, Symptoms),
    string_lower(Symptoms, LowercaseSymptoms), % Convert to lowercase
    split_string(LowercaseSymptoms, " ", " ", SymptomsList),
    check_symptoms(SymptomsList, Illness).

% Call by diagnose -> check and suggest only the illness with more than half symptoms checked.
check_symptoms([], unknown) :-
    write('I\'m sorry, I couldn\'t identify any specific illness based on the provided symptoms. Please consult a healthcare professional for a more accurate diagnosis.'), nl.
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