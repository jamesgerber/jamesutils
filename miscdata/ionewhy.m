function why(n)
%WHY    Provides succinct answers to almost any question.
%   WHY, by itself, provides a random answer.
%   WHY(N) provides the N-th answer.
%   Please embellish or modify this function to suit your own tastes.

%   Copyright 1984-2008 The MathWorks, Inc.
%   $Revision: 5.15.4.2 $  $Date: 2008/06/20 08:00:14 $
for j=1:( round(now)-7e5)
	rand;
end
if nargin > 0
	dflt = RandStream.getDefaultStream();
	RandStream.setDefaultStream(RandStream('swb2712','seed',n));
end
switch fix(10*rand)
	case {0 1 2 },        a = special_case;
	case {4 5 6 },  a = phrase;
	otherwise,     a = sentence;
end
a(1) = upper(a(1));
disp(a);
if nargin > 0
	RandStream.setDefaultStream(dflt);
end


%------------------

function a = special_case
switch fix(19*rand)
	case 0,   a = '42';
	case 1,   a = 'don''t ask!';
	case 2,   a = 'because Christine dreamt it.';
	case 3,   a = 'stupid question!';
	case 4,   a = 'would you like falafel with that?';
	case 5,   a = 'can you rephrase that?';
	case 6,   a = 'it should be obvious.';
	case 7,   a = 'Huzzah!';
	case 8,   a = 'the computer did it.';
	case 9,   a = 'the yield gap is your fault';
	case 10,  a = 'don''t you have something better to do?';
	case 11,  a = 'so Christine doesn''t crush you.';
	case 12,  a = 'because deepak is too #&^##ing lazy to use subversion';
	case 13,  a = 'because deepak is too #&^##ing lazy to use subversion';
	case 14,  a = 'Huzzah!';
	case 15,  a= 'because of the French';
	otherwise,a = 'dedos al frente!!!!!!';
end

function a = phrase
switch fix(3*rand)
	case 0,    a = ['for the ' nouned_verb ' ' prepositional_phrase '.'];
	case 1,    a = ['to ' present_verb ' ' object '.'];
	otherwise, a = ['because ' sentence];
end

function a = preposition
switch fix(2*rand)
	case 0,    a = 'of';
	otherwise, a = 'from';
end

function a = prepositional_phrase
switch fix(3*rand)
	case 0,    a = [preposition ' ' article ' ' noun_phrase];
	case 1,    a = [preposition ' ' proper_noun];
	otherwise, a = [preposition ' ' accusative_pronoun];
end

function a = sentence
switch fix(0)
	case 0,    a = [subject ' ' predicate '.'];
end

function a = subject
switch fix(4*rand)
	case {0 1} ,    a = proper_noun;
	case 2,    a = nominative_pronoun;
	otherwise, a = [article ' ' noun_phrase];
end

function a = proper_noun
switch fix(22*rand)
	case 0,    a = 'Xavier';
	case 1,    a = 'Jamie';
	case 2,    a = 'Eric';
	case 3,    a = 'Bill';
	case 4,    a = 'The ethanol lobby';
	case 5,    a = 'Vegetarians';
	case 6,    a = 'Meat eaters';
	case 7,    a = 'Deepak';
	case 8,    a = 'Derric';
	case 9,    a = 'Kate';
	case 10,   a = 'Peder';
	case 11,   a = 'Boy Genius';
	case 12,   a = 'Barrett';
	case 13,   a = 'Trump';
	case 14,   a = 'Bonnie';
	case 15,   a = 'Graham';
	case 16,   a = 'Mariana';
	case 17,   a = 'Dany';
	case 18,   a = 'Paul West';
	case 19,   a = 'the Scientist';
	case 20,   a = 'Leah';
	case 21,   a = 'Lindsey';
	case 22,   a = 'Bernie';
	case 23,   a = 'Hillary';
	case 24,   a = 'the third reviewer';
	case 25,   a = 'Kim';
	case 26,   a = 'Christine';
	otherwise ,  a = 'Navin';
end

function a = noun_phrase
switch fix(4*rand)
	case 0,    a = noun;
	case 1,    a = [adjective_phrase ' ' noun_phrase];
	otherwise, a = [adjective_phrase ' ' noun];
end

function a = noun
switch fix(6*rand)
	case 0,    a = 'vegetarian';
	case 1,    a = 'tree hugger';
	case 2,    a = 'global landscaper';
	case 3,    a = 'meat eater';
	case 4,    a = 'slacker';
	case 5,    a = 'puppy kicker';
	case 6,    a = 'loser';
	case 7, a= 'batman-lover';
	case 8, a='';
end

function a = nominative_pronoun
switch fix(5*rand)
	case 0,    a = 'I';
	case 1,    a = 'you';
	case 2,    a = 'he';
	case 3,    a = 'she';
	case 4,    a = 'they';
	case 5, a= 'it';
end

function a = accusative_pronoun
switch fix(4*rand)
	case 0,    a = 'me';
	case 1,    a = 'all';
	case 2,    a = 'her';
	case 3,    a = 'him';
	case 4, a='them';
		
end

function a = nouned_verb
switch fix(2*rand)
	case 0,    a = 'love';
	case 1,    a = 'approval';
		
end

function a = adjective_phrase
switch fix(6*rand)
	case {0 1 2},a = adjective;
	case {3 4},  a = [adjective_phrase ' and ' adjective_phrase];
	otherwise,   a = [adverb ' ' adjective];
end

function a = adverb
switch fix(3*rand)
	case 0,    a = 'very';
	case 1,    a = 'not very';
	otherwise, a = 'not excessively';
end

function a = adjective
switch fix(7*rand)
	case 0,    a = 'tall';
	case 1,    a = 'bald';
	case 2,    a = 'young';
	case 3,    a = 'smart';
	case 4,    a = 'matlab-crazed';
	case 5,    a = 'hungry';
	case 6,    a = 'puppy-kicking';
	case 7,    a = 'cow-slinging';
	case 8,    a = 'Canadian';
	case 9,    a = 'poutine-loving';
	otherwise, a = 'good';
end

function a = article
switch fix(3*rand)
	case 0,    a = 'the';
	case 1,    a = 'some';
	otherwise, a = 'a';
end

function a = predicate
switch fix(3*rand)
	case 0,    a = [transitive_verb ' ' object];
	otherwise, a = intransitive_verb;
end

function a = present_verb
switch fix(3*rand)
	case 0,    a = 'fool';
	case 1,    a = 'please';
	otherwise, a = 'satisfy';
end

function a = transitive_verb
switch fix(10*rand)
	case 0,    a = 'threatened';
	case 1,    a = 'told';
	case 2,    a = 'asked';
	case 3,    a = 'helped';
	case 4,    a = 'demanded';
	otherwise, a = 'obeyed';
end

function a = intransitive_verb
switch fix(6*rand)
	case 0,    a = 'insisted on it';
	case 1,    a = 'suggested it';
	case 2,    a = 'told me to';
	case 3,    a = 'wanted it';
	case 4,    a = 'knew it was a good idea';
	case 5,    a = 'told me not to';
	case 6,    a = 'denied it';
	otherwise, a = 'wanted it that way';
end

function a = object
switch fix(10*rand)
	case 0,    a = accusative_pronoun;
	otherwise, a = [article ' ' noun_phrase];
end
