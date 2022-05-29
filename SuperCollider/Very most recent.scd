(
Server.default.options.inDevice_("Microfono MacBook Pro");
Server.default.options.outDevice_("Altoparlanti MacBook Pro");
)

(
//LOAD PATTERNS
~scale = 13;
~patterns = [
	[[0,36,36,39,39,38,34,31]+[0,~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/8,1/4,3/8,1/4,1/4,3/8,1/8,1/4]],

	[[36,39,36,36,34,32,31]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/2,3/8,1/4,1/8,1/4,1/4,1/4]],

	[[39,43,39,38,39,38,36]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/8,5/8,1/8,3/8,1/4,1/4,1/4]],

[[36,36,39,36,43,43,39,38]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/4,1/4,1/4,1/8,3/8,1/4,1/4,1/4]],
	[[36,36,36,36,36,36,39,38,39]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/4,1/4,1/4,1/4,1/4,1/4,1/8,1/4,1/8]]
];

~arpPatterns1 =[[[36,39,43,46]+[~scale+12,~scale+12,~scale+12,~scale+12],[3/4,1/2,1/4,1/2]],[[36,43,48,46,46,39]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[3/8,1/4,1/4,1/2,1/2,1/8]],[[36,46,43,46,39,38,36,48,46,43,48,46,39,36]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[1/6,1/6,1/6,1/6,3/36,3/36,1/6,1/6,3/36,3/36,1/6,1/6,1/6,1/6]],[[36,39,43,46,48,46,43,36]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12], [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]]];

~arpPatterns2 = [[[36,46,43,39]+[~scale+12,~scale+12,~scale+12,~scale+12],[3/4,1/2,1/4,1/2]],[[48,43,46,36,39,43]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[3/8,1/4,1/4,1/2,1/2,1/8]],[[43,43,43,43,36,38,39,48,46,36,39,43,39,36]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[1/6,1/6,1/6,1/6,3/36,3/36,1/6,1/6,3/36,3/36,1/6,1/6,1/6,1/6]],[[43,39,43,46,43,46,48,46]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12], [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]]];

~arpPatterns3 = [[[46,43,39,36]+[~scale+12,~scale+12,~scale+12,~scale+12],[3/4,1/2,1/4,1/2]],[[36,36,36,43,39,46]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[3/8,1/4,1/4,1/2,1/2,1/8]],[[39,43,36,39,36,38,39,48,46,36,39,39,39,48]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[1/6,1/6,1/6,1/6,3/36,3/36,1/6,1/6,3/36,3/36,1/6,1/6,1/6,1/6]],[[36,48,36,48,36,48]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12], [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]]];


~chords = [[36,39,43]+[~scale,~scale,~scale], [38,41,45]+[~scale,~scale,~scale], [39,43,46]+[~scale,~scale,~scale], [41,44,48]+[~scale,~scale,~scale],[31,34,38]+[~scale,~scale,~scale],[32,36,39]+[~scale,~scale,~scale],[34,38,41]+[~scale,~scale,~scale]];

~drums = [[2,1,1/2],//kicksDur
	[1/2,1/4,1/8]];//HihatDur


~bus = Bus.control(s, 1);
~patternNote = Pseq(~patterns[0][0],inf);
~patternDur = Pseq(~patterns[0][1],inf);
~chord = Pseq([
		[60, 63, 67]+[~scale,~scale,~scale], //C-
		/*[67, 70, 74], //Eb
		[62, 67, 70], //G-
		[65, 69, 72]*/], //F
	inf);
~arpNote = Pseq(~arpPatterns[0][0],inf);
~arpDur = Pseq(~arpPatterns[0][1],inf);

~arpNum = 1;
~kickDur = 1;
~hiHatDur = 1/2;
~numDrums = 2;
~numPattern =4;
~arp =1;

~f = {
~patterns = [
	[[0,36,36,39,39,38,34,31]+[0,~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/8,1/4,3/8,1/4,1/4,3/8,1/8,1/4]],

	[[36,39,36,36,34,32,31]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/2,3/8,1/4,1/8,1/4,1/4,1/4]],

	[[39,43,39,38,39,38,36]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/8,5/8,1/8,3/8,1/4,1/4,1/4]],

