%flu
symptom('fever', 'flu').
symptom('cough', 'flu').
symptom('runny_nose', 'flu').
symptom('sore_throat', 'flu').

%cold
symptom('fever', 'cold').
symptom('cough', 'cold').
symptom('runny_nose', 'cold').
symptom('sore_throat', 'cold').

%migraine
symptom(headache, migraine).
symptom(sensitivity_to_light, migraine).
symptom(nausea, migraine).

%pnuemonia
symptom(cough, pneumonia).
symptom(fever, pneumonia).
symptom(shortness_of_breath, pneumonia).
symptom(chest_pain, pneumonia).

%heart disease
symptom(chest_pain, heart_disease).
symptom(shortness_of_breath, heart_disease).
symptom(fatigue, heart_disease).
symptom(dizziness, heart_disease).
symptom(irregular_heartbeat, heart_disease).

%diabetes
symptom(increased_thirst, diabetes).
symptom(frequent_urination, diabetes).
symptom(blurred_vision, diabetes).
symptom(fatigue, diabetes).

%asthma
symptom(shortness_of_breath, asthma).
symptom(wheezing, asthma).
symptom(chest_tightness, asthma).
symptom(cough, asthma).

%skin rash
symptom(skin_rash, general_skin_rash).
symptom(redness, general_skin_rash).
symptom(itchiness, general_skin_rash).
symptom(swelling, general_skin_rash).
