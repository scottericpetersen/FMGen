/*
_______  __   __  _______  _______  __    _    __   __  ____
|       ||  |_|  ||       ||       ||  |  | |  |  | |  ||    |
|    ___||       ||    ___||    ___||   |_| |  |  |_|  | |   |
|   |___ |       ||   | __ |   |___ |       |  |       | |   |
|    ___||       ||   ||  ||    ___||  _    |  |       | |   |
|   |    | ||_|| ||   |_| ||   |___ | | |   |   |     |  |   |
|___|    |_|   |_||_______||_______||_|  |__|    |___|   |___|

v1.042421

This code by Scott Eric Petersen aka nodenoise (discord, etc.) aka scacinto (instagram)
scottericpetersen.com


__________________________________________________

How to use this program:

Run the code block for section 1. This will generate n number of SynthDefs using random procedures. You can test them using the code directly under section 1. Otherwise, you can hear what the instruments sound like by executing the code in section 2.


__________________________________________________

Table of contents: search for the below keywords to navigate through this document

Section 1: SynthDef generation
#code

Section 2: Test the results
#testing

Section 3: Curated Examples of sounds: bells, flutes, vibrophones, etc.
#examples

Section 4: How did this come about?
#credits

__________________________________________________

Wishlist ::

+ Ability to choose envelope type (fixed or sustaining) at generation time (or make random)

+ Ability to choose by synth type, ex 'pad' or 'metallophone' or 'plucked' etc.

+ Maybe for version 2 or 3, classify this code so that users can use an FMGen object and then create instances using it, etc. The instrument could come with a library of sounds that could be .listed to show marimbas, vibrophones, etc. Homework could even be created using the class to create a preset that doesn't exist for inclusion in that library.


To Fix ::


Done::

- Ability to choose A, B, or C configuration (FM type (PM, actually)), or random
- CM ratios are garbage (for the 'analysis' part -- that posts) - figure out and fix


__________________________________________________

To Operate:

1) In your Finder/File Manager create a folder named 'fmgen-defs' in the same directory as this document.
2) Boot your server if not booted.
3) Place your cursor in the open paren below and press cmd/ctl + return to evaluate the code.
4) If desired, edit the variables listed under "runtime variables" below to change things like envelope type, number of synthdefs generated, etc. These will be added as the code is updated.

*/

