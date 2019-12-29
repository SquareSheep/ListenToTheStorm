// Sets up fillStyles and indices for the systems
class Intro extends Event {
	Intro() {
		time = 10;
		timeEnd = 1000;
	}

	void spawn() {
		stormClouds.rain.fillStyle.reset(105,105,175,255);
		stormClouds2.rain.fillStyle.reset(105,105,175,255);
		stormClouds.setRainFillStyleM(-3,-3,-3,0, 0,0.25);
		stormClouds2.setRainFillStyleM(-3,-3,-3,0, 0,0.25);
		stormClouds.setCloudFillStyleM(-2,-2,2,0, 0,0.25);
		stormClouds2.setCloudFillStyleM(-2,-2,2,0, 0,0.25);
		mountainRange.setFillStyleM(2,2,5,0, 0,0.25);
	}
}

float distortionPAmp = 0.03;
float distortionAngAmp = 0.0003;
float distortionW = 0.04;
float distortionWAmp = 0.01;
float binCutOff = 0.25;
class Distortion extends Event {
	Poly[] ar;

	Distortion(float time) {
		super(time, time+9);
		timeEnding = time + 8;
		int num = (int)random(40,45);
		ar = new Poly[num];
		for (int i = 0 ; i < num ; i ++) {
			ar[i] = newPoly("Pyramid", new PVector(), new PVector(), de*distortionW);
			ar[i].p.mass = 1000;
			ar[i].p.vMult = 0.99;
			ar[i].ang.mass = 1000;
			ar[i].ang.vMult = 0.99;
			ar[i].fillStyleSetMass(15);
			ar[i].fillStyleSetC(random(55,175),random(55,175),random(55,175),255);
			ar[i].fillStyleSetM(random(20,55),random(20,55),random(20,55),0,i);
		}
	}

	void spawn() {
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i].sca.x = 0;
			ar[i].sca.X = 1;
			ar[i].fillStyleSetx(0,0,0,0);
			ar[i].p.reset(random(back.x,front.x),back.y,random(back.z,front.z));
			ar[i].p.setM(random(-distortionPAmp*de,distortionPAmp*de),
				random(-distortionPAmp*de,distortionPAmp*de), distortionPAmp*de,i);
			ar[i].ang.setM(random(-distortionAngAmp*de,distortionAngAmp*de),
				random(-distortionAngAmp*de,distortionAngAmp*de), random(-distortionAngAmp*de,distortionAngAmp*de),i);
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