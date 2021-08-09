int n;
float[] x;
float[] y;
double[] vx;
double[] vy;
int m;
int[] source;
int[] target;
double alpha = 1.0;
int r = 5;

int[] degree;
int maxDegree;

void setup() {
  size(600, 600);
  initializeGraph(77);
  for (int i = 0; i < n; ++i) {
    x[i] = random(width);
    y[i] = random(height);
    vx[i] = 0.0;
    vy[i] = 0.0;
  }
  
}

void draw() {
  background(255);
  drawObjects();
  updatePosition();
  updateVelocity();
}


int[] StrToInt(String[] str_array) {
  int[] int_array = new int[str_array.length];
  for(int i = 0; i < int_array.length; i++) {
    int_array[i] = int(str_array[i]);
  }
  return int_array;
}

void initializeGraph(int k) {
  n = k;
  m = 0;
  x = new float[n];
  y = new float[n];
  vx = new double[n];
  vy = new double[n];
  String[] sorce_list = loadStrings("source.txt");
  String[] target_list = loadStrings("target.txt");
  source = new int[sorce_list.length];
  target = new int[target_list.length];
  source = StrToInt(sorce_list);
  target = StrToInt(target_list);
  degree = new int[n];
  for(int i = 0; i < n; i++) {
    degree[i] = 0;
  }
  m = target.length;
  for(int i = 0; i < m; i++) {
    degree[source[i]] += 1;
    degree[target[i]] += 1;
  }
  maxDegree = degree[0];
  for(int i = 0; i < n; i++) {
    if(degree[i] > maxDegree) {
      maxDegree = degree[i];
    }
  }
}

void drawObjects() {
  String[] weight_list = loadStrings("weight.txt");
  int[] weight = StrToInt(weight_list);
  for (int i = 0; i < m; ++i) {
    int s = source[i];
    int t = target[i];
    int w = weight[i];
    strokeWeight(w/5);
    line(x[s], y[s], x[t], y[t]);
  }
  String[] color_list = loadStrings("group.txt");
  int[] group = StrToInt(color_list);
  int[] colors = {360, 300, 200, 170,150, 130, 100, 70, 50, 30, 0};
  colorMode(HSB, 360, 100, 100);
  for (int i = 0; i < n; ++i) {
    fill(colors[group[i]],100, 100);
    r = 10;
    println(degree[i]);
    println("MAX" + maxDegree);
    ellipse(x[i], y[i], 2 * r, 2 * r);
  }
}

void updatePosition() {
  for (int i = 0; i < n; ++i) {
    x[i] += vx[i];
    y[i] += vy[i];
  }
}

void updateVelocity() {
  double decay = 0.99;
  applySpringForce(0.01, 50);
  applyRepulsiveForce(50);
  applyCenteringForce(0.1);
  applyResistanceForce(1-alpha);
  //applyCentering();
  alpha *= decay;
  //print(alpha);
}

void applySpringForce(float k, int L) {
  for (int i = 0; i < m; ++i) {
    int s = source[i];
    int t = target[i];
    float d = dist(x[s], y[s], x[t], y[t]);
    float theta = atan2(y[s] - y[t], x[s] - x[t]);
    float w = k * (L - d);
    vx[s] += w * cos(theta);
    vy[s] += w * sin(theta);
    vx[t] -= w * cos(theta);
    vy[t] -= w * sin(theta);
  }
}

void applyRepulsiveForce(int q) {
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      if (i == j) {
        continue;
      }
      float d = distance(i, j);
      float w = -q / (d * d);
      vx[i] += (x[j] - x[i]) * w;
      vy[i] += (y[j] - y[i]) * w;
    }
  }
}

void applyResistanceForce(double k) {
  for (int i = 0; i < n; ++i) {
    vx[i] += -k * vx[i];
    vy[i] += -k * vy[i];
  }
}

void applyCentering() {
  int cx = 0;
  int cy = 0;
  for (int i = 0; i < n; ++i) {
    cx += x[i];
    cy += y[i];
  }
  cx /= n;
  cy /= n;
  for (int i = 0; i < n; ++i) {
    x[i] += -cx + width / 2;
    y[i] += -cy + height / 2;
  }
}

void applyCenteringForce(float strength) {
  for (int i = 0; i < n; ++i) {
    vx[i] += (width / 2 - x[i]) * strength;
    vy[i] += (height / 2 - y[i]) * strength;
  }
}

float distance(int i, int j) {
  float minDistance = 10;
  float d = dist(x[i], y[i], x[j], y[j]);
  if (d < minDistance) {
    return minDistance;
  }
  return d;
}