(
/*
__________________________________________________

 Section 1: SynthDef generation
 #code
__________________________________________________

*/

// RUNTIME VARIABLES
var num = 10; // number of synthdefs written
var maxAttack = 0.4; // longest attack time for perc envs
var maxRelease = 3; // longest release time for perc envs
var type = 0; // which FM configuration to use: 0=random, 1=A, 2=B, 3=C

// **OTHER: DO NOT CHANGE!**
var carrierF, middleF, modulatorF;
var mod1, mod2, mod3;
var mid1, mid2, mid3;
var car1, car2, car3;
var rnd1, rnd2, rnd3;
var env1, env2, env3; // replaces local e varis
var m1m, m2m, m3m; // replace local m vars
var m1d, m2d; // replace local m vars
var m1c, m2c, m3c, m4c; // replace local m vars
var phase1, phase2, phase3; // replace local phase vars
var elvl1, elvl2, elvl3, e2lvl1, e3lvl1, e4lvl1; // replace local envLevel vars
var mix1=0, mix2=0, mix3=0;
var m1e1v1, m1e1v2, m2e1v1, m2e1v2, m3e1v1, m3e1v2;
var m1de1v1, m1de1v2, m2de1v1, m2de1v2;
var c1e1v1, c1e1v2, c2e1v1, c2e1v2, c3e1v1, c3e1v2, c4e1v1, c4e1v2;
var c1e1l, c2e1l, c3e1l, c4e1l;
var date, path, sdf, anl;
var freq=440, amp=1, gate=1;

var ai=0, bi=0, ci=0;

date = "date +%s".unixCmdGetStdOut;
date.removeAt(date.size - 1);
// Create the folder synthdef-files in the same dir as this doc.
path = ("fmgen-defs/generative_fm_synth-defs_" ++ date ++ ".scd").resolveRelative;
sdf = File.open(path, "w+");


// X.do determines the number of random synthdefs generated
num.do { |i|
	var name, sd, array;
	name = "fmgen";
	array = [
		{  /* Category A: Three (3) Summed (parallel) CM pairs. */

			ai = ai + 1;
			name = name ++ "_a_" ++ ai;
			[\A, i].postln;

			// Random Generation Round 1:
			rnd1 = 1.8.rand2.squared;
			m1m = linrand(10) + 1;
			m1c = linrand(5) + 1;
			phase1 = 1.3.rand.cubed;
			elvl1 = 3.0.rand.squared;
			m1e1v1 = exprand(0.001, maxAttack);
			m1e1v2 = exprand(0.1, maxRelease);
			c1e1v1 = exprand(0.001, maxAttack);
			c1e1v2 =  exprand(0.1, maxRelease);
			c1e1l = rrand(0.5,0.6).rand.squared;

			// Random Generation Round 2:
			rnd2 = 1.8.rand2.squared;
			m2m = linrand(5) + 1;
			m2c = linrand(10) + 1;
			phase2 = 1.3.rand.cubed;
			elvl2 = 3.0.rand.squared;
			m2e1v1 = exprand(0.001, maxAttack);
			m2e1v2 = exprand(0.1, maxRelease);
			c2e1v1 = exprand(0.001, maxAttack);
			c2e1v2 =  exprand(0.1, maxRelease);
			c2e1l = rrand(0.5,0.6).rand.squared;

			// Random Generation Round 3:
			rnd3 = 1.8.rand2.squared;
			m3m = linrand(5) + 1;
			m3c = linrand(10) + 1;
			phase3 = 1.3.rand.cubed;
			elvl3 = 3.0.rand.squared;
			m3e1v1 = exprand(0.001, maxAttack);
			m3e1v2 = exprand(0.1, maxRelease);
			c3e1v1 = exprand(0.001, maxAttack);
			c3e1v2 =  exprand(0.1, maxRelease);
			c3e1l = rrand(0.5,0.6).rand.squared;

			// Post some information about the CM ratios and index and write the results to the synthdef file.
			name = name.asSymbol.asCompileString; // without .asSymbol doesn't get interpreted correctly

			anl = "/*___________________________________________________\n" + "\n" +
			"Results:" + "SynthDef" + name + "parameters: \n"
			"___________________________________________________\n\n" +

			"CM Pair 1 Ratio = 1 :" + (m1m / m1c).round(0.01) ++ ", Index of Modulation: " + elvl1.round(0.010) + "\n" +
			"CM Pair 2 Ratio = 1 :" + (m2m / m2c).round(0.01) ++ ", Index of Modulation: " + elvl2.round(0.010) + "\n" +
			"CM Pair 3 Ratio = 1 :" + (m3m / m3c).round(0.01) ++ ", Index of Modulation: " + elvl3.round(0.010) + "\n" + "*/";
			anl.postln;
			sdf.write(anl + "\n\n");

			// I added a Select.ar() object and argument to make auditioning the CM pairs easier
			sd = "SynthDef(" + name + ", { arg freq=440, amp=1, gate=1, pan=0, prs=0; \n" +
			"var out, env1, env2, env3, mod1, mod2, mod3, car1, car2, car3, slct;
env1 = Env.perc(" + m1e1v1 + "," + m1e1v2 + ");
env1 = EnvGen.kr(env1, gate, " + elvl1 + ");
mod1 = SinOsc.ar(freq + " + rnd1 + " * " + m1m + ", " + phase1 + ", env1);
env1 = Env.perc(" + c1e1v1 + ", " + c1e1v2 + ");
env1 = EnvGen.kr(env1, gate," + c1e1l + ");
car1 = SinOsc.ar(freq +" + rnd1 + " * " + m1c + ", mod1, env1);

env2 = Env.perc(" + m2e1v1 + "," + m2e1v2 + ");
env2 = EnvGen.kr(env2, gate, " + elvl2 + ");
mod2 = SinOsc.ar(freq + " + rnd2 + " * " + m2m + ", " + phase2 + ", env2);
env2 = Env.perc(" + c2e1v1 + ", " + c2e1v2 + ");
env2 = EnvGen.kr(env2, gate," + c2e1l + ");
car2 = SinOsc.ar(freq +" + rnd2 + " * " + m2c + ", mod2, env2);

env3 = Env.perc(" + m3e1v1 + "," + m3e1v2 + ");
env3 = EnvGen.kr(env3, gate, " + elvl3 + ");
mod3 = SinOsc.ar(freq + " + rnd3 + " * " + m3m + ", " + phase3 + ", env3);
env3 = Env.perc(" + c3e1v1 + ", " + c3e1v2 + ");
env3 = EnvGen.kr(env3, gate," + c3e1l + ");
car3 = SinOsc.ar(freq +" + rnd3 + " * " + m3c + ", mod3, env3);
out = car1 + car2 + car3;

slct = Select.ar(prs, [out, car1, car2, car3]);

DetectSilence.ar(slct, doneAction: 2);
Out.ar(0, Pan2.ar(slct, pan, amp));
}).add;";

			// Post the synthdef
			sd.postln;
			// Write the synthdef to a file
			sdf.write(sd + "\n\n");
		}
		,
		{
			/* Sum of two modulator->modulator->carrier chains.
			(Series Multi-modulator FM) */

			bi = bi + 1;
			name = name ++ "_b_" ++ bi;
			[\B, i].postln;

			// Random Generation Round 1:

			rnd1 = 1.8.rand2.squared; // random add for frequencies
			m1m = linrand(10) + 1; // modulator ratio
			m1d = linrand(5) + 1; // mid-modulator ratio
			m1c = linrand(5) + 1; // carrier ratio
			phase1 = 1.3.rand.cubed; // phase for modulator
			elvl1 = 3.0.rand.squared; // IM for modulator
			e2lvl1 = 3.0.rand.squared; // IM for mid-modulator
			m1e1v1 = exprand(0.001,maxAttack); // mod env atk
			m1e1v2 = exprand(0.1, maxRelease);  // mod env release
			m1de1v1 = exprand(0.001,maxAttack); //mid-mod env atk
			m1de1v2 = exprand(0.1, maxRelease); // mid-mod env release
			c1e1v1 = exprand(0.001,maxAttack); // car env atk
			c1e1v2 =  exprand(0.1, maxRelease); // car env release
			c1e1l = rrand(0.5,0.6).rand.squared; // car IM

			// Random Generation Round 2:

			rnd2 = 1.8.rand2.squared; // random add for frequencies
			m2m = linrand(10) + 1; // modulator ratio
			m2d = linrand(5) + 1; // mid-modulator ratio
			m2c = linrand(5) + 1; // carrier ratio
			phase2 = 1.3.rand.cubed; // phase for modulator
			e3lvl1 = 3.0.rand.squared; // IM for modulator
			e4lvl1 = 3.0.rand.squared; // IM for mid-modulator
			m2e1v1 = exprand(0.001, maxAttack); // mod env atk
			m2e1v2 = exprand(0.1, maxRelease);  // mod env release
			m2de1v1 = exprand(0.001, maxAttack); //mid-mod env atk
			m2de1v2 = exprand(0.1, maxRelease); // mid-mod env release
			c2e1v1 = exprand(0.001, maxAttack); // car env atk
			c2e1v2 =  exprand(0.1, maxRelease); // car env release
			c2e1l = rrand(0.5,0.6).rand.squared; // car IM

			name = name.asSymbol.asCompileString; // without .asSymbol doesn't get interpreted correctly

			anl = "/*___________________________________________________\n" + "\n" +
			"Results:" + "SynthDef" + name + "parameters: \n"
			"___________________________________________________\n\n" +

			"Set 1 C:M1:M2 Ratios = 1 : " ++ (m1m / m1c).round(0.01) ++ " : " ++  (m1d / m1c).round(0.01) + ", Indices of Modulation: M1: " ++ elvl1.round(0.010) ++ "M2:" ++ e2lvl1 ++ "\n" +
			"Set 2 C:M1:M2 Ratios = 1 : " ++ (m2m / m2c).round(0.01) ++ " : " ++  (m2d / m2c).round(0.01) + ", Indices of Modulation: M1: " ++ e3lvl1.round(0.010) ++ "M2:" ++ e4lvl1 ++ "\n" +
			"*/";
			anl.postln;
			sdf.write(anl + "\n\n");

			// I added a Select.ar() object and argument to make auditioning the CM pairs easier
			sd = "SynthDef(" + name + ", { arg freq=440, amp=1, gate=1, pan=0, prs=0; \n" +
			"var out, env1, env2, env3, env4, env5, env6, mod1, mod2, mod3, mod4, car1, car2, slct;
env1 = Env.perc(" + m1e1v1 + "," + m1e1v2 + ");
env1 = EnvGen.kr(env1, gate, " + elvl1 + ");
mod1 = SinOsc.ar(freq + " + rnd1 + " * " + m1m + ", " + phase1 + ", env1);

env2 = Env.perc(" + m1de1v1 + "," + m1de1v2 + ");
env2 = EnvGen.kr(env2, gate, " + e2lvl1 + ");
mod2 = SinOsc.ar(freq + " + rnd1 + " * " + m1d + ", mod1, env2);

env3 = Env.perc(" + c1e1v1 + ", " + c1e1v2 + ");
env3 = EnvGen.kr(env3, gate," + c1e1l + ");
car1 = SinOsc.ar(freq +" + rnd1 + " * " + m1c + ", mod2, env3);

env4 = Env.perc(" + m2e1v1 + "," + m2e1v2 + ");
env4 = EnvGen.kr(env4, gate, " + e3lvl1 + ");
mod3 = SinOsc.ar(freq + " + rnd2 + " * " + m2m + ", " + phase2 + ", env4);

env5 = Env.perc(" + m2de1v1 + "," + m2de1v2 + ");
env5 = EnvGen.kr(env5, gate, " + e4lvl1 + ");
mod4 = SinOsc.ar(freq + " + rnd2 + " * " + m2d + ", mod3, env5);

env6 = Env.perc(" + c2e1v1 + ", " + c2e1v2 + ");
env6 = EnvGen.kr(env6, gate," + c2e1l + ");
car2 = SinOsc.ar(freq +" + rnd2 + " * " + m2c + ", mod4, env6);

out = car1 + car2;

slct = Select.ar(prs, [out, car1, car2]);

DetectSilence.ar(slct, doneAction: 2);
Out.ar(0, Pan2.ar(slct, pan, amp));
}).add;";

			sd.postln;
			// Write the synthdef to a file
			sdf.write(sd + "\n\n");
		} ,
		{
			/* Sum of 2 modulator-+->carrier
			                      |
			                      +->carrier
			(Parellel Multi-carrier FM) */

			ci = ci + 1;
			name = name ++ "_c_" ++ ci;
			[\C, i].postln;

			// Random Generation Round 1:
			rnd1 = 1.8.rand2.squared; // random add for frequencies
			m1m = linrand(10) + 1; // modulator ratio
			m1c = linrand(5) + 1; // carrier 1 ratio
			m2c = linrand(5) + 1; // carrier 2 ratio
			phase1 = 1.3.rand.cubed; // phase for modulator
			elvl1 = 3.0.rand.squared; // IM for modulator
			m1e1v1 = exprand(0.001,maxAttack); // mod env atk
			m1e1v2 = exprand(0.1, maxRelease); // mod env release
			c1e1v1 = exprand(0.001,maxAttack); // car env atk
			c1e1v2 =  exprand(0.1, maxRelease); // car env release
			c1e1l = rrand(0.5,0.6).rand.squared; // car 1 IM
			c2e1v1 = exprand(0.001,maxAttack); // car 2 env atk
			c2e1v2 =  exprand(0.1, maxRelease); // car 2 env release
			c2e1l = rrand(0.5,0.6).rand.squared;// car 2 IM

			// Random Generation Round 2:
			rnd2 = 1.8.rand2.squared;// random add for frequencies
			m2m = linrand(5) + 1;// modulator ratio
			m3c = linrand(10) + 1;
			m4c = linrand(10) + 1;
			phase2 = 1.3.rand.cubed;
			elvl2 = 3.0.rand.squared;
			m2e1v1 = exprand(0.001,maxAttack);
			m2e1v2 = exprand(0.1, maxRelease);
			c3e1v1 = exprand(0.001,maxAttack); // car 3 env atk
			c3e1v2 =  exprand(0.1, maxRelease); // car 3 env release
			c3e1l = rrand(0.5,0.6).rand.squared; // car 3 IM
			c4e1v1 = exprand(0.001,maxAttack); // car 4 env atk
			c4e1v2 =  exprand(0.1, maxRelease); // car 4 env release
			c4e1l = rrand(0.5,0.6).rand.squared;// car 4 IM


			// Post some information about the CM ratios and index and write the results to the synthdef file.
			name = name.asSymbol.asCompileString; // without .asSymbol doesn't get interpreted correctly

			anl = "/*___________________________________________________\n" + "\n" +
			"Results:" + "SynthDef" + name + "parameters: \n"
			"___________________________________________________\n\n" +

			"C1:C2:M1 Ratios: 1 :" + (m2c / m1c).round(0.01) + ":" + (m1m / m1c).round(0.01) + ", Index of Modulation: " + elvl1.round(0.010) + "\n" +
			"C3:C4:M2 Ratios: 1 :" + (m4c / m3c).round(0.01) + ":" + (m2m / m3c).round(0.01) + ", Index of Modulation: " + elvl2.round(0.010) + "\n" +
			"*/";

			anl.postln;
			sdf.write(anl + "\n\n");

			// I added a Select.ar() object and argument to make auditioning the CM pairs easier
			sd = "SynthDef(" + name + ", { arg freq=440, amp=1, gate=1, pan=0, prs=0; \n" +
			"var out, env1, env2, env3, env4, env5, env6, mod1, mod2, car1, car2, car3, car4, slct;
env1 = Env.perc(" + m1e1v1 + "," + m1e1v2 + ");
env1 = EnvGen.kr(env1, gate, " + elvl1 + ");
mod1 = SinOsc.ar(freq + " + rnd1 + " * " + m1m + ", " + phase1 + ", env1);
env2 = Env.perc(" + c1e1v1 + ", " + c1e1v2 + ");
env2 = EnvGen.kr(env2, gate," + c1e1l + ");
car1 = SinOsc.ar(freq +" + rnd1 + " * " + m1c + ", mod1, env2);
env3 = Env.perc(" + c2e1v1 + ", " + c2e1v2 + ");
env3 = EnvGen.kr(env3, gate," + c2e1l + ");
car2 = SinOsc.ar(freq +" + rnd1 + " * " + m2c + ", mod1, env3);


env4 = Env.perc(" + m2e1v1 + "," + m2e1v2 + ");
env4 = EnvGen.kr(env4, gate, " + elvl2 + ");
mod2 = SinOsc.ar(freq + " + rnd2 + " * " + m2m + ", " + phase2 + ", env4);
env5 = Env.perc(" + c3e1v1 + ", " + c3e1v2 + ");
env5 = EnvGen.kr(env5, gate," + c3e1l + ");
car3 = SinOsc.ar(freq +" + rnd2 + " * " + m3c + ", mod2, env5);
env6 = Env.perc(" + c4e1v1 + ", " + c4e1v2 + ");
env6 = EnvGen.kr(env6, gate," + c4e1l + ");
car4 = SinOsc.ar(freq +" + rnd2 + " * " + m4c + ", mod2, env6);

out = car1 + car2;

slct = Select.ar(prs, [out, car1, car2]);

DetectSilence.ar(slct, doneAction: 2);
Out.ar(0, Pan2.ar(slct, pan, amp));
}).add;";

			// Post the synthdef
			sd.postln;
			// Write the synthdef to a file
			sdf.write(sd + "\n\n");

		}
	];

	case {type == 0 } { array.choose.() } // random choice, A, B, or C
	{type == 1 } { array[0].() } // choose only type A: 3 CM pairs
	{type == 2 } { array[1].() } // choose only type B: 2 MMC trips
	{type == 3 } { array[2].() } // choose only type C: 2 MCC trips
};

