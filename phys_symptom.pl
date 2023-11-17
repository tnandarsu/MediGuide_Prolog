:- consult('main_program.pl').
:- consult('kb_phys_symptom.pl').

% Rules for diagnosis
:- dynamic(has_symptom/2).
diagnose_physical_health(Illness) :-
    write('What symptoms do you have? (separated by space): '),
    read_line_to_string(user_input, Symptoms),
    split_string(Symptoms, " ", " ", SymptomsList),
    check_symptoms(SymptomsList, Illness).

check_symptoms([], unknown).
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

count_matching_symptoms([], _, 0).
count_matching_symptoms([Symptom | Rest], PotentialIllnesses, Count) :-
    atom_string(TrimmedSymptom, Symptom),
    findall(PotentialIllness, (member(PotentialIllness, PotentialIllnesses), symptom(TrimmedSymptom, PotentialIllness)), Matching),
    length(Matching, MatchingCount),
    count_matching_symptoms(Rest, PotentialIllnesses, RestCount),
    Count is MatchingCount + RestCount.

%initialize some empty list and add symptoms for user, keep check from there when ask about new symptoms
%adding some tips for example migraine -> drink lot of water
%make the the chatbot be able to accept more general input