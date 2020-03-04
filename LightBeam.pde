class LightPool extends ObjectPool<LightBeam> {

	void set(LightBeam mob, float x1, float z1, float x2, float z2, float vx, float vz, int lifeSpan) {
		mob.draw = true;
		mob.finished = false;
		mob.fillStyle.setx(0,0,0,0);
		mob.fillStyle.setC(255,255,255,255);
		mob.w.reset(0,10,0.1,30);
		mob.p.set(x1,back.y*2,z1);
		mob.p2.set(x2,0,z2);
		mob.v.set(vx,0,vz);
		mob.lifeSpan = lifeSpan;
	}

	void add(float x1, float z1, float x2, float z2, float vx, float vz, int lifeSpan) {
		if (arm == ar.size()) {
			LightBeam mob = new LightBeam();
			set(mob, x1, z1, x2, z2, vx, vz, lifeSpan);
			ar.add(mob);
		} else {
			set(ar.get(arm), x1, z1, x2, z2, vx, vz, lifeSpan);
		}
		arm ++;
	}
}

class LightBeam extends Entity {
	PVector p = new PVector();
	PVector p2 = new PVector();
	PVector v = new PVector();
	IColor fillStyle = new IColor();
	int lifeSpan;
	SpringValue w = new SpringValue();

	LightBeam() {
		w.xm = 1;
	}

	void update() {
		p2.add(v);
		fillStyle.update();
		w.update();
		if (timer.beat) {
			lifeSpan --;
			if (lifeSpan <= 1) {
				fillStyle.setC(0,0,0,0);
			}
		}
		if (lifeSpan == 0) finished = true;
	}

	void render() {
		push();
		fillStyle.strokeStyle();
		strokeWeight(w.x);
		line(p.x,p.y,p.z,p2.x,p2.y,p2.z);
		pop();
	}
}