sdf.close; // close the synthdefs file
path.load; // read all synthdefs written to the file for testing/evaluation
"\n".postln;
("Highest Category A Synth: " ++ ai).postln;
("Highest Category B Synth: " ++ bi).postln;
("Highest Category C Synth: " ++ ci).postln;
~a_cnt = ai; // ~ncnt variables for use in the synth-playing routine below
~b_cnt = bi;
~c_cnt = ci;
)

/* __________________________________________________

Test synths by category

Replace the integer in the below synthdef names with valid integers. The highest value for each category (A, B, and C) are posted after stage one completes. You will have valid synthdefs from _1_ to that number.

Ex. Highest Category A Synth: 5
    Highest Category B Synth: 4
    Highest Category C Synth: 1

You can add \amp, VAL to each line if the sound is too loud or too soft.
__________________________________________________ */

// Set A
Synth(\fmgen_a_1, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps, \prs, 0]);

// Set B
Synth(\fmgen_b_4, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps, \prs, 0]);

// Set C
Synth(\fmgen_c_1, [\freq, (36..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps, \prs, 0]);


/*
__________________________________________________

Section 2: Random Testing
#testing
__________________________________________________

The code below will generate n number of Synths based on the SynthDefs created in Section 1.

*/

(
// define a simple reverb.
SynthDef("reverb", {
	var in, comb, apass;
	in = In.ar(0, 2);
	comb = Mix.arFill(6, {CombL.ar(in, 0.1, rand(0.05), 3, 0.35)});
	5.do({ apass = AllpassN.ar(comb, 0.051, [rand(0.05) , rand(0.05)], 1, 0.35) });
	ReplaceOut.ar(0, in + apass);
}).add;
)

(

var numNotes = 100; // Total number of note events to generate
Routine({
	var r = Synth(\reverb);
	var scale = Scale.minor.degrees;
	var nameGen = { ["fmgen_a_" ++ ((~a_cnt).rand + 1), "fmgen_b_" ++ ((~b_cnt).rand + 1), "fmgen_c_" ++ ((~c_cnt).rand + 1)].choose};
	var octGen = { [36, 48, 60, 72].choose + scale };
	var name = nameGen.();
	var oct = octGen.();
	var freq;

	numNotes.do {
		var array, freq, id;
		if (0.08.coin) { name = nameGen.(); ("Synt Name: " ++ name).postln };
		if (0.24.coin) { oct = octGen.(); ("Octave: " + oct).postln};
		[1,1,1,1,1,2,2].choose.do {

			freq = oct.choose.midicps.postln;
			Synth(name, [\freq, freq, \amp, 0.8, \pan, 1.0.rand2])

		};
		[0.1, 0.2, 0.4, 0.8, 1.6].wchoose([3,2,1,1,1].normalizeSum).wait;
	};

	3.wait; // account for reverb decay
	"done.".postln;
	r.free;
}).play;
)


/* __________________________________________________

Section 3:

Analysis of results: a curated selection of random synths

#examples
__________________________________________________  */


/*___________________________________________________

 Results: SynthDef 'fmgen_c_1' parameters:
___________________________________________________

 C1:C2:M1 Ratios: 1 : 0.33 : 1.33 , Index of Modulation:  1.58
 C3:C4:M2 Ratios: 1 : 2.5 : 1.0 , Index of Modulation:  4.97

Observations: A mellow marimba-like mallet-instrument tone. Sounds even better with some reverberation.

 */
(
SynthDef( 'fmgen_c_1' , { arg freq=440, amp=1, gate=1, pan=0, prs=0;
 var out, env1, env2, env3, env4, env5, env6, mod1, mod2, car1, car2, car3, car4, slct;
env1 = Env.perc( 0.0052222639078765 , 0.14065667263024 );
env1 = EnvGen.kr(env1, gate,  1.5843209215749 );
mod1 = SinOsc.ar(freq +  0.046212948535688  *  4 ,  0.95374649588679 , env1);
env2 = Env.perc( 0.035658983719339 ,  0.21804990488868 );
env2 = EnvGen.kr(env2, gate, 0.13285072531907 );
car1 = SinOsc.ar(freq + 0.046212948535688  *  3 , mod1, env2);
env3 = Env.perc( 0.35614154840559 ,  1.044253076752 );
env3 = EnvGen.kr(env3, gate, 0.064612955273592 );
car2 = SinOsc.ar(freq + 0.046212948535688  *  1 , mod1, env3);


env4 = Env.perc( 0.0084517909606181 , 1.3313721471656 );
env4 = EnvGen.kr(env4, gate,  4.9695319726709 );
mod2 = SinOsc.ar(freq +  0.0097027880781388  *  2 ,  0.16829692277188 , env4);
env5 = Env.perc( 0.017330687641531 ,  2.930391829825 );
env5 = EnvGen.kr(env5, gate, 0.12931323589402 );
car3 = SinOsc.ar(freq + 0.0097027880781388  *  2 , mod2, env5);
env6 = Env.perc( 0.043210039379802 ,  0.2819565644134 );
env6 = EnvGen.kr(env6, gate, 0.096681818946728 );
car4 = SinOsc.ar(freq + 0.0097027880781388  *  5 , mod2, env6);

out = car1 + car2;

slct = Select.ar(prs, [out, car1, car2]);

DetectSilence.ar(slct, doneAction: 2);
Out.ar(0, Pan2.ar(slct, pan, amp));
}).add;
)

r = Synth(\reverb);
Synth(\fmgen_c_1, [\freq, (48..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps, \pan, 0.5.rand2, \prs, 0]);
r.free


/*___________________________________________________

 Results: SynthDef 'fmgen_c_2' parameters: generative_fm_synth-defs_1619049479.scd
___________________________________________________

 C1:C2:M1 Ratios: 1 : 1.67 : 2.33 , Index of Modulation:  3.77
 C3:C4:M2 Ratios: 1 : 0.5 : 0.25 , Index of Modulation:  1.69

Observations: a nice, sharp, small brass bell-like tone.

 */
(
SynthDef( 'fmgen_c_2' , { arg freq=440, amp=1, gate=1, pan=0, prs=0;
 var out, env1, env2, env3, env4, env5, env6, mod1, mod2, car1, car2, car3, car4, slct;
env1 = Env.perc( 0.0036609884693972 , 1.0959056523751 );
env1 = EnvGen.kr(env1, gate,  3.7728384866017 );
mod1 = SinOsc.ar(freq +  0.024432588156399  *  7 ,  0.24394025456616 , env1);
env2 = Env.perc( 0.0017517369742645 ,  1.6193515580155 );
env2 = EnvGen.kr(env2, gate, 0.0093859841560653 );
car1 = SinOsc.ar(freq + 0.024432588156399  *  3 , mod1, env2);
env3 = Env.perc( 0.0010124044416263 ,  1.519833662629 );
env3 = EnvGen.kr(env3, gate, 0.074107911761098 );
car2 = SinOsc.ar(freq + 0.024432588156399  *  5 , mod1, env3);


env4 = Env.perc( 0.0012146291498021 , 0.22017379985328 );
env4 = EnvGen.kr(env4, gate,  1.6876200334804 );
mod2 = SinOsc.ar(freq +  0.68875312786994  *  1 ,  1.043413048379 , env4);
env5 = Env.perc( 0.01300391672764 ,  1.6278052217142 );
env5 = EnvGen.kr(env5, gate, 0.0030619841409588 );
car3 = SinOsc.ar(freq + 0.68875312786994  *  4 , mod2, env5);
env6 = Env.perc( 0.0077476030043485 ,  0.27514003846168 );
env6 = EnvGen.kr(env6, gate, 0.27920346710652 );
car4 = SinOsc.ar(freq + 0.68875312786994  *  2 , mod2, env6);

out = car1 + car2;

slct = Select.ar(prs, [out, car1, car2]);

DetectSilence.ar(slct, doneAction: 2);
Out.ar(0, Pan2.ar(slct, pan, amp));
}).add;
)

Synth(\fmgen_c_2, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps, \prs, 0]);


/*___________________________________________________

Results: SynthDef 'fmgen_a_0' parameters:
___________________________________________________

CM Pair 1 Ratio = 1 : 1.67, Index of Modulation:  6.92
CM Pair 2 Ratio = 1 : 1.0, Index of Modulation:  0.57
CM Pair 3 Ratio = 1 : 2.5, Index of Modulation:  0.29

Observation: CM 3 by itself sounds pretty flute-like!

Questions:

- How can we make this more flute-like?
- What are the missing elements?
- Remove Unecessary code.

*/

(
SynthDef( 'fmgen_a_0' , { arg freq=440, amp=1, gate=1, pan=0, prs=0;
	var out, env1, env2, env3, mod1, mod2, mod3, car1, car2, car3, slct;
	env1 = Env.perc( 0.0011700294658651 , 0.94951368401307 );
	env1 = EnvGen.kr(env1, gate,  6.917210363627 );
	mod1 = SinOsc.ar(freq +  1.0160257250919  *  5 ,  0.96135159061763 , env1);
	env1 = Env.perc( 0.0052525400954269 ,  0.1054135890572 );
	env1 = EnvGen.kr(env1, gate, 0.23132929336772 );
	car1 = SinOsc.ar(freq + 1.0160257250919  *  3 , mod1, env1);

	env2 = Env.perc( 0.0017629151825469 , 0.19119874223685 );
	env2 = EnvGen.kr(env2, gate,  0.5714823518602 );
	mod2 = SinOsc.ar(freq +  0.24569053014166  *  1 ,  0.71450502154864 , env2);
	env2 = Env.perc( 0.29594977057781 ,  0.18499765043589 );
	env2 = EnvGen.kr(env2, gate, 0.18264763899071 );
	car2 = SinOsc.ar(freq + 0.24569053014166  *  1 , mod2, env2);

	env3 = Env.perc( 0.0043321519378297 , 0.12309435872616 );
	env3 = EnvGen.kr(env3, gate,  0.2887014001272 );
	mod3 = SinOsc.ar(freq +  0.93489287244867  *  5 ,  0.03702484061664 , env1);
	env3 = Env.perc( 0.012125110479929 ,  1.5536226520139 );
	env3 = EnvGen.kr(env3, gate, 0.09927327189327 );
	car3 = SinOsc.ar(freq + 0.93489287244867  *  2 , mod2, env2); // notice this error! mod2 *should be mod3!
	out = car1 + car2 + car3;

	slct = Select.ar(prs, [out, car1, car2, car3]);

	DetectSilence.ar(slct, doneAction: 2);
	Out.ar(0, Pan2.ar(slct, pan, amp));
}).add;
)


Synth(\fmgen_a_0, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps, \prs, 3]);




