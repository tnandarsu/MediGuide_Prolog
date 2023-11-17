% hospitals.pl

% Updated hospital data structure
hospital(bangkok, 'Bangkok Hospital', private, 'Private Hospital', '2 Soi Soonvijai 7, New Petchburi Rd, Bang Kapi, Huai Khwang, Bangkok 10310', '24/7').
hospital(bangkok, 'Siriraj Hospital', government, 'Government Hospital', '2 Wang Lang Road, Siriraj, Bangkok Noi, Bangkok 10700', '24/7').
hospital(bangkok, 'Bumrungrad International Hospital', private, 'Private Hospital', '33 Sukhumvit 3 (Soi Nana Nua), Wattana, Bangkok 10110', '24/7').
hospital(bangkok, 'Rajavithi Hospital', government, 'Government Hospital', '2 Phayathai Rd, Ratchathewi, Bangkok 10400', '24/7').
hospital(bangkok, 'Samitivej Hospital', private, 'Private Hospital', '111 Sukhumvit Rd', '24/7').
hospital(bangkok, 'BHN Hospital', private, 'Private Hospital', '222 Rama IV Rd', '24/7').

hospital(chiangmai, 'Chiang Mai Ram Hospital', private, 'Private Hospital', '8 Boonreungrit Rd, A. Muang, Chiang Mai 50200', '24/7').
hospital(chiangmai, 'McCormick Hospital', government, 'Government Hospital', '133 Kaewnawarat Rd, Wat Ket, Mueang Chiang Mai, Chiang Mai 50000', '24/7').
hospital(chiangmai, 'Lanna Hospital', government, 'Government Hospital', '1 Sukkasem Rd, A. Muang, Chiang Mai 50300', '24/7').
hospital(phuket, 'Mission Hospital Phuket', private, 'Private Hospital', '345 Beach Rd', '24/7').
hospital(phuket, 'Patong Hospital', government, 'Government Hospital', '456 Jungceylon Rd', '24/7').

hospital(phuket, 'Bangkok Hospital Phuket', private, 'Private Hospital', '2/1 Hongyok Utis Rd, Wichit, Amphoe Mueang Phuket, Phuket 83000', '24/7').
hospital(phuket, 'Phuket International Hospital', private, 'Private Hospital', '44 Chalermprakiat Ror 9 Rd, Wichit, Amphoe Mueang Phuket, Phuket 83000', '24/7').
hospital(phuket, 'Vachira Phuket Hospital', government, 'Government Hospital', '353 Yaowarat Rd, Talat Yai, Amphoe Mueang Phuket, Phuket 83000', '24/7').
hospital(chiangmai, 'Chiang Mai University Hospital', government, 'Government Hospital', '789 Suthep Rd', '24/7').
hospital(chiangmai, 'Lamphun Hospital', government, 'Government Hospital', '987 Lampang Rd', '24/7').

get_hospitals(Location, Preference, HospitalList) :-
    findall(Hospital, hospital(Location, Hospital, Preference, _, _, _), HospitalList).
