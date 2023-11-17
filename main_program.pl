

trim_whitespace(String, Trimmed) :-
    atom_string(Atom, String),
    atom_string(Trimmed, Atom).

response_hospitals :-
    write('Sure! In which city in Thailand are you currently located?'), nl,
    read_line_to_string(user_input, RawLocation),
    trim_whitespace(RawLocation, Location),
    atom_lowercase(Location, LowercaseLocation),

    write('What type of hospitals are you interested in? Do you wanna go to Private or Goverment ones?'), nl,
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