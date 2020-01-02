Point rainVel = new Point(1,12,1);
float rainAmp = 300;
int cloudBoudaryLifeSpan = 300;
float cloudRepelAmp = 0.01;

class StormClouds extends Entity {
	ArrayList<Cloud> ar;
	PVector w;
	Point p;
	RainPool rain = new RainPool();
	int currVGraph = 0;
	boolean spawnClouds = true;

	StormClouds(PVector p, float wx, float wy, float wz) {
		this.ar = new ArrayList<Cloud>();
		this.w = new PVector(wx,wy,wz);
		this.p = new Point(p);
	}

	void setVGraph(Cloud mob) {
		switch (currVGraph) {
			case 0:
				break;
			case 1:
				mob.p.P.x += abs(mob.p.p.x)/mob.p.p.x;
				mob.p.P.x *= 1.01;
				break;
			case 2:
				mob.p.P.x += (noise(mob.p.p.x/25, mob.p.p.y/25)-0.5)*de*0.1;
				mob.p.P.z += (noise(mob.p.p.z/25, mob.p.p.x/25)-0.5)*de*0.1;
				break;
			default: break;
		}	
	}

	void update() {
		p.update();
		rainVel.update();
		rain.update();
		for (int i = 0 ; i < ar.size() ; i ++) {
			Cloud mob = ar.get(i);
			if (mob.draw) {
				if ((frameCount + mob.tick) % (int)(rainAmp/(avg+1)) < 2) {
					rain.add(mob.p.p.x+random(-mob.w.p.x,mob.w.p.x), mob.p.p.y+random(-mob.w.p.y,mob.w.p.y), 
						mob.p.p.z+random(-mob.w.p.z,mob.w.p.z),  mob.rainV.p.x, mob.rainV.p.y + avg, mob.rainV.p.z);
				}
				if (mob.lifeSpan != -1) {
					mob.lifeSpan --;
					if (mob.lifeSpan == 0) {
						mob.p.reset(random(-w.x,w.x),random(-w.y,w.y),random(-w.z,w.z));
						mob.pv.reset(0,0,0);
						mob.w.p.set(0,0,0);
						mob.w.P.add(mob.wd);
						mob.lifeSpan = -1;
						if (!spawnClouds) mob.draw = false;
					}
				} else {
					if (mob.p.p.x > w.x || mob.p.p.y > w.y || mob.p.p.z > w.z
						|| mob.p.p.x < -w.x || mob.p.p.y < -w.y || mob.p.p.z < -w.z) {
						mob.lifeSpan = cloudBoudaryLifeSpan;
						mob.w.P.set(-50,-50,-50);
					} else {
						if ((frameCount+mob.tick) % 16 == 0) {
							mob.pv.P.set(0,0,0);
							float dist;
							for (int k = 0 ; k < ar.size() ; k ++) {
								if (i != k) {
									Cloud mo2 = ar.get(k);
									dist = sqrt(pow(mob.p.p.x-mo2.p.p.x,2) + pow(mob.p.p.y-mo2.p.p.y,2) + pow(mob.p.p.z-mo2.p.p.z,2));
									mob.pv.P.add((mob.p.p.x-mo2.p.p.x)/dist*cloudRepelAmp, (mob.p.p.y-mo2.p.p.y)/dist*cloudRepelAmp,(mob.p.p.z-mo2.p.p.z)/dist*cloudRepelAmp);
								}
							}
						}
						if ((frameCount+mob.tick) % 180 == 0) {
							mob.ang.P.set((noise(mob.p.p.x, mob.p.p.y,mob.p.p.z)-0.5)*2*PI,
								(noise(mob.p.p.y, mob.p.p.x,mob.p.p.z)-0.5)*2*PI,(noise(mob.p.p.z, mob.p.p.y,mob.p.p.x)-0.5)*2*PI);
						}
					}
				}
				setVGraph(mob);
				mob.update();
			}
		}
	}

	void render() {
		push();
		translate(p.p.x, p.p.y, p.p.z);
		for (int i = 0 ; i < ar.size() ; i ++) {
			Cloud mob = ar.get(i);
			if (mob.draw) mob.render();
		}
		rain.render();
		pop();
	}

