class TriangleGridVisualizer extends Mob {
	int row;
	int col;
	Point[][] ar;
	IColor[] fillStyle;

	TriangleGridVisualizer(PVector p, PVector ang, float w, int row, int col) {
		this.p = new Point(p);
		this.ang = new Point(ang);
		this.w = w;
		this.row = row;
		this.col = col;
		fillStyle = new IColor[col];
		ar = new Point[col][];
		for (int i = 0 ; i < col ; i ++) {
			ar[i] = new Point[row];
		}
		float y = w*row;
		float x = w*col;
		float offset = -w/4;
		for (int i = 0 ; i < col ; i ++) {
			fillStyle[i] = new IColor(75*(1-(float)i/col),125,75*(float)i/col,255, 3,5*(float)i/col,3,0, (float)i/col*binCount);
			for (int k = 0 ; k < row ; k ++) {
				ar[i][k] = new Point(((float)i/col-0.5)*x, ((float)k/row-0.5)*y,0);
				ar[i][k].pm.set(0,0,-de*0.003);
				ar[i][k].index = (i*col+k)%binCount;
				offset *= -1;
			}
		}
	}

	void update() {
		super.update();
		for (int i = 0 ; i < col ; i ++) {
			fillStyle[i].update();
			for (int k = 0 ; k < row ; k ++) {
				ar[i][k].update();
			}
		}
	}

	void render() {
		setDraw();
		for (int i = 0 ; i < col - 1 ; i ++) {
			fillStyle[i].fillStyle();
			beginShape(TRIANGLE_STRIP);
			for (int k = 0 ; k < row ; k ++) {
				if (i % 2 == 1) {
					vertex(ar[i][k].p.x, ar[i][k].p.y, ar[i][k].p.z);
					vertex(ar[i+1][k].p.x, ar[i+1][k].p.y, ar[i+1][k].p.z);
				} else {
					vertex(ar[i+1][k].p.x, ar[i+1][k].p.y, ar[i+1][k].p.z);
					vertex(ar[i][k].p.x, ar[i][k].p.y, ar[i][k].p.z);
				}
			}
			endShape();
		}
		pop();
	}

	void shiftIndex(int shift, float minI, float maxI) {
		for (int i = 0 ; i < col ; i ++) {
			for (int k = 0 ; k < row ; k ++) {
				ar[i][k].index = (int)((ar[i][k].index + shift) % (binCount*(maxI-minI)) + minI*binCount);
			}
			fillStyle[i].index = (int)((fillStyle[i].index + shift) % (binCount*(maxI-minI)) + minI*binCount);
		}
	}

	void setFillStyleC(float r, float g, float b, float a) {
		for (int i = 0 ; i < col ; i ++) {
			fillStyle[i].setC(r,g,b,a);
		}
	}

	void setFillStyleM(float r, float g, float b, float a, float minI, float maxI) {
		for (int i = 0 ; i < col ; i ++) {
			fillStyle[i].setM(r,g,b,a, (int)((float)i/col*binCount*(maxI-minI)+binCount*minI));
		}
	}

	void setFillStyleMass(float mass) {
		for (int i = 0 ; i < col ; i ++) {
			fillStyle[i].setMass(mass);
		}
	}
}