% hospitals.pl

% Updated hospital data structure
hospital(bangkok, 'Bangkok Hospital', private, 'Private Hospital', '123 Main St', '9:00 AM - 5:00 PM').
hospital(bangkok, 'Siriraj Hospital', government, 'Government Hospital', '456 Main St', '24/7').
hospital(bangkok, 'Bumrungrad International Hospital', private, 'Private Hospital', '789 Main St', '8:00 AM - 6:00 PM').

hospital(chiangmai, 'Chiang Mai Ram Hospital', private, 'Private Hospital', '321 Main St', '8:00 AM - 5:00 PM').
hospital(chiangmai, 'McCormick Hospital', government, 'Government Hospital', '654 Main St', '24/7').
hospital(chiangmai, 'Lanna Hospital', government, 'Government Hospital', '987 Main St', '8:30 AM - 4:30 PM').

hospital(phuket, 'Bangkok Hospital Phuket', private, 'Private Hospital', '543 Main St', '9:00 AM - 6:00 PM').
hospital(phuket, 'Phuket International Hospital', private, 'Private Hospital', '876 Main St', '8:00 AM - 7:00 PM').
hospital(phuket, 'Vachira Phuket Hospital', government, 'Government Hospital', '234 Main St', '24/7').

% Updated get_hospitals/2 predicate
get_hospitals(Location, HospitalList) :-
    findall(Hospital, hospital(Location, Hospital, _, _, _, _), HospitalList).