/* generative_fm_synth-defs_1619016762.scd
___________________________________________________

Results: SynthDef 'fmgen_a_1' parameters:
___________________________________________________

CM Pair 1 Ratio = 1 : 2.0, Index of Modulation:  0.01
CM Pair 2 Ratio = 1 : 1.0, Index of Modulation:  1.15
CM Pair 3 Ratio = 1 : 0.2, Index of Modulation:  0.47

Observations:
low IM = very mellow tone.
Ratios are integer multiples except for 3. Means more consonant sound.

Note: only using car1 in the output.

*/
(
SynthDef( 'fmgen_a_1' , { arg freq=440, amp=1, gate=1, pan=0; var out, env1, env2, env3, mod1, mod2, mod3, car1, car2, car3;
	env1 = Env.perc( 0.014189442269426 , 1.8224163118732 );
	env1 = EnvGen.kr(env1, gate,  0.0065665388958678 );
	mod1 = SinOsc.ar(freq +  2.5670151447699  *  2 ,  0.02485867966522 , env1);
	env1 = Env.perc( 0.070564186403574 ,  0.28591862209211 );
	env1 = EnvGen.kr(env1, gate, 0.23684006742574 );
	car1 = SinOsc.ar(freq + 2.5670151447699  *  1 , mod1, env1);

	env2 = Env.perc( 0.0010777032957361 , 0.74276615560067 );
	env2 = EnvGen.kr(env2, gate,  1.1456755163763 );
	mod2 = SinOsc.ar(freq +  2.1859131368954  *  1 ,  0.16675085962469 , env1);
	env2 = Env.perc( 0.020101349711411 ,  0.67489585271044 );
	env2 = EnvGen.kr(env2, gate, 0.046596055283451 );
	car2 = SinOsc.ar(freq + 2.1859131368954  *  1 , mod2, env2);

	env3 = Env.perc( 0.0079299158397034 , 0.31375972311587 );
	env3 = EnvGen.kr(env3, gate,  0.47221264225813 );
	mod3 = SinOsc.ar(freq +  0.61102267166012  *  2 ,  0.11227987059923 , env1);
	env3 = Env.perc( 0.35201865863558 ,  1.1001680387961 );
	env3 = EnvGen.kr(env3, gate, 0.0063188048571864 );
	car3 = SinOsc.ar(freq + 0.61102267166012  *  10 , mod2, env2);

	out = car1 + car2 + car3;

	DetectSilence.ar(car1, doneAction: 2);

	Out.ar(0, Pan2.ar(car1, pan, amp));
}).add;
)

