% science_expert_system.pl
% --------------------------------------------------------
% Interactive Science Expert System Chatbot
% Covers: Biology, Chemistry, and Math
% --------------------------------------------------------
% Run:
% ?- ['science_expert_system.pl'].
% ?- start.
% --------------------------------------------------------

:- style_check(-singleton).


:- use_module(library(plunit)).

% ============================================
% KNOWLEDGE BASE - BIOLOGY
% ============================================

organism(human, animalia, eukaryotic, heterotroph).
organism(e_coli, bacteria, prokaryotic, heterotroph).
organism(yeast, fungi, eukaryotic, heterotroph).
organism(spirulina, bacteria, prokaryotic, autotroph).
organism(oak_tree, plantae, eukaryotic, autotroph).

has_organelles(human, nucleus).
has_organelles(human, mitochondria).
has_organelles(yeast, nucleus).
has_organelles(yeast, mitochondria).
has_organelles(spirulina, thylakoid).

photosynthesis_requirements(Organism, [light, carbon_dioxide, water, chlorophyll]) :-
    organism(Organism, plantae, _, autotroph).
photosynthesis_requirements(Organism, [light, carbon_dioxide, water, phycobilins]) :-
    organism(Organism, bacteria, _, autotroph).

classify_organism(Name, king(K)) :- organism(Name, K, _, _).
classify_organism(Name, celltype(C)) :- organism(Name, _, C, _).
classify_organism(Name, nutrition(N)) :- organism(Name, _, _, N).

is_plant(Organism) :- organism(Organism, plantae, _, _).

suggested_topic(Organism, 'cell structure') :- has_organelles(Organism, _).
suggested_topic(Organism, 'metabolism') :- organism(Organism, _, _, heterotroph).
suggested_topic(Organism, 'photosynthesis') :- is_plant(Organism).

% ============================================
% KNOWLEDGE BASE - CHEMISTRY
% ============================================

element(h, hydrogen, 1, 1.008).
element(o, oxygen, 8, 15.999).
element(c, carbon, 6, 12.011).
element(na, sodium, 11, 22.99).
element(cl, chlorine, 17, 35.45).
element(s, sulfur, 16, 32.06).

compound('H2O', [h-2, o-1]).
compound('CO2', [c-1, o-2]).
compound('NaCl', [na-1, cl-1]).
compound('HCl', [h-1, cl-1]).
compound('NaOH', [na-1, o-1, h-1]).

molar_mass(Compound, Mass) :-
    compound(Compound, Pairs),
    molar_mass_pairs(Pairs, 0.0, Mass).

molar_mass_pairs([], Acc, Acc).
molar_mass_pairs([Sym-Count | Rest], Acc, Mass) :-
    element(Sym, _, _, AtMass),
    Sub is AtMass * Count,
    NewAcc is Acc + Sub,
    molar_mass_pairs(Rest, NewAcc, Mass).

moles_from_mass(Compound, MassGrams, Moles) :-
    molar_mass(Compound, M),
    M > 0.0,
    Moles is MassGrams / M.

can_react('HCl', 'NaOH', 'NaCl + H2O').
can_react('NaOH', 'HCl', 'NaCl + H2O').

pH_of_solution(HPlusConc, P) :-
    HPlusConc > 0,
    P is - (log(HPlusConc) / log(10)).

% ============================================
% KNOWLEDGE BASE - MATH
% ============================================

convert_units(mass, grams, kilograms, V, R) :- R is V / 1000.
convert_units(mass, kilograms, grams, V, R) :- R is V * 1000.
convert_units(length, centimeters, meters, V, R) :- R is V / 100.
convert_units(length, meters, centimeters, V, R) :- R is V * 100.

average(List, Avg) :- sum_list(List, Sum), length(List, L), L > 0, Avg is Sum / L.

reaction_coeffs('combustion_methane', [('CH4',1),('O2',2),('CO2',1),('H2O',2)]).

% ============================================
% CHATBOT ENGINE
% ============================================

start :-
    nl, write('======================================='), nl,
    write('     WELCOME TO SCIENCE EXPERT BOT'), nl,
    write('======================================='), nl,
    write('This expert system combines knowledge from three main areas:'), nl,
    write('Biology  - Organisms, classification, photosynthesis, etc.'), nl,
    write('Chemistry - Elements, compounds, reactions, pH, molar mass.'), nl,
    write('Math      - Unit conversions, averages, simple formulas.'), nl, nl,
    write('You can explore each stream by typing its number below.'), nl, nl,
    write('1. Biology'), nl,
    write('2. Chemistry'), nl,
    write('3. Math'), nl,
    write('Type the number of your choice followed by a period.'), nl,
    read(Choice),
    handle_choice(Choice).