[[36,36,39,36,43,43,39,38]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/4,1/4,1/4,1/8,3/8,1/4,1/4,1/4]],
	[[36,36,36,36,36,36,39,38,39]+[~scale,~scale,~scale,~scale,~scale,~scale,~scale,~scale,~scale],[1/4,1/4,1/4,1/4,1/4,1/4,1/8,1/4,1/8]]
];


~arpPatterns1 =[[[36,39,43,46]+[~scale+12,~scale+12,~scale+12,~scale+12],[3/4,1/2,1/4,1/2]],[[36,43,48,46,46,39]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[3/8,1/4,1/4,1/2,1/2,1/8]],[[36,46,43,46,39,38,36,48,46,43,48,46,39,36]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[1/6,1/6,1/6,1/6,3/36,3/36,1/6,1/6,3/36,3/36,1/6,1/6,1/6,1/6]],[[36,39,43,46,48,46,43,36]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12], [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]]];

~arpPatterns2 = [[[36,46,43,39]+[~scale+12,~scale+12,~scale+12,~scale+12],[3/4,1/2,1/4,1/2]],[[48,43,46,36,39,43]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[3/8,1/4,1/4,1/2,1/2,1/8]],[[43,43,43,43,36,38,39,48,46,36,39,43,39,36]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[1/6,1/6,1/6,1/6,3/36,3/36,1/6,1/6,3/36,3/36,1/6,1/6,1/6,1/6]],[[43,39,43,46,43,46,48,46]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12], [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]]];

~arpPatterns3 = [[[46,43,39,36]+[~scale+12,~scale+12,~scale+12,~scale+12],[3/4,1/2,1/4,1/2]],[[36,36,36,43,39,46]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[3/8,1/4,1/4,1/2,1/2,1/8]],[[39,43,36,39,36,38,39,48,46,36,39,39,39,48]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12],[1/6,1/6,1/6,1/6,3/36,3/36,1/6,1/6,3/36,3/36,1/6,1/6,1/6,1/6]],[[36,48,36,48,36,48]+[~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12,~scale+12], [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]]];

~arpPatterns2 = [~arpPatterns1,~arpPatterns2,~arpPatterns3];

	~arpPatterns = ~arpPatterns2[3.rand];

~ran = 7.rand;
	Pdefn(\chord,Pseq([~chords[~ran]],inf));
Pdefn(\arp,~arp);
Pdefn(\patternNote,Pseq(~patterns[~numPattern][0],inf));
Pdefn(\patternDur,Pseq(~patterns[~numPattern][1],inf));
Pdefn(\arpNote,Pseq(~arpPatterns[~arpNum][0],inf));
Pdefn(\arpDur,Pseq(~arpPatterns[~arpNum][1],inf));

Pdefn(\kickDur,~drums[0][~numDrums]);
Pdefn(\hiHatDur, ~drums[1][~numDrums]);
	TempoClock.default.tempo*2.wait;
};

t = Task({ ~f.loop });
t.start;

