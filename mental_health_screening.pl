mental_health_screening_options([
    'ADHD',
    'Depression',
    'Anxiety',
    'OCD',
    'PTSD'
]).

mental_health('adhd').
mental_health('depression').
mental_health('anxiety').
mental_health('ocd').
mental_health('ptsd').

is_valid_mental(Option) :-
    atom_lowercase(Option, LowerOption),
    mental_health(LowerOption).
    
scoring_threshold(0).

screening_questions('adhd', [
    'Do you find it difficult to sustain attention in tasks or play activities?',
    'Are you easily distracted by unrelated stimuli?',
    'Do you frequently forget daily tasks or appointments?',
    'How often do you feel restless or like you need to move?',
    'Is it challenging for you to organize tasks or activities?'
]).

screening_questions('depression', [
    'Over the past two weeks, how often have you felt down, depressed, or hopeless?',
    'Have you experienced a significant change in appetite or weight recently?',
    'How is your sleep quality lately?',
    'Do you have low energy or feel fatigued most days?',
    'Are you struggling with feelings of worthlessness or excessive guilt?'
]).

screening_questions('anxiety', [
    'How often do you feel nervous or anxious?',
    'Do you experience sudden, intense feelings of fear or panic?',
    'Are you bothered by excessive worry or overthinking?',
    'How often are you feeling afraid, as if something awful might happen?',
    'Do you avoid situations or activities due to fear or anxiety?'
]).

screening_questions('ocd', [
    'Do you experience persistent, unwanted thoughts or images that cause anxiety?',
    'Are you compelled to perform repetitive behaviors or mental acts to reduce anxiety?',
    'How much time per day do you spend on these repetitive behaviors or rituals?',
    'Do these thoughts and behaviors interfere with your daily activities or relationships?',
    'Have you noticed an increase in distress when you try to resist the compulsions?'
]).

screening_questions('ptsd', [
    'Have you experienced a traumatic event that continues to cause distress?',
    'Do you have recurring, involuntary memories, flashbacks, or nightmares related to the trauma?',
    'Do you actively avoid reminders or situations associated with the traumatic event?',
    'Are you experiencing negative changes in mood, thoughts, or feelings since the trauma?',
    'Have you noticed heightened arousal, such as difficulty sleeping, irritability, or exaggerated startle responses?'
]).

display_options([]) :-
    write('No screening options available.').
display_options(Options) :-
    format('~w\n', [Options]).

process_mental_health_screening(SelectedOption) :-
    trim_whitespace_mh(SelectedOption, Option),
    atom_lowercase(Option, CleanedOption),
    (
        mental_health(CleanedOption) ->
            write('Selected Option: '), write(CleanedOption), nl,
            screening_questions(CleanedOption, Questions),
            write('### '), write(CleanedOption), write(' Screening:'), nl,
            perform_screening(Questions, 0, Total),
            calculate_percentage(Total, Percentage),
            write('### Scoring:'), nl,
            format('Total Score: ~w~n', [Total]),
            format('Percentage: ~2f%~n', [Percentage * 100]),
            above_threshold(Percentage)
    ;
        write('I am so sorry. We cannot handle this option right now. Please choose one from the list.'), nl,
        response_mental_health_screening
    ).

trim_whitespace_mh(Input, Output) :-
    atom_string(Input, InputString),
    trim_whitespace_string(InputString, TrimmedString),
    atom_string(Output, TrimmedString).

trim_whitespace_string(String, Trimmed) :-
    atomics_to_string(Words, ' ', String),
    atomic_list_concat(Words, '', Trimmed).

perform_screening([], Total, Total).
perform_screening([Question | Rest], CurrentTotal, Total) :-
    write(Question), nl,
    get_response_score(Score),
    NewTotal is CurrentTotal + Score,
    perform_screening(Rest, NewTotal, Total).

get_response_score(Score) :-
    write('- 0: Not at all'), nl,
    write('- 1: Rarely'), nl,
    write('- 2: Occasionally'), nl,
    write('- 3: Often'), nl,
    write('- 4: Almost always'), nl,
    read_line_to_string(user_input, Response),
    validate_response(Response, Score).

validate_response(Response, Score) :-
    atom_number(Response, Score),
    between(0, 4, Score), % Ensure the score is between 0 and 4
    !.
validate_response(_, Score) :-
    write('I\'m sorry. Your response seems invalid. Please provide a valid answer from 0 to 4.'), nl,
    get_response_score(Score).

calculate_percentage(Total, Percentage) :-
    scoring_threshold(Threshold),
    Percentage is Total / 20, % Assuming 5 questions with a maximum score of 4 each
    Percentage >= Threshold.

above_threshold(Percentage) :-
    (Percentage >= 0.8) ->
        write('Your score suggests a high likelihood of the mental health disorder. It\'s important to prioritize your mental health. If you have ongoing concerns, it is advisable to seek further help from a professional.'), nl;
    write('Your score is still considered normal, however, consider monitoring your mental health and seeking support if needed.If you ever feel the need to talk or seek support, consider reaching out to friends, family, or a mental health professional.'), nl.
    
above_threshold(_).