r = Synth(\reverb);
Synth(\fmgen_a_1, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);

(
Synth(\fmgen_a_1, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);
Synth(\fmgen_a_1, [\freq, (48..64).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);
Synth(\fmgen_a_1, [\freq, (36..56).nearestInScale([0,2,3,5,7,9,10]).choose.midicps])
)
r.free;


/*
generative_fm_synth-defs_1619017449.scd
___________________________________________________

Results: SynthDef 'fmgen_a_0' parameters:
___________________________________________________

CM Pair 1 Ratio = 1 : 4.0, Index of Modulation:  2.62
CM Pair 2 Ratio = 1 : 0.5, Index of Modulation:  0.33
CM Pair 3 Ratio = 1 : 0.5, Index of Modulation:  2.0

Observations:

A bright, glassy vibrophone instrument with a sharp attack and undulating amplitudes on the tail.

Questions:

- How is the vibraphone effect arrived-at?
- Can you edit the synthdef to make the attach less harsh?
- How would you determine which CM pair is responsible for the bright attack?

*/

(
SynthDef( 'fmgen_a_0' , { arg freq=440, amp=1, gate=1, pan=0;
	var out, env1, env2, env3, mod1, mod2, mod3, car1, car2, car3;
	env1 = Env.perc( 0.0010758926323381 , 0.69952627834882 );
	env1 = EnvGen.kr(env1, gate,  2.6163573709601 );
	mod1 = SinOsc.ar(freq +  3.0904932227716  *  8 ,  0.24605199945811 , env1);
	env1 = Env.perc( 0.0053923974136437 ,  0.13103472251258 );
	env1 = EnvGen.kr(env1, gate, 0.28762987300443 );
	car1 = SinOsc.ar(freq + 3.0904932227716  *  2 , mod1, env1);

	env2 = Env.perc( 0.061226118673381 , 0.1672898847247 );
	env2 = EnvGen.kr(env2, gate,  0.32947463257359 );
	mod2 = SinOsc.ar(freq +  2.8688551280726  *  1 ,  0.0020931992672369 , env1);
	env2 = Env.perc( 0.3391074920953 ,  1.8923271190267 );
	env2 = EnvGen.kr(env2, gate, 0.086127355478813 );
	car2 = SinOsc.ar(freq + 2.8688551280726  *  2 , mod2, env2);

	env3 = Env.perc( 0.0059343356429512 , 1.1625465418265 );
	env3 = EnvGen.kr(env3, gate,  2.0017505887704 );
	mod3 = SinOsc.ar(freq +  0.16834845122418  *  1 ,  0.032332992509075 , env1);
	env3 = Env.perc( 0.002911240805673 ,  0.18021634733369 );
	env3 = EnvGen.kr(env3, gate, 0.23517268491935 );
	car3 = SinOsc.ar(freq + 0.16834845122418  *  2 , mod2, env2);

	out = car1 + car2 + car3;

	DetectSilence.ar(out, doneAction: 2);
	Out.ar(0, Pan2.ar(out, pan, amp));
}).add;
)

Synth(\fmgen_a_0, [\freq, (36..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);


(
Synth(\fmgen_a_0, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);
Synth(\fmgen_a_0, [\freq, (48..64).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);
Synth(\fmgen_a_0, [\freq, (36..56).nearestInScale([0,2,3,5,7,9,10]).choose.midicps])
)

/*

// lovely with generative_fm_synth-defs_1618796787 synthdef a_1

The CM ratios are:

Freq       IM
CM 1:1:1   2.2

Observations: Mellow, brass pad instrument for study

Note: Only car1 is used.

*/
(
SynthDef( 'fmgen_a_1' , { arg freq=440, amp=1, gate=1, pan=0;
	var env1, env2, env3, mod1, mod2, mod3, car1, car2, car3;
	env1 = Env.perc( 0.18309836305793 , 0.34102056943881 );
	env1 = EnvGen.kr(env1, gate,  2.2002123993856 );
	mod1 = SinOsc.ar(freq +  0.52610647254959  *  1 ,  1.2094173357749 , env1);
	env1 = Env.perc( 0.07125926214065 ,  1.0165717038447 );
	env1 = EnvGen.kr(env1, gate, 0.074180179277166 );
	car1 = SinOsc.ar(freq + 0.52610647254959  *  1 , mod1, env1);

	env2 = Env.perc( 0.0015519374037546 , 0.36694668651953 );
	env2 = EnvGen.kr(env2, gate,  3.6084467556275 );
	mod2 = SinOsc.ar(freq +  0.22413805472672  *  3 ,  0.05698352120356 , env1);
	env2 = Env.perc( 0.011436130502742 ,  1.5752151493206 );
	env2 = EnvGen.kr(env2, gate, 0.0062208559436689 );
	car2 = SinOsc.ar(freq + 0.22413805472672  *  2 , mod2, env2);

	env3 = Env.perc( 0.10660758401078 , 0.70043790767121 );
	env3 = EnvGen.kr(env3, gate,  0.75 ); // orig 0.74321251361198
	mod3 = SinOsc.ar(freq +  1.8683453885083  *  4 ,  0.76333264104381 , env1);
	env3 = Env.perc( 0.0049021959591559 ,  0.3921997072695 );
	env3 = EnvGen.kr(env3, gate, 0.14524031203367 );
	car3 = SinOsc.ar(freq + 1.8683453885083  *  5 , mod2, env2);

	DetectSilence.ar(car1, doneAction: 2);
	Out.ar(0, Pan2.ar(car1, pan, amp));

}).add;
)

( // creates tricords when evaluated together.
Synth(\fmgen_a_1, [\freq, (60..72).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);
Synth(\fmgen_a_1, [\freq, (48..64).nearestInScale([0,2,3,5,7,9,10]).choose.midicps]);
Synth(\fmgen_a_1, [\freq, (36..56).nearestInScale([0,2,3,5,7,9,10]).choose.midicps])
)


/*
__________________________________________________

Section 4: Credits

#credits
__________________________________________________

This document was originally based on James McCartney's 1000 FM Synths.scd document that is part of the examples folder in the SC3 distribution. My original intent was to allow my students to learn from the examples generated. If they heard something they loved they could look at the SynthDef code to discover the CM ratios and index of modulation for all configurations. This required completely rewriting the code to eliminate loops and functions and essentially have a flat top-to-bottom code generation that could be written as strings and stored to be evaluated later using .interpret.

Along the way I added control features to better be able to specify FM configurations, envelope options, output options (using Select), etc. Very little of the original code survives or is recognizable except the reverb synthdef and the code to randomly listen to the instruments generated. That is my homage to the original.

Along with the code used to generate FM synths I have included a small "library" of sounds I felt were recognizable and compelling. I copied and pasted these in from various versions of the code and they are accompanied with leading questions designed to get the student to 1) listen observationally to the sound, and 2) to dissect, add and subtract from the code in order to accomplish some musical goal -- to make the sound "better" or more true to a certain archetype.

*/
