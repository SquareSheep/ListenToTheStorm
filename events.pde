class End extends Event {
	float amp = 1;
	End(float time) {
		super(time, time+1);
	}

	void spawn() {
		sun.beam = false;
		for (int i = 0 ; i < sun.ar.length ; i ++) {
			sun.ar[i].lifeSpan = 0;
			sun.ar[i].fillStyle.a.X = 0;
		}
		mountainRange.setFillStyleC(mountainFill.rc*amp, mountainFill.gc*amp, mountainFill.bc*amp,255);
		ground.setFillStyleC(groundFill.rc*amp, groundFill.gc*amp, groundFill.bc*amp, 255);
	}
}

class Sunrise extends Event {
	Sunrise(float time) {
		super(time, time+30);
	}

	void spawn() {
		sun.beam = true;
		sun.beamTick = 30;
		sun.draw = true;
		stormClouds.spawnRain = false;
		stormClouds2.spawnRain = false;
		stormClouds.spawnClouds = false;
		stormClouds.currVGraph = 1;
		stormClouds2.spawnClouds = false;
		stormClouds2.currVGraph = 1;
		backFillAmp.X = 1.5;
		mountainRange.setMountainWM(3);
	}

	void update() {
		if (sun.p.P.y > -de*0.7) sun.p.P.y -= de*0.7/60/15;
	}
}

class FinalSunrise extends Event {
	FinalSunrise(float time, float timeEnd) {
		super(time, timeEnd);
	}

	void spawn() {
		ground.setPointPM(2);
		mountainRange.setMountainWM(6);
		mountainRange.setFillStyleMass(5);
	}

	void update() {
		if (frameCount % 12 == 0) {
			for (int i = 0 ; i < mountainRange.ar.size() ; i ++) {
				Mountain mob = mountainRange.ar.get(i);
				mob.fillStyle.setC(random(125,200),random(155,255),random(75,200),255);
				mob.fillStyle.setM(random(0,2),random(0,2),random(0,2),0);
			}
			for (int i = 0 ; i < ground.col ; i ++) {
				ground.fillStyle[i].setC(random(0,55),random(75,175),random(0,55),255);
				ground.fillStyle[i].setM(random(0,1),random(0,1),random(0,1),0);
			}
		}
	}
}

class MegaSunrise extends Event {
	float amp;
	MegaSunrise(float time, float amp) {
		super(time, time+1);
		this.amp = amp;
	}

	void spawn() {
		sun.beamTick = (int)(10/pow(amp,2));
		sun.beam = true;
		ground.setPointPM(amp);
		mountainRange.setMountainWM(3*amp);
	}
}

class CurrCloudVGraph extends Event {
	int index;
	CurrCloudVGraph(float time, int index) {
		super(time, time+1);
		this.index = index;
	}

	void spawn() {
		stormClouds.currVGraph = index;
		stormClouds2.currVGraph = index;
	}
}

class DistortionBeams extends Event {
	int num;
	int lifeSpan;
	float r; float g; float b; float rm; float gm; float bm;
	DistortionBeams(float time, int lifeSpan, int num, float r, float g, float b, float rm, float gm, float bm) {
		super(time, time+1);
		this.lifeSpan = lifeSpan;
		this.num = num;
		this.r = r; this.g = g; this.b = b; this.rm = rm; this.gm = gm; this.bm = bm;
	}

	DistortionBeams(float time, int lifeSpan, int num, float r, float g, float b) {
		this(time, lifeSpan, num, r,g,b, 3,3,3);
	}

	DistortionBeams(float time, int lifeSpan, float r, float g, float b) {
		this(time, lifeSpan, 16, r,g,b, 3,3,3);
	}

	DistortionBeams(float time, int lifeSpan) {
		this(time, lifeSpan, 16, 255,255,255,0,0,0);
	}

	void spawn() {
		float x; float z;
		for (int i = 0 ; i < num ; i ++) {
			x = random(-de,de); z = random(-de,0);
			lightBeams.add(x,z, x+random(-de*0.2,de*0.2), z+random(-de*0.2,de*0.2),0,0, lifeSpan);
			LightBeam lightBeam = lightBeams.ar.get(lightBeams.arm-1);
			lightBeam.v.set((noise(lightBeam.p2.x)-0.5)*10,(noise(lightBeam.p2.y)-0.5)*10);
			lightBeam.fillStyle.setC(r,g,b,175);
			lightBeam.fillStyle.setM(rm,gm,bm,0,(float)i/num*binCount*0.25);
			lightBeam.w.index = (int)((float)i/num*binCount*0.25);
		}
	}
}

class GroundIndexShift extends Event {
	int amp;
	int tick;
	GroundIndexShift(float time, float timeEnd, int amp, int tick) {
		super(time, timeEnd);
		this.amp = amp;
		this.tick = tick;
	}

