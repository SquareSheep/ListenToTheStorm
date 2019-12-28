/*
The guitar distortion echo sounds
*/
float lightningSetMAmp = 0.01;
class LightningPool extends ObjectPool<Lightning> {
	void set(Lightning mob, float x, float y, float z, float x2, float y2, float z2) {
		mob.p.set(x,y,z);
		mob.p2.set(x2,y2,z2);
		mob.d.set(x2-x,y2-y,z2-z);
		for (float i = 0 ; i < mob.ar.length ; i ++) {
			mob.ar[(int)i].reset(x + mob.d.x/mob.ar.length*i, y + mob.d.y/mob.ar.length*i, z + mob.d.z/mob.ar.length*i);
			mob.ar[(int)i].setM(random(-lightningSetMAmp*de,lightningSetMAmp*de),
				random(-lightningSetMAmp*de,lightningSetMAmp*de), 0,(int)(i/mob.ar.length*binCount*0.25));
		}
		mob.lifeSpan = fpb*4;
		mob.finished = false;
	}

	void add(float x, float y, float z, float x2, float y2, float z2) {
		if (arm == ar.size()) {
			ar.add(0, new Lightning());
			set(getLast(), x,y,z, x2,y2,z2);
		} else {
			Lightning mob = ar.get(arm);
			set(mob, x,y,z, x2,y2,z2);
		}
		arm ++;
	}
}

class Lightning extends Entity {
	PVector p = new PVector();
	PVector p2 = new PVector();
	PVector d = new PVector();
	float lifeSpan;
	IColor[] fillStyle;
	Point[] ar;

	Lightning() {
		int num = (int)random(30,100);
		fillStyle = new IColor[num];
		ar = new Point[num];
		for (int i = 0 ; i < num ; i ++) {
			fillStyle[i] = new IColor(222,222,255,255,10,10,10,0,(int)((float)i/num*binCount));
			ar[i] = new Point();
		}
	}

	void update() {
		lifeSpan --;
		if (lifeSpan <= 0) finished = true;
		for (IColor f : fillStyle) {
			f.update();
		}
		for (Point pp : ar) {
			pp.update();
		}
	}

	void render() {
		push();
		for (int i = 0 ; i < ar.length -1; i ++) {
			fillStyle[i].strokeStyle();
			line(ar[i].p.x,ar[i].p.y,ar[i].p.z, ar[i+1].p.x,ar[i+1].p.y,ar[i+1].p.z);
		}
		pop();
	}
}