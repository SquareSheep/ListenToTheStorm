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