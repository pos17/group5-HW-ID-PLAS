~bus = Bus.control(s, 1);



(
SynthDef("kick", {
	arg out = 0, amp = 1, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0, env, snd, ramp, envNoise;
	// env = Env.perc(att, rel, amp).kr(doneAction:2);
	// envNoise = Env.perc(0.01,0.1).kr(doneAction: 2);
	env = EnvGen.kr(Env.perc(att, rel, amp));
	envNoise = EnvGen.kr(Env.perc(0.01, 0.01));
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = snd + SinOsc.ar(freq: XLine.ar(10000, 60, 0.01), mul: env);
	snd = snd + (PinkNoise.ar()*0.1*envNoise);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;


SynthDef("hihat", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: ffreq, mul: env);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

SynthDef("snare", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var env, snd1, snd2, sum;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd1 = HPF.ar(
		in: WhiteNoise.ar,
		freq: ffreq,
		mul: env
	);
	snd2 = SinOsc.ar(freq: sinfreq, mul: env);
	sum = snd1 + snd2;
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

SynthDef("sawSynth", { arg freq = 440, amp = 0.1, att = 0.1, rel = 3, lofreq = 1000, hifreq = 3000;
    var env, snd;
    env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
    snd = Saw.ar(freq: freq, mul: env);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
    snd = Splay.ar(snd);
    Out.ar(0, snd);
}).add;



SynthDef("bass", { arg freq = 440, amp = 0.5, gate = 1;
	var snd, env, oscfreq, output;
	oscfreq = {freq * LFNoise2.kr(0.5).range(0.98, 1.02)}!3;
	snd = Splay.ar(LFSaw.ar(oscfreq, mul: amp));
	env = Env.adsr(0.7, 4, 0, 0.1).kr(doneAction:2, gate: gate);
	snd = snd;
	output = LPF.ar(snd, (env*freq) + 2*freq);
	Out.ar(0, output);
	}).add;

)



(

Pbind(
	\instrument, "kick",
	\dur, 1/2,
	\att, 0.01,
	\rel, 0.22,
	\sinfreq, 60,
	\glissf, 0.9,
	\amp, 1,
).play;




Pbind(
	\instrument, "snare",
	\dur, Pseq([Rest(1/2), 1/2], inf),
	\att, 0.01,
	\rel, 0.1,
	\sinfreq, 180,
	\ffreq, 2000,
	\amp, 0.25

).play;



Pbind(
	\instrument, "hihat",
	\dur, Pseq([Rest(1/4), 1/4], inf),
	\att, 0.01,
	\rel, 0.1,
	\ffreq, 11000,
	\pan, 0,
	\amp, 0.3
).play;

Pbind(
    \instrument, "sawSynth",
    \midinote, Pseq(
		[60,60,72,72,67,67,67,66,66,65,65,63,63,60,63,65]
		,
        inf
    ),
	\dur, 1/8,
	\att, 0.1,
	\rel, Pkey(\dur) + 1,
	\hifreq, 5000,
    \amp, 0.2
).play;

Pbind(
	\instrument, "bass",
	\dur, 1,
	\midinote, Pseq([36,36,34,34,33,33,32,34],inf),
	\legato, 1,
	\amp, 0.3,
).play;
)



