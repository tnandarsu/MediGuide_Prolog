:- discontiguous evaluate_mental_health_screening/1.

mental_health_screening_questions([
    'Over the last two weeks, how often have you felt little interest or pleasure in doing things?',
    'Over the last two weeks, how often have you felt down, depressed, or hopeless?',
    'Do you often feel overwhelmed by stress?',
    % Add more questions as needed
]).

response_mental_health_screening :-
    write('Sure! Let\'s begin with a mental health screening. Answer the following questions with "yes" or "no".'), nl,
    mental_health_screening_questions(Questions),
    evaluate_mental_health_screening(Questions).

evaluate_mental_health_screening([]) :-
    write('Thank you for completing the mental health screening. If you have concerns, consider consulting a mental health professional.').
evaluate_mental_health_screening([Question | Rest]) :-
    write(Question), nl,
    read_line_to_string(user_input, Answer),
    process_mental_health_screening_answer(Answer),
    evaluate_mental_health_screening(Rest).

process_mental_health_screening_answer('yes') :-
    write('It\'s important to prioritize your mental health. If you have ongoing concerns, consider consulting a mental health professional.'), nl.
process_mental_health_screening_answer('no') :-
    write('If you ever feel the need to talk or seek support, consider reaching out to friends, family, or a mental health professional.'), nl.
process_mental_health_screening_answer(_) :-
    write('Invalid response. Please answer with "yes" or "no".'), nl.
