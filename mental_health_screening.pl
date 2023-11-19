% Define mental health screenings and their questions
screening(depression, [
    'Over the past two weeks, how often have you felt down, depressed, or hopeless?',
    'Have you experienced a significant change in appetite or weight recently?',
    'How is your sleep quality lately?',
    'Do you have low energy or feel fatigued most days?',
    'Are you struggling with feelings of worthlessness or excessive guilt?'
]).

screening(anxiety, [
    'How often do you feel nervous or anxious?',
    'Do you experience sudden, intense feelings of fear or panic?',
    'Are you bothered by excessive worry or overthinking?',
    'How would you rate your ability to relax on a scale from 0 to 10?',
    'Do you avoid situations or activities due to fear or anxiety?'
]).

% Function to start the mental health screening
start_mental_health_screening :-
    write('Which mental health screening would you like to take?'), nl,
    write('Please answer the following questions on a scale of 0 to 4, where 0 is "Not at all" and 4 is "Nearly every day".'), nl,
    write_screening_options,
    read_line_to_string(user_input, SelectedScreeningWithNewline), % Read input with newline
    atom_string(SelectedScreeningAtom, SelectedScreeningWithNewline),
    atom_string(SelectedScreening, SelectedScreeningAtom), % Convert to atom to remove newline
    start_selected_screening(SelectedScreening).

% Function to display screening options
write_screening_options :-
    findall(Screening, screening(Screening, _), Screenings),
    write_screening_options(Screenings, 1).

write_screening_options([], _).
write_screening_options([Screening | Rest], Index) :-
    format('~d. ~w~n', [Index, Screening]),
    NextIndex is Index + 1,
    write_screening_options(Rest, NextIndex).

% Function to start the selected screening
start_selected_screening(SelectedScreening) :-
    screening(SelectedScreening, Questions),
    ask_questions(Questions, 0, Total),
    calculate_percentage(Total, Percentage, Questions),
    interpret_results(SelectedScreening, Percentage).

% Function to ask screening questions
ask_questions([], Total, Total).
ask_questions([Question | Rest], CurrentTotal, Total) :-
    write(Question), nl,
    write('Enter your response (0-4): '),
    read(Response),
    NewTotal is CurrentTotal + Response,
    nl,
    ask_questions(Rest, NewTotal, Total).

% Function to calculate the percentage
calculate_percentage(Total, Percentage, Questions) :-
    length(Questions, NumberOfQuestions),
    TotalPossibleScore is NumberOfQuestions * 4, % Assuming each question can have a maximum score of 4
    Percentage is (Total / TotalPossibleScore) * 100.

% Function to interpret the screening results
interpret_results(Screening, Percentage) :-
    write('Your score for the '), write(Screening), write(' screening is '), write(Percentage), write('%.'), nl,
    nl,
    % Adjust the threshold percentage as needed
    (Percentage > 75 ->
        write('Your score indicates a high likelihood of issues. It is recommended to seek professional care.'), nl;
        write('Your score is within a normal range. However, if you have concerns, consider consulting with a professional.'), nl
    ),
    nl,
    ask_for_further_screenings. % Prompt user for another screening

ask_for_further_screenings :-
    write('Would you like to take another mental health screening? (yes/no): '),
    flush_output(user), % Ensure the prompt is displayed
    read_line_to_string(user_input, ResponseWithNewline), % Read input with newline
    atom_string(Response, ResponseWithNewline), % Convert to atom to remove newline
    process_response(Response).

process_response(yes) :-
    start_mental_health_screening. % Start another screening
process_response(no) :-
    write('Thank you for using MediGuide. If you have any other questions, feel free to ask.'), nl.
process_response(_) :-
    write('I did not understand that. Please enter "yes" or "no".'), nl,
    ask_for_further_screenings.
    