class StormClouds extends Entity {
	ArrayList<Cloud> ar;
	PVector w;
	Point p;

	StormClouds(PVector p, float wx, float wy, float wz) {
		this.ar = new ArrayList<Cloud>();
		this.w = new PVector(wx,wy,wz);
		this.p = new Point(p);
	}

	void update() {
		for (int i = 0 ; i < ar.size() ; i ++) {
			Cloud mob = ar.get(i);
			if (mob.lifeSpan != -1) {
				mob.lifeSpan --;
				if (mob.lifeSpan == 0) {
					mob.p.reset(random(-w.x,w.x),random(-w.y,w.y),random(-w.z,w.z));
					mob.pv.reset(0,0,0);
					mob.w.p.set(0,0,0);
					mob.w.P.add(mob.wd);
					mob.lifeSpan = -1;
				}
			} else {
				if (mob.p.p.x > w.x || mob.p.p.y > w.y || mob.p.p.z > w.z
					|| mob.p.p.x < -w.x || mob.p.p.y < -w.y || mob.p.p.z < -w.z) {
					mob.lifeSpan = 120;
					mob.w.P.set(0,0,0);
				} else {
					if ((frameCount+mob.tick) % 120 == 0) {
						float dist = 0;
						float minDist = 100000;
						int index = -1;
						for (int k = 0 ; k < ar.size() ; k ++) {
							if (i != k) {
								Cloud mo2 = ar.get(k);
								dist = min(abs(mob.p.p.x-mo2.p.p.x), abs(mob.p.p.y-mo2.p.p.y), abs(mob.p.p.z-mo2.p.p.z));
								if (dist < minDist) {
									minDist = dist;
									index = k;
								}
							}
						}
						Cloud mo2 = ar.get(index);

						float amp = 0.01;
						mob.pv.P.set(
							(mob.p.p.x-mo2.p.p.x)/dist*amp,
							(mob.p.p.y-mo2.p.p.y)/dist*amp,
							(mob.p.p.z-mo2.p.p.z)/dist*amp
						);
					}
					if ((frameCount+mob.tick) % 180 == 0) {
						float amp = 2*PI;
						mob.ang.P.set((noise(mob.p.p.x, mob.p.p.y,mob.p.p.z)-0.5)*amp,
							(noise(mob.p.p.y, mob.p.p.x,mob.p.p.z)-0.5)*amp,(noise(mob.p.p.z, mob.p.p.y,mob.p.p.x)-0.5)*amp);
					}
				}
			}
			mob.update();
		}
	}

	void render() {
		push();
		translate(p.p.x, p.p.y, p.p.z);
		for (int i = 0 ; i < ar.size() ; i ++) {
			Cloud mob = ar.get(i);
			if (mob.draw) mob.render();
		}
		pop();
	}

	void addClouds(float num, float minW, float maxW, float gray) {
		for (int i = 0 ; i < num ; i ++) {
			float g = random(-25,25) + gray;
			float wx = random(minW*w.x,maxW*w.x);
			float wy = random(minW*w.x,maxW*w.x);
			float wz = random(minW*w.x,maxW*w.x);
			ar.add(new Cloud(new PVector(random(-w.x,w.x), random(-w.y,w.y), random(-w.z,w.z)),
				new PVector(wx,wy,wz), g,g,g));
		}
	}

	class Cloud extends Mob {
		Point w;
		PVector wd;
		IColor fillStyle;
		int tick = (int)random(15,200);

		Cloud(PVector p, PVector w, float r, float g, float b) {
			this.p = new Point(p);
			this.w = new Point(w);
			this.wd = w.copy();
			this.p.mass = 300;
			this.p.vMult = 0.1;
			this.w.mass = 120;
			this.w.vMult = 0.1;
			this.ang.mass = 300;
			this.ang.vMult = 0.1;
			this.ang.reset(random(-PI,PI),random(-PI,PI),random(-PI,PI));
			this.fillStyle = new IColor(r,g,b,255);
		}

		void update() {
			super.update();
			w.update();
			fillStyle.update();
		}

		void render() {
			setDraw();
			fillStyle.fillStyle();
			box(w.p.x,w.p.y,w.p.z);
			pop();
		}
	}
}