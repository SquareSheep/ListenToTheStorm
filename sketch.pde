/*
Listen To The Storm

Done:
Mountain range
Storm clouds + rain
Rain
Ground visualizer

To Do:

Sun ray notes
Boids for sunrise
Horizon bars
Static background stars during storm


*/

static float bpm = 81;
static int threshold = 50;
static int offset = 300;
static int binCount = 200;
static float defaultMass = 30;
static float defaultVMult = 0.5;
static float fillMass = 15;
static float fillVMult = 0.5;
static float fftThreshold = 0.5;
static float fftPow = 1.5;
static float fftAmp = 3;
static float volumeGain = -5;
static String songName = "../Music/listentothestorm.mp3";

IColor defaultFill = new IColor(0,0,0,0, 5,5,5,5,-1);
IColor defaultStroke = new IColor(0,0,0,0, 5,5,5,5,-1);

MountainRange mountainRange;
StormClouds stormClouds;
StormClouds stormClouds2;
TriangleGridVisualizer ground;
LightPool lightBeams;
Sun sun;

SpringValue backFillAmp = new SpringValue(0,0.05,150);
IColor cloudFill = new IColor(140,140,140,255, 3,3,5,0, -1);
IColor mountainFill = new IColor(86,80,72,255, 2,2,5,0, -1);
IColor rainFill = new IColor(105,105,175,255, 3,3,3,0, -1);
IColor groundFill = new IColor(96,128,56,255, 3,3,3,0, -1);

void render() {
	backFillAmp.update();
	background(35*backFillAmp.x,122*backFillAmp.x,175*backFillAmp.x,255);
}
// Distorted fog 11, 20, 29, 38, 47,57,66,75,84,93,102,111,120,128.5,137,145,153,161,168,175
// Drawn out distortion: 185
// silence: 211 
// sunrise: 217 mega sunrise: 243 mega sunrise2: 269 final sunrise: 295
int[] distort = {11,20,29,38,47,57,66,75,84,93,102,111,120,128,137,145,153,161,168,175,185, 269,276,283,289,321,328,334};
int[] distortLifeSpan = {8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,28, 6,6,6,6,6,6,6};
void addEvents() {
	events.add(new CurrCloudVGraph(0,0));
	events.add(new GroundIndexShift(0,1000));
	events.add(new SysFillM(0,0));
	events.add(new SysFillC(0,0.1));
	for (int i = 0 ; i < 10 ; i ++) {
		events.add(new SysFillC(distort[i],(i+1)*0.07));
		events.add(new SysFillM(distort[i],(i+1)*0.07));
	}
	for (int i = 0 ; i < distort.length ; i ++) {
		events.add(new DistortionBeams(distort[i], distortLifeSpan[i], random(155,255),random(155,255),random(155,255)));
	}
	events.add(new CurrCloudVGraph(185,2));
	events.add(new CurrCloudVGraph(211,0));
	events.add(new Sunrise(217));
	events.add(new MegaSunrise(243,1.3));
	events.add(new MegaSunrise(269,2));
	events.add(new FinalSunrise(295,354));
	events.add(new End(354));
}

void keyboardInput() {
	if (keyP == 'z' || keyP == 'x') {
		sun.addBeam(random(-PI,PI),0,0.35, 200+(noise(frameCount/10)-0.5)*50,150+(noise(frameCount/10)-0.5)*50,75+(noise(frameCount/10)-0.5)*50,
			noise(frameCount/100)*10,noise(frameCount/100+10)*10,noise(frameCount/100+100)*10);
	}
	if (keyP == 'a' || keyP == 'd' || keyP == 's') {
		zxBeam(4, 200,200,255,0,0,0);
	}
}

void zxBeam(float num, float r, float g, float b, float rm, float gm, float bm) {
	float x; float z;
	for (int i = 0 ; i < num ; i ++) {
		z = random(-de,0);
		if (random(1) >0.5) {
			x = random(-de,-de*0.8);
		} else {
			x = random(de*0.8,de);
		}
		lightBeams.add(x,z, x+random(-de*0.2,de*0.2), z+random(-de*0.2,de*0.2),0,0, 4);
		LightBeam lightBeam = lightBeams.ar.get(lightBeams.arm-1);
		lightBeam.v.set((noise(lightBeam.p2.x)-0.5)*10,(noise(lightBeam.p2.y)-0.5)*10);
		lightBeam.fillStyle.setC(r,g,b,255);
		lightBeam.fillStyle.setM(rm,gm,bm,0,(float)i/num*binCount*0.25);
		lightBeam.w.index = (int)((float)i/num*binCount*0.25);
	}
}

void setSketch() {
	noiseSeed(0);
	noStroke();

	float mult = 1;
	front = new PVector(de*mult,de*mult,de*mult);
  	back = new PVector(-de*mult,-de*mult,-de*mult);

  	sun = new Sun(new PVector(0,0,-de*1.2), de*0.15);
  	sun.draw = false;
  	mobs.add(sun);

  	lightBeams = new LightPool();
  	mobs.add(lightBeams);

  	ground = new TriangleGridVisualizer(new PVector(0,0,de*0.5), new PVector(-PI/2,0,0), de*0.1,32,52);
  	ground.setFillStyleMass(100);
  	for (int i = 0 ; i < ground.col ; i ++) {
  		ground.fillStyle[i].setx(0,0,0,255);
  	}
  	mobs.add(ground);

  	mountainRange = new MountainRange(new PVector(0,0,back.z), new PVector(de*2.6,de*0.5,de*0.3));
  	mountainRange.addMountains(16, 0, 0.31,0.55, 0.7,1, 0.3,1);
  	mountainRange.addMountains(24, 0.5, 0.21,0.35, 0.3,0.7, 0.2,0.4);
  	mountainRange.addMountains(36, 1, 0.1,0.15, 0.2,0.5, 0.1,0.3);
  	mobs.add(mountainRange);

  	float dex = (front.x - back.x)*0.6;

  	stormClouds = new StormClouds(new PVector(0,-de*1.05,de*0.5), dex,de*0.15,dex);
  	stormClouds.addClouds(130, 0.15,0.35);
  	mobs.add(stormClouds);

  	stormClouds2 = new StormClouds(new PVector(0,-de*1.25,de*0.5), dex,de*0.1,dex);
  	stormClouds2.addClouds(150, 0.1,0.2);
  	mobs.add(stormClouds2);
}