	void addClouds(float num, float minW, float maxW) {
		for (int i = 0 ; i < num ; i ++) {
			float W = random(minW*w.x,maxW*w.x);
			float wx = W*random(0.8,1.2);
			float wy = W*random(0.8,1.2);
			float wz = W*random(0.8,1.2);
			ar.add(new Cloud(new PVector(random(-w.x,w.x), random(-w.y,w.y), random(-w.z,w.z)),
				new PVector(wx,wy,wz), 0,0,0));
		}
	}

	void setCloudFillStyleM(float r, float g, float b, float a, float minI, float maxI) {
		for (int i = 0 ; i < ar.size() ; i ++) {
			ar.get(i).fillStyle.setM(r,g,b,a, (int)((float)i/ar.size()*binCount*(maxI-minI)+binCount*minI));
		}
	}

	void setCloudFillStyleC(float r, float g, float b, float a) {
		float gr;
		float ag = (r + g + b)/3;
		for (int i = 0 ; i < ar.size() ; i ++) {
			gr = random(-ag*0.1,ag*0.1);
			ar.get(i).fillStyle.setC(r+gr,g+gr,b+gr,a);
		}
	}

	void setRainFillStyleM(float r, float g, float b, float a, float minI, float maxI) {
		for (int i = 0 ; i < rain.ar.size() ; i ++) {
			rain.ar.get(i).fillStyle.setM(r,g,b,a, (int)((float)i/rain.ar.size()*binCount*(maxI-minI)+binCount*minI));
		}
	}

	void setRainFillStyleC(float r, float g, float b, float a) {
		for (int i = 0 ; i < rain.ar.size() ; i ++) {
			rain.ar.get(i).fillStyle.setC(r,g,b,a);
		}
	}
}

class Cloud extends Mob {
	Point w;
	PVector wd;
	IColor fillStyle;
	int tick = (int)random(15,1000);
	Point rainV = new Point(rainVel);

	Cloud(PVector p, PVector w, float r, float g, float b) {
		this.p = new Point(p);
		this.w = new Point(w);
		this.wd = w.copy();
		this.p.mass = 300;
		this.p.vMult = 0.1;
		this.w.mass = 250;
		this.w.vMult = 0.4;
		this.ang.mass = 600;
		this.ang.vMult = 0.1;
		this.ang.reset(random(-PI,PI),random(-PI,PI),random(-PI,PI));
		this.fillStyle = new IColor(r,g,b,255);
		this.fillStyle.setMass(15);
		this.fillStyle.setVMult(0.25);
	}

	void update() {
		super.update();
		w.update();
		fillStyle.update();
		if ((frameCount + tick) % 60 == 0) this.rainV.P.set(rainVel.p.x,rainVel.p.y,rainVel.p.z);
		this.rainV.update();
	}

	void render() {
		setDraw();
		fillStyle.fillStyle();
		box(w.p.x,w.p.y,w.p.z);
		pop();
	}
}

class RainPool extends ObjectPool<RainDrop> {

	PVector rainW = new PVector(0.005,0.025,0.005);
	IColor fillStyle = new IColor();

	void set(RainDrop mob, float x, float y, float z, float vx, float vy, float vz) {
		mob.p.reset(x,y,z);
		mob.pv.reset(vx,vy,vz);
		mob.w.reset(rainW.x*de,rainW.y*de,rainW.z*de);
		mob.fillStyle.setC(fillStyle.rc, fillStyle.gc, fillStyle.bc, fillStyle.ac);
		mob.fillStyle.setx(0,0,0,0);
		mob.finished = false;
	}

	void add(float x, float y, float z, float vx, float vy, float vz) {
		if (arm == ar.size()) {
			ar.add(new RainDrop());
		}
		set(ar.get(arm), x,y,z, vx,vy,vz);
		arm ++;
	}
}

class RainDrop extends Mob {

	IColor fillStyle = new IColor();
	Point w = new Point();

	RainDrop() {
		this.p = new Point();
	}

	void update() {
		super.update();
		fillStyle.update();
		if (p.p.y > de*1.5) finished = true;
	}

	void render() {
		setDraw();
		fillStyle.fillStyle();
		rect(0,0,w.p.x,w.p.y);
		pop();
	}
}