handle_choice(1) :- explain_biology, biology_chat.
handle_choice(2) :- explain_chemistry, chemistry_chat.
handle_choice(3) :- explain_math, math_chat.
handle_choice(_) :- write('Invalid choice. Try again.'), nl, start.

% --------------------------------------------
% Knowledge Descriptions
% --------------------------------------------

explain_biology :-
    nl, write('----------------------------------------'), nl,
    write('BIOLOGY KNOWLEDGE BASE SUMMARY'), nl,
    write('----------------------------------------'), nl,
    write('- Includes facts about organisms like humans, yeast, e.coli, and oak trees.'), nl,
    write('- Can classify organisms by kingdom, cell type, and nutrition type.'), nl,
    write('- Can describe photosynthesis requirements for autotrophs.'), nl,
    write('- Suggests biology topics to study based on the organism.'), nl,
    write('- Examples:'), nl,
    write('  classify_organism(oak_tree, X).'), nl,
    write('  photosynthesis_requirements(oak_tree, R).'), nl,
    write('  suggested_topic(yeast, T).'), nl, nl.

explain_chemistry :-
    nl, write('----------------------------------------'), nl,
    write('CHEMISTRY KNOWLEDGE BASE SUMMARY'), nl,
    write('----------------------------------------'), nl,
    write('- Knows basic elements (H, O, C, Na, Cl, S) and their atomic masses.'), nl,
    write('- Knows compounds like H2O, CO2, NaCl, HCl, NaOH.'), nl,
    write('- Can calculate molar masses and moles from mass.'), nl,
    write('- Can simulate simple acid-base reactions (HCl + NaOH).'), nl,
    write('- Can calculate pH from hydrogen ion concentration.'), nl,
    write('- Examples:'), nl,
    write('  molar_mass(\'H2O\', M).'), nl,
    write('  moles_from_mass(\'H2O\', 18.0, Moles).'), nl,
    write('  can_react(\'HCl\', \'NaOH\', Product).'), nl,
    write('  pH_of_solution(1e-7, P).'), nl, nl.

explain_math :-
    nl, write('----------------------------------------'), nl,
    write('MATH KNOWLEDGE BASE SUMMARY'), nl,
    write('----------------------------------------'), nl,
    write('- Supports unit conversions (mass, length).'), nl,
    write('- Can calculate averages of numeric lists.'), nl,
    write('- Stores example chemical reaction coefficients.'), nl,
    write('- Examples:'), nl,
    write('  convert_units(mass, grams, kilograms, 2500, Out).'), nl,
    write('  average([10,20,30], Avg).'), nl, nl.

% --------------------------------------------
% Biology chatbot
% --------------------------------------------

biology_chat :-
    nl, write('You are now in the Biology stream!'), nl,
    write('Ask any biology-related question or type "back." to go to main menu.'), nl,
    biology_loop.

biology_loop :-
    write('Bio> '),
    read(Input),
    ( Input == back -> start
    ; call(Input),
      fail
    ; biology_loop).

% --------------------------------------------
% Chemistry chatbot
% --------------------------------------------

chemistry_chat :-
    nl, write('You are now in the Chemistry stream!'), nl,
    write('Ask any chemistry-related question or type "back." to go to main menu.'), nl,
    chemistry_loop.

chemistry_loop :-
    write('Chem> '),
    read(Input),
    ( Input == back -> start
    ; call(Input),
      fail
    ; chemistry_loop).

% --------------------------------------------
% Math chatbot
% --------------------------------------------

math_chat :-
    nl, write('You are now in the Math stream!'), nl,
    write('Ask any math-related question or type "back." to go to main menu.'), nl,
    math_loop.

math_loop :-
    write('Math> '),
    read(Input),
    ( Input == back -> start
    ; call(Input),
      fail
    ; math_loop).

% ============================================
% TESTS
% ============================================

:- begin_tests(science_demo).
test(molar_mass_h2o) :- molar_mass('H2O', M), M > 17.9, M < 18.1.
test(moles_calc) :- moles_from_mass('H2O', 18.0, X), X > 0.99, X < 1.01.
test(classify_e_coli) :- classify_organism(e_coli, king(bacteria)).
:- end_tests(science_demo).

% ============================================
% END OF FILE
% ============================================