SynthDef("kick", {
	arg out = 0, amp = 1, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0, env, snd, ramp, envNoise;
	// env = Env.perc(att, rel, amp).kr(doneAction:2);
	// envNoise = Env.perc(0.01,0.1).kr(doneAction: 2);
	env = EnvGen.kr(Env.perc(att, rel, amp), doneAction: 2);
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


SynthDef("snare", {arg out = 0, amp = 1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 500, pan = 0;
	var env, envNoise, snd1, snd2, sum;
	env = EnvGen.kr(Env.perc(att, rel, amp), doneAction:2);
	envNoise = EnvGen.kr(Env.perc(att*0.5, rel*0.5, amp*1.1), Done.freeSelf);
	snd1 = HPF.ar(
		in: WhiteNoise.ar,
		freq: ffreq,
		mul: envNoise
	);
	snd2 = SinOsc.ar(sinfreq, mul:env);
	sum = LPF.ar(snd1 + snd2*0.3,7000);
	Out.ar(out, Pan2.ar(sum, pan));
}).add;


SynthDef("sawSynth", { arg freq = 440, amp = 0.1, att = 0.01, rel = 0.05, lofreq = 1000, hifreq = 3000;
    var env, snd;
    env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
    snd = Saw.ar(freq: freq, mul: env*2);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
    snd = Splay.ar(snd);
    Out.ar(0, snd);
}).add;




SynthDef("juno", {arg freq = 440, amp = 0.1, gate = 1, out=0, unison=1, cutoff=1000, rq=1.5, delay=0.2, mod=0.3;
	var snd1, snd2, snd3, env, envFilt, mix, chorus, lfo, sig, maxdelay;
	env = EnvGen.kr(Env.adsr(0.01, 0, 1, 2), gate:gate, doneAction: 2);
	envFilt = EnvGen.kr(Env.adsr(1.5, 0, 1, 2), gate:gate, doneAction: 2);

	mix = Splay.arFill(7, {Saw.ar(freq:freq*[Rand(0.98, 1.02), Rand(0.98, 1.02)], mul:env)});

	mix = amp*RLPF.ar(mix, freq:cutoff*2*envFilt, rq:rq);


	maxdelay = 0.03;
	lfo = SinOsc.kr(0.1);
	chorus = DelayC.ar(mix, maxdelay, lfo.range(0.01, 0.02));

	sig = 2*(1-mod)*mix + mod*chorus;


	Out.ar(0, sig*amp,200);
}).add;

SynthDef("juno2", {arg freq = 440, amp = 1, gate = 1, out=0, unison=1, cutoff=2000, rq=1.5, delay=0.2, mod=1;
	var snd1, snd2, snd3, env, envFilt, mix, chorus, lfo, sig, maxdelay;
	env = EnvGen.kr(Env.adsr(0.01, 0.2, 0, 0), gate:gate, doneAction: 2);
	envFilt = SinOsc.kr(0.1).range(0.9, 1.1);

	mix = Splay.arFill(7, {Saw.ar(freq:freq*[Rand(0.98, 1.02), Rand(0.98, 1.02)], mul:env)});

	mix = amp*RLPF.ar(mix, freq:cutoff*envFilt, rq:rq);

	maxdelay = 0.03;
	lfo = SinOsc.kr(0.1);
	chorus = DelayC.ar(mix, maxdelay, lfo.range(0.01, 0.02));

	sig = 2*(1-mod)*mix + mod*chorus;

	Out.ar(0, FreeVerb.ar(HPF.ar(sig*amp,200),0.3));
}).add;

SynthDef("juno3", {arg freq = 440, amp = 1, gate = 1, out=0, unison=1, cutoff=200, rq=1, delay=0.2, mod=0;
	var snd1, snd2, snd3, env, envFilt, mix, chorus, lfo, sig, maxdelay;
	env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.8, 0.7), gate:gate, doneAction: 2);
	// envFilt = SinOsc.kr(0.1).range(0.9, 1.1);

	// mix = Splay.arFill(1, {Saw.ar(freq:freq*[Rand(0.98, 1.02), Rand(0.98, 1.02)], mul:env)});
	mix = Splay.ar(amp*env*Pulse.ar(freq, 0.5));

	mix = RLPF.ar(mix, freq:cutoff, rq:rq);

	maxdelay = 0.03;
	lfo = SinOsc.kr(0.1);
	chorus = DelayC.ar(mix, maxdelay, lfo.range(0.01, 0.02));

	sig = 2*(1-mod)*mix + mod*chorus;


	Out.ar(0, sig*amp);
}).add;


