/*
Listen To The Storm

Main systems:

Mountain range
Storm clouds + rain
Lightning
Foreground grass
Sun + sun rays
*/

static float bpm = 81;
static int threshold = 50;
static int offset = 0;
static int binCount = 144;
static float defaultMass = 30;
static float defaultVMult = 0.5;
static float fillMass = 5;
static float fillVMult = 0.5;
static float fftThreshold = 1;
static float fftPow = 1.2;
static float fftAmp = 2;
static float volumeGain = -10;
static String songName = "../Music/listentothestorm.mp3";

IColor defaultFill = new IColor(0,0,0,0, 5,5,5,5,-1);
IColor defaultStroke = new IColor(0,0,0,0, 5,5,5,5,-1);

MountainRange mountainRange;
StormClouds stormClouds;
StormClouds stormClouds2;

void render() {
	push();
	translate(0,0,de*0.5);
	fill(65,75,55,255);
	rotateX(PI/2);
	rect(0,0,de*3.3,de*3);
	pop();
}

void addEvents() {
	events.add(new Intro());
	for (int i = 0 ; i < 10 ; i ++) {
		events.add(new Distortion(i*9+10));
		events.add(new Distortion(i*9+10));
		events.add(new Distortion(i*9+10));
	}
}

void keyboardInput() {

}

void setSketch() {
	noStroke();

	float mult = 1;
	front = new PVector(de*mult,de*mult,de*mult);
  	back = new PVector(-de*mult,-de*mult,-de*mult);

  	mountainRange = new MountainRange(new PVector(0,0,back.z), new PVector(de*1.6,de*0.5,de*0.3));
  	mountainRange.addMountains(12, 0, 0.31,0.55, 0.7,1, 0.3,1);
  	mountainRange.addMountains(16, 0.5, 0.21,0.35, 0.3,0.7, 0.2,0.4);
  	mountainRange.addMountains(28, 1, 0.1,0.15, 0.2,0.5, 0.1,0.3);
  	mobs.add(mountainRange);

  	float dex = (front.x - back.x)*0.6;

  	stormClouds = new StormClouds(new PVector(0,-de*1.05,de*0.5), dex,de*0.15,dex);
  	stormClouds.addClouds(110, 0.15,0.25,125);
  	mobs.add(stormClouds);

  	stormClouds2 = new StormClouds(new PVector(0,-de*1.25,de*0.5), dex,de*0.1,dex);
  	stormClouds2.addClouds(180, 0.05,0.25,175);
  	mobs.add(stormClouds2);
}