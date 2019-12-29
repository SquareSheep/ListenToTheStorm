Poly newPoly(String type, PVector p, PVector ang, float w) {
  Poly poly;
  if (type == "Pyramid") {
    poly = new Poly(p, ang, w, new float[]{-1,-1,-1, 1,-1,-1, 1,1,-1, -1,1,-1, 0,0,1},
    new int[][]{new int[]{0,1,2,3}, new int[]{0,1,4}, new int[]{1,2,4}, new int[]{2,3,4}, new int[]{3,0,4}});
  } else if (type == "Box") {
    poly = new Poly(p, ang, w, new float[]{-1,-1,-1, 1,-1,-1, 1,1,-1, -1,1,-1, -1,-1,1, 1,-1,1, 1,1,1, -1,1,1},
    new int[][]{new int[]{0,1,2,3}, new int[]{0,1,5,4}, new int[]{1,2,6,5}, new int[]{2,3,7,6}, new int[]{3,0,4,7}, new int[]{4,5,6,7}});
  } else if (type == "Crystal") {
    poly = new Poly(p, ang, w, new float[]{-1,-1,-1, 1,-1,-1, 1,1,-1, -1,1,-1, -1,-1,1, 1,-1,1, 1,1,1, -1,1,1, 0,2.5,0, 0,-2.5,0},
      new int[][]{new int[]{0,1,2,3}, new int[]{0,1,5,4}, new int[]{1,2,6,5}, new int[]{2,3,7,6}, new int[]{3,0,4,7}, new int[]{4,5,6,7},
      new int[]{9,0,1}, new int[]{9,1,5}, new int[]{9,4,5}, new int[]{9,4,0}}); //0,1,4,5
  }else {
    poly = new Poly();
  }
  return poly;
}

class Poly extends Mob {
  Point[] vert;
  int[][] faces;
  IColor[] fillStyle;
  IColor[] strokeStyle;
  float w;

  Poly(PVector p, PVector ang, float w, float[] vert, int[][] faces) {
    this.p = new Point(p);
    this.ang = new Point(ang);
    this.w = w;
    this.vert = new Point[vert.length/3];
    this.faces = faces;
    fillStyle = new IColor[faces.length];
    strokeStyle = new IColor[faces.length];
    for (int i = 0 ; i < vert.length ; i += 3) {
      this.vert[i/3] = new Point(vert[i]*w, vert[i+1]*w, vert[i+2]*w);
    }
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i] = defaultFill.copy();
      strokeStyle[i] = defaultStroke.copy();
    }
  }

  Poly() {}

  void update() {
    updatePoints();
    for (int i = 0 ; i < vert.length ; i ++) {
      vert[i].update();
    }
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].update();
      strokeStyle[i].update();
    }
  }

  void render() {
    setDraw();
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].fillStyle();
      strokeStyle[i].strokeStyle();
      beginShape();
      for (int k = 0 ; k < faces[i].length ; k ++) {
        vertex(vert[faces[i][k]].p.x, vert[faces[i][k]].p.y, vert[faces[i][k]].p.z);
      }
      vertex(vert[faces[i][0]].p.x, vert[faces[i][0]].p.y, vert[faces[i][0]].p.z);
      endShape();
    }
    pop();
  }

  void fillStyleSet(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, float index) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].set(rc,gc,bc,ac,rm,gm,bm,am,index);
    }
  }

  void fillStyleSetMass(float mass) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].setMass(mass);
    }
  }

  void fillStyleSetVMult(float vMult) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].setVMult(vMult);
    }
  }

  void fillStyleSetx(float rc, float gc, float bc, float ac) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].setx(rc,gc,bc,ac);
    }
  }

  void fillStyleSetX(float rc, float gc, float bc, float ac) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].setX(rc,gc,bc,ac);
    }
  }

  void fillStyleSetM(float rc, float gc, float bc, float ac) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].setM(rc,gc,bc,ac);
    }
  }

  void fillStyleSetM(float rc, float gc, float bc, float ac, float index) {
    fillStyleSetM(rc,gc,bc,ac);
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].index = (int)((index + i*3)%binCount);
    }
  }

  void strokeStyleSet(float rc, float gc, float bc, float ac, float rm, float gm, float bm, float am, float index) {
    for (int i = 0 ; i < faces.length ; i ++) {
      strokeStyle[i].set(rc,gc,bc,ac,rm,gm,bm,am,index);
    }
  }

  void fillStyleSetC(float rc, float gc, float bc, float ac) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].setC(rc,gc,bc,ac);
    }
  }

  void fillStyleIndex(float index) {
    for (int i = 0 ; i < faces.length ; i ++) {
      fillStyle[i].index = (int)abs((index + i - faces.length/2)%binCount);
    }
  }
}