SynthDef(\bass, { |outbus, midinote = 42|
  var freq = midinote.midicps;
  var subfreq = freq / 2;

  // Envelopes
  var subenv = EnvGen.kr(Env.perc(0, 1), doneAction:2);
  var env = EnvGen.kr(Env.perc(0, 0.5));

  // Component synthesis
  var pluck = Pluck.ar(PinkNoise.ar, 1, 0.2, subfreq.reciprocal) * subenv * 2;
  var tri = VarSaw.ar(freq) * env;
  var sin = SinOsc.ar(freq) * env;
  var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
  var click = RLPF.ar(Impulse.ar(0), [2000, 8000], 1).sum * 1000;

  // Initial signal
  var sig = pluck + tri;

  // Resonant LPFs
  sig = RLPF.ar(sig, XLine.ar(freq * 100, freq * 10, 0.15));
  sig = sig + (MoogFF.ar(sig, freq * 20, 2.5) * 0.1);

  // EQ resulting signal
  sig = BPeakEQ.ar(sig, 400, 0.5, -9);
  sig = BPeakEQ.ar(sig, 2000, 0.5, 6);
  sig = BHiShelf.ar(sig, 8000, 1, 3);
  sig = BPeakEQ.ar(sig, 200, 1, 3);

  // Apply another envelope to dampen a bit more
  sig = sig * XLine.kr(1, 0.6, 0.1);

  // Tanh distortion / limiting
  sig = (sig * 1).tanh;

  // Another round of signal coloring, using another RLPF
  // and sine components
  sig = sig + RLPF.ar(sig, XLine.ar(freq * 100, freq * 10, 0.15)) + sin + sub;

  // Another round of tanh distortion / limiting
  sig = (sig / 2.3).tanh;

  // Another resonant LPF
  sig = MoogFF.ar(sig, XLine.ar(freq*150, freq*30, 0.1), 0.1);

  Out.ar(outbus, sig!2);
}).add;


/*)
(*/

~pChord = Pbind(
	\instrument, "juno",
	\midinote, Pdefn(\chord),
	\dur, Pseq([2, 2, 2, 2], inf),
	\amp, 0.6
).play;

~pArp = Pbind(
	\instrument, "juno2",
	\midinote, Pdefn(\arpNote),
	\dur, Pdefn(\arpDur),
	\amp, Pdefn(\arp),
	\mod, 0.2
).play;

/*Pbind(
	\instrument, "juno3",
	\midinote, Pseq([24, 27, 31, 29], inf),
	\dur, Pseq([2, 2, 2, 2], inf),
	\amp, 1.2
).play;*/

~pBass = Pbind(
    \instrument, "bass",
	\midinote, Pdefn(\patternNote),
	\dur, Pdefn(\patternDur),
	\att, 0.01,
	\rel, Pkey(\dur)+0.01,
	\hifreq, 5000,
    \amp, 1,
).play;

~pKick = Pbind(
	\instrument, "kick",
	// \dur, Pseq([1/2, Rest(1/4), 1/4, Rest(1/2), 1/4, 1/4], inf),
	\dur, Pdefn(\kickDur),
	\att, 0.01,
	\rel, 0.22,
	\sinfreq, 60,
	\glissf, 0.9,
	\amp, 0.8,
).play;

~pSnare = Pbind(
	\instrument, "snare",
	\dur, Pseq([Rest(1/2), 1/2], inf),
	\att, 0.01,
	\rel, 0.4,
	\sinfreq, 180,
	\ffreq, 500,
	\amp, 1,

).play;


~pHiHat = Pbind(
	\instrument, "hihat",
	\dur, Pdefn(\hiHatDur),
	\att, 0.01,
	\rel, 0.1,
	\ffreq, 11000,
	\pan, 0,
	\amp, 0.2
).play;

OSCdef.new(\get_Arp,
	{
		arg msg, time, addr, port;
		if(msg[1]<=0.0, {
			postln("ARP 0");
			~arp= 0.0;
		},{

			postln("ARP NOT 0");
			postln(msg[1]);
			~arp = 1;
			~arpNum=msg[1];
		})

	},
	"/processing/SCControls/ArpONOFF"
);
OSCdef.new(\get_Changes,
	{
		arg msg, time, addr, port;
		postln(msg[1]);
		~numDrums = msg[1];
	},
	"/processing/SCControls/DrumVelocity"
);

OSCdef.new(\get_Pattern_changes,
	{
		arg msg, time, addr, port;
		postln("PATTERN CHANGE");
		postln(msg[1]);
		~numPattern = msg[1];
	},
	"/processing/SCControls/changingPattern"
);

OSCdef.new(\get_BPM_set,
	{
		arg msg, time, addr, port;
		postln("BPM SET value:");
		postln(msg[1]);
		~bpm = msg[1];
		TempoClock.default.tempo = ~bpm/120;
	},
	"/processing/SCControls/setBPM"
);
)