	GroundIndexShift(float time, float timeEnd) {
		this(time, timeEnd, 1,12);
	}

	void update() {
		if (frameCount % tick == 0) {
			ground.shiftIndex(amp,0,0.25);
		}
	}
}
class SysFillC extends Event {
	float amp;
	SysFillC(float time, float amp) {
		super(time, time+1);
		this.amp = amp;
	}

	void spawn() {
		backFillAmp.X = amp;
		stormClouds.rain.fillStyle.reset(rainFill.r.x*amp, rainFill.g.x*amp, rainFill.b.x*amp,255);
		stormClouds2.rain.fillStyle.reset(rainFill.r.x*amp, rainFill.g.x*amp, rainFill.b.x*amp,255);
		stormClouds.setCloudFillStyleC(cloudFill.rc*amp, cloudFill.gc*amp,cloudFill.bc*amp,255);
		stormClouds2.setCloudFillStyleC(cloudFill.rc*amp*1.4, cloudFill.gc*amp*1.4,cloudFill.bc*amp*1.4,255);
		mountainRange.setFillStyleC(mountainFill.rc*amp, mountainFill.gc*amp, mountainFill.bc*amp,255);
		ground.setFillStyleC(groundFill.rc*amp, groundFill.gc*amp, groundFill.bc*amp, 255);
	}
}

class SysFillM extends Event {
	float amp;
	SysFillM(float time, float amp) {
		super(time, time+1);
		this.amp = amp;
	}

	void spawn() {
		stormClouds.setRainFillStyleM(rainFill.rm*amp, rainFill.gm*amp, rainFill.bm*amp,0, 0,0.25);
		stormClouds2.setRainFillStyleM(rainFill.rm*amp, rainFill.gm*amp, rainFill.bm*amp,0, 0,0.25);
		stormClouds.setCloudFillStyleM(cloudFill.rm*amp, cloudFill.gm*amp,cloudFill.bm*amp,0, 0,0.25);
		stormClouds2.setCloudFillStyleM(cloudFill.rm*amp, cloudFill.gm*amp,cloudFill.bm*amp,0, 0,0.25);
		mountainRange.setFillStyleM(mountainFill.rm*amp, mountainFill.gm*amp, mountainFill.bm*amp,0, 0,0.25);
		ground.setFillStyleM(groundFill.rm*amp, groundFill.gm*amp, groundFill.bm*amp,0, 0,0.25);
	}
}

float BoidPAmp = 0.03;
float BoidAngAmp = 0.0003;
float BoidW = 0.04;
float BoidWAmp = 0.01;
float binCutOff = 0.25;
class Boid extends Event {
	Poly[] ar;

	Boid(float time, int num, float r1, float g1, float b1, float r2, float g2, float b2) {
		super(time, time+9);
		timeEnding = time + 8;
		ar = new Poly[num];
		for (int i = 0 ; i < num ; i ++) {
			ar[i] = newPoly("Pyramid", new PVector(), new PVector(), de*BoidW);
			ar[i].p.mass = 1000;
			ar[i].p.vMult = 0.99;
			ar[i].ang.mass = 1000;
			ar[i].ang.vMult = 0.99;
			ar[i].fillStyleSetMass(15);
			ar[i].fillStyleSetC(random(r1,r2),random(g1,g2),random(b1,b2),255);
			ar[i].fillStyleSetM(random(15,25),random(15,25),random(15,25),0,i);
		}
	}

	Boid(float time, int num, float r, float g, float b) {
		this(time, num, r*0.7,g*0.7,b*0.7, r*1.3,g*1.3,b*1.3);
	}

	Boid(float time, int num) {
		this(time, num, 100,100,100, 175,175,175);
	}

	void spawn() {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].sca.x = 0;
			ar[i].sca.X = 1;
			ar[i].fillStyleSetx(0,0,0,0);
			ar[i].p.reset(random(back.x,front.x),back.y,random(back.z,front.z));
			ar[i].p.setM(random(-BoidPAmp*de,BoidPAmp*de),
				random(-BoidPAmp*de,BoidPAmp*de), BoidPAmp*de,i);
			ar[i].ang.setM(random(-BoidAngAmp*de,BoidAngAmp*de),
				random(-BoidAngAmp*de,BoidAngAmp*de), random(-BoidAngAmp*de,BoidAngAmp*de),i);
		}
	}

	void ending() {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].sca.X = 0;
		}
	}

	void update() {
		for (Poly poly : ar) {
			poly.p.P.x += poly.p.v.x;
			poly.p.P.y += poly.p.v.y;
			poly.p.P.z += poly.p.v.z;
			poly.ang.P.z += poly.ang.v.z;
			poly.update();
		}
	}

	void render() {
		for (Poly poly : ar) {
			poly.render();
		}
	}
}