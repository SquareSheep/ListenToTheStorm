class MountainRange extends Entity {
	ArrayList<Mountain> ar;
	Point p;
	PVector w;

	MountainRange(PVector p, PVector w) {
		this.p = new Point(p);
		this.w = w;
		ar = new ArrayList<Mountain>();
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

	void addMountains(float num, float z, float minW, float maxW, float minH, float maxH, float minZ, float maxZ) {
		for (int i = 0 ; i < num ; i ++) {
			ar.add(new Mountain(random(-w.x,w.x),0,z*w.z*random(0.9,1.1), random(minW*w.x,maxW*w.x), random(-maxH*w.y,-minH*w.y), random(minZ*w.z,maxZ*w.z)));
		}
	}

	void setFillStyleM(float r, float g, float b, float a, float minI, float maxI) {
		for (int i = 0 ; i < ar.size() ; i ++) {
			ar.get(i).fillStyle.setM(r,g,b,a, (int)((float)i/ar.size()*binCount*(maxI-minI)+binCount*minI));
		}
	}

	void setFillStyleC(float r, float g, float b, float a) {
		for (int i = 0 ; i < ar.size() ; i ++) {
			ar.get(i).fillStyle.setC(r,g,b,a);
		}
	}
}
class Mountain extends Entity {
	Point w;
	Point p;
	IColor fillStyle = new IColor();

	Mountain(float x, float y, float z, float w, float h, float d) {
		this.p = new Point(x,y,z);
		this.w = new Point(w,h,d);
		fillStyle.setMass(15);
		fillStyle.setVMult(0.25);
	}

	void update() {
		p.update();
		w.update();
		fillStyle.update();
	}

	void render() {
		push();
		translate(p.p.x,p.p.y,p.p.z);
		fillStyle.fillStyle();
		beginShape();
		vertex(-w.p.x,0,0);
		vertex(0,w.p.y,0);
		vertex(0,0,w.p.z);
		endShape();
		fillStyle.fillStyle(-25,-25,-25,0);
		beginShape();
		vertex(w.p.x,0,0);
		vertex(0,w.p.y,0);
		vertex(0,0,w.p.z);
		endShape();
		pop();
	}
}