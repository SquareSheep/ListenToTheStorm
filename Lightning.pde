/*
The guitar distortion echo sounds
*/
class LightningPool extends ObjectPool<Lightning> {
	void set(Lightning mob, float x, float y, float z, float x2, float y2, float z2) {
		mob.p.set(x,y,z);
		mob.p2.set(x2,y2,z2);
		mob.d.set(x2-x,y2-y,z2-z);
		mob.fillStyle.reset(222,222,255,255);
	}

	void add(float x, float y, float z, float x2, float y2, float z2) {
		if (arm == ar.size()) {
			ar.add(0, new Lightning());
		} else {
			Lightning mob = ar.get(arm);
			set(mob, x,y,z, x2,y2,z2);
		}
	}
}

class Lightning extends Entity {
	PVector p = new PVector();
	PVector p2 = new PVector();
	PVector d = new PVector();
	float lifeSpan;
	IColor fillStyle = new IColor();

	Lightning() {}

	void update() {
		lifeSpan --;
		if (lifeSpan <= 0) finished = true;
		fillStyle.update();
	}

	void render() {
		push();
		fillStyle.fillStyle();
		translate(p.p.x,p.p.y,p.p.z);
		line(0,0,0,d.x,d.y,d.z);
		pop();
	}
}