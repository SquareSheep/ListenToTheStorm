class LightPool extends ObjectPool<LightBeam> {

	void set(LightBeam mob, float x1, float z1, float x2, float z2, float vx, float vz) {
		mob.draw = true;
		mob.finished = false;
		mob.fillStyle.reset(255,255,255,255);
		mob.p.set(x1,back.y*1.5,z1);
		mob.p2.set(x2,0,z2);
		mob.v.set(vx,0,vz);
		mob.lifeSpan = fpb*3;
	}

	void add(float x1, float z1, float x2, float z2, float vx, float vz) {
		if (arm == ar.size()) {
			LightBeam mob = new LightBeam();
			set(mob, x1, z1, x2, z2, vx, vz);
			ar.add(0,mob);
		} else {
			set(ar.get(arm), x1, z1, x2, z2, vx, vz);
		}
		arm ++;
	}
}

class LightBeam extends Entity {
	PVector p = new PVector();
	PVector p2 = new PVector();
	PVector v = new PVector();
	IColor fillStyle = new IColor();
	float lifeSpan;

	void update() {
		p2.add(v);
		fillStyle.update();
		lifeSpan --;
		if (lifeSpan <= 0) finished = true;
	}

	void render() {
		push();
		fillStyle.strokeStyle();
		line(p.x,p.y,p.z,p2.x,p2.y,p2.z);
		pop();
	}
}