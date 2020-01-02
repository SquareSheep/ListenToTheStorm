class Sun extends Entity {
	Point p;
	SpringValue w;
	IColor fillStyle;
	SunBeam[] ar = new SunBeam[64];

	Sun(PVector p, float w) {
		sphereDetail(12);
		this.p = new Point(p);
		this.w = new SpringValue(w, 0.2,10);
		this.fillStyle = new IColor(255,255,125,255);
		for (int i = 0 ; i < ar.length ; i ++) {
			ar[i] = new SunBeam();
		}
	}

	void update() {
		p.update();
		w.update();
		fillStyle.update();
		for (SunBeam beam : ar) {
			if (beam.draw) beam.update();
		}
	}

	void render() {
		push();
		fillStyle.fillStyle();
		translate(p.p.x, p.p.y, p.p.z);
		sphere(w.x);
		for (SunBeam beam : ar) {
			if (beam.draw) beam.render();
		}
		pop();
	}

	void addBeam(float ang, float minI, float maxI, float r, float g, float b, float rm, float gm, float bm) {
		int index = 0;
		while (index < ar.length && ar[index].draw) {
			index ++;
		}
		if (index < ar.length) {
			for (int i = 0 ; i < ar[index].ar.length ; i ++) {
				float k = (float)i/ar[index].ar.length*(maxI-minI)*binCount + minI*binCount;
				ar[index].ar[i].index = (int)k;
				ar[index].ar2[i].index = (int)k;
			}
			ar[index].draw = true;
			ar[index].lifeSpan = 180;
			ar[index].fillStyle.reset(r,g,b,255, rm,gm,bm,0, (float)index/ar.length*binCount);
			ar[index].fillStyle.setx(0,0,0,0);
			ar[index].ang.reset(ang);
		}
	}

	void addBeam(float ang, float r, float g, float b) {
		addBeam(ang, 0,0.35, r,g,b,0,0,0);
	}

	void addBeam(float ang) {
		addBeam(ang,0,0.35, 255,150,75,0,0,0);
	}

	class SunBeam extends Entity {
		Point[] ar = new Point[20];
		Point[] ar2 = new Point[20];
		IColor fillStyle = new IColor();
		int lifeSpan;
		SpringValue ang = new SpringValue();
		SunBeam() {
			draw = false;
			float angle = 0.03;
			float amp = 2;
			float length = de*0.2;
			float x = cos(-angle)*length;
			float y = sin(-angle)*length;
			float x2 = cos(angle)*length;
			float y2 = sin(angle)*length;
			float z = random(-5,5);
			for (int i = 0 ; i < ar.length ; i ++) {
				ar[i] = new Point(x*i, y*i, z);
				ar[i].pm.set(0,-amp,0);
				ar2[i] = new Point(x2*i, y2*i, z);
				ar2[i].pm.set(0,amp,0);
			}
			fillStyle.setMass(30);
		}

		void update() {
			for (int i = 0 ; i < ar.length ; i ++) {
				ar[i].update();
				ar2[i].update();
			}
			fillStyle.update();
			ang.update();
			if (lifeSpan > 0) {
				lifeSpan --;
			} else {
				if (fillStyle.a.X != 0) {
					fillStyle.setC(0,0,0,0);
				} else {
					fillStyle.a.x --;
					if (fillStyle.a.x < 3) draw = false;
				}
			}
		}

		void render() {
			push();
			rotateZ(ang.x);
			beginShape(TRIANGLE_STRIP);
			fillStyle.fillStyle();
			for (int i = 0 ; i < ar.length ; i ++) {
				vertex(ar[i].p.x, ar[i].p.y, ar[i].p.z);
				vertex(ar2[i].p.x, ar2[i].p.y, ar2[i].p.z);
			}
			endShape();
			pop();
		}
	}
}