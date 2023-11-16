write_hotline_responses :-
    write('Please select a category for emergency hotlines:'), nl,
    write('1. Medical Emergencies'), nl,
    write('2. Mental Health Support'), nl,
    write('3. General Assistance'), nl,
    repeat,
    read_line_to_codes(user_input, CategoryCode),
    atom_codes(CategoryAtom, CategoryCode),
    atom_number(CategoryAtom, Category),
    process_hotline_category(Category),
    valid_category(Category),
    !.

valid_category(1).
valid_category(2).
valid_category(3).

process_hotline_category(1) :-  
    write_medical_hotlines.

process_hotline_category(2) :-  
    write_mental_health_hotlines.

process_hotline_category(3) :-  
    write_general_assistance_hotlines.

process_hotline_category(Other) :-
    write('Oh! I am sorry, it seems you selected invalid number: '), write(Other), nl,
    write('Please choose a valid category again.'), nl,
    fail.

write_medical_hotlines :-
    write('Here Medical Emergency Hotlines:'), nl,
    write('- Thailand Emergency Medical Services (EMS): 1669'), nl,
    write('- Thai Red Cross Society: 1554'), nl,
    nl.

write_mental_health_hotlines :-
    write('Here Mental Health Support Hotlines:'), nl,
    write('- National Suicide Prevention Lifeline: 1-800-273-TALK'), nl,
    write('- Thailand Mental Health Hotline: 1323'), nl,
    nl.

write_general_assistance_hotlines :-
    write('General Assistance Hotlines:'), nl,
    write('- Emergency Police Assistance: 191'), nl,
    write('- Tourist Police: 1155'), nl,
    nl.
