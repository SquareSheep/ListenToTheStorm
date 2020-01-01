/*
Listen To The Storm

Done:
Mountain range
Storm clouds + rain
Rain
Ground visualizer

To Do:

Horizon bars
Sun
Sun rays
Cloud LightBeam class
Static background stars
*/

static float bpm = 81;
static int threshold = 50;
static int offset = 0;
static int binCount = 200;
static float defaultMass = 30;
static float defaultVMult = 0.5;
static float fillMass = 15;
static float fillVMult = 0.5;
static float fftThreshold = 1;
static float fftPow = 1.5;
static float fftAmp = 3;
static float volumeGain = -10;
static String songName = "../Music/listentothestorm.mp3";

IColor defaultFill = new IColor(0,0,0,0, 5,5,5,5,-1);
IColor defaultStroke = new IColor(0,0,0,0, 5,5,5,5,-1);

MountainRange mountainRange;
StormClouds stormClouds;
StormClouds stormClouds2;
TriangleGridVisualizer ground;
LightPool lightBeams;

SpringValue backFillAmp = new SpringValue(0,0.05,150);
IColor cloudFill = new IColor(140,140,140,255, 2,2,2,0, -1);
IColor mountainFill = new IColor(86,80,72,255, 2,2,5,0, -1);
IColor rainFill = new IColor(105,105,175,255, 3,3,3,0, -1);
IColor groundFill = new IColor(96,128,56,255, 3,3,3,0, -1);

void render() {
	backFillAmp.update();
	background(135*backFillAmp.x,206*backFillAmp.x,255*backFillAmp.x,255);

	if (frameCount % 15 == 0) {
		lightBeams.add(random(-de,de),random(-de,de),random(-de,de),random(-de,de),3,3);
	}
}

void addEvents() {
	events.add(new GroundIndexShift(0,1000));
	events.add(new SysFillM(0,0));
	events.add(new SysFillC(0,0.1));
	for (float i = 0 ; i < 10 ; i ++) {
		events.add(new SysFillM(i*9+10,2-i*0.1));
		events.add(new SysFillC(i*9+10,i*0.1));
		events.add(new Distortion(i*9+10, 50+(int)i*5, 15+i*15,15+i*15,15+i*30));
	}
}

void keyboardInput() {

}

void setSketch() {
	noiseSeed(0);
	noStroke();

	float mult = 1;
	front = new PVector(de*mult,de*mult,de*mult);
  	back = new PVector(-de*mult,-de*mult,-de*mult);

  	lightBeams = new LightPool();
  	mobs.add(lightBeams);

  	ground = new TriangleGridVisualizer(new PVector(0,0,de*0.5), new PVector(-PI/2,0,0), de*0.1,25,33);
  	ground.setFillStyleMass(30);
  	mobs.add(ground);

  	mountainRange = new MountainRange(new PVector(0,0,back.z), new PVector(de*1.6,de*0.5,de*0.3));
  	mountainRange.addMountains(12, 0, 0.31,0.55, 0.7,1, 0.3,1);
  	mountainRange.addMountains(16, 0.5, 0.21,0.35, 0.3,0.7, 0.2,0.4);
  	mountainRange.addMountains(28, 1, 0.1,0.15, 0.2,0.5, 0.1,0.3);
  	mobs.add(mountainRange);

  	float dex = (front.x - back.x)*0.6;

  	stormClouds = new StormClouds(new PVector(0,-de*1.05,de*0.5), dex,de*0.15,dex);
  	stormClouds.addClouds(110, 0.15,0.25);
  	mobs.add(stormClouds);

  	stormClouds2 = new StormClouds(new PVector(0,-de*1.25,de*0.5), dex,de*0.1,dex);
  	stormClouds2.addClouds(180, 0.05,0.25);
  	mobs.add(stormClouds2);
}