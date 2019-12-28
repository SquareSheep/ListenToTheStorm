class MountainRange extends Entity {
	ArrayList<Peak> ar;
	Point p;
	PVector w;

	MountainRange(PVector p, PVector w) {
		this.p = new Point(p);
		this.w = w;
		ar = new ArrayList<Peak>();
	}

	void update() {
		p.update();
		for (int i = 0 ; i < ar.size() ; i ++) {
			ar.get(i).update();
		}
	}

	void render() {
		push();
		translate(p.p.x, p.p.y, p.p.z);
		for (int i = 0 ; i < ar.size() ; i ++) {
			ar.get(i).render();
		}
		pop();
	}

	void addPeaks(float num, float z, float minW, float maxW, float minH, float maxH, float minZ, float maxZ) {
		for (int i = 0 ; i < num ; i ++) {
			ar.add(new Peak(random(-w.x,w.x),0,z*w.z*random(0.9,1.1), random(minW*w.x,maxW*w.x), random(-maxH*w.y,-minH*w.y), random(minZ*w.z,maxZ*w.z)));
		}
	}

	class Peak extends Entity {
		Point w;
		Point p;
		IColor fillStyle = new IColor(86,80,72,255);

		Peak(float x, float y, float z, float w, float h, float d) {
			this.p = new Point(x,y,z);
			this.w = new Point(w,h,d);
		}

		void update() {
			p.update();
			w.update();
			fillStyle.update();
		}

		void render() {
			push();
			fillStyle.fillStyle();
			translate(p.p.x,p.p.y,p.p.z);
			beginShape();
			vertex(-w.p.x,0,0);
			vertex(0,w.p.y,0);
			vertex(0,0,w.p.z);
			endShape();
			beginShape();
			vertex(w.p.x,0,0);
			vertex(0,w.p.y,0);
			vertex(0,0,w.p.z);
			endShape();
			pop();
		}
	}
}