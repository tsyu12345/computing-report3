let n;
let x;
let y;
let vx;
let vy;

let m;
let source;
let target;

const r = 25;

function setup() {
  createCanvas(600, 600);
  initializeGraph(10);
  for (let i = 0; i < n; ++i) {
    x[i] = random(width);
    y[i] = random(height);
  }
  vx.fill(0);
  vy.fill(0);
}

function draw() {
  drawObjects();
  updatePosition();
  updateVelocity();
}

function initializeGraph(k) {
  n = k;
  x =  new Array(n);
  y =  new Array(n);
  vx = new Array(n);
  vy = new Array(n);
  m = 0;
  source = new Array();
  target = new Array();
  for (let i = 0; i < n; ++i) {
    for (let j = i + 1; j < n; ++j) {
      if (random(1) < 0.5) {
        source.push(i);
        target.push(j);
        m += 1;
      }
    }
  }
}

function drawObjects() {
  background(255);
  for (let i = 0; i < m; ++i) {
    const s = source[i];
    const t = target[i];
    line(x[s], y[s], x[t], y[t]);
  }
  for (let i = 0; i < n; ++i) {
    fill(255);
    ellipse(x[i], y[i], 2 * r, 2 * r);
    fill(0);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(i, x[i], y[i]);
  }
}

function updatePosition() {
  for (let i = 0; i < n; ++i) {
    x[i] += vx[i];
    y[i] += vy[i];
  }
}

function updateVelocity() {
  applySpringForce(0.001, 10);
  applyRepulsiveForce(10);
  applyResistanceForce(0.01);
  applyCentering();
}

function applySpringForce(k, L) {
  for (let i = 0; i < m; ++i) {
    const s = source[i];
    const t = target[i];
    const d = dist(x[s], y[s], x[t], y[t]);
    const theta = atan2(y[s] - y[t], x[s] - x[t]);
    const w = k * (L - d);
    vx[s] += w * cos(theta);
    vy[s] += w * sin(theta);
    vx[t] -= w * cos(theta);
    vy[t] -= w * sin(theta);
  }
}

function applyRepulsiveForce(q) {
  for (let i = 0; i < n; ++i) {
    for (let j = 0; j < n; ++j) {
      if (i === j) {
        continue;
      }
      const d = distance(i, j);
      const w = -q / (d * d);
      vx[i] += (x[j] - x[i]) * w;
      vy[i] += (y[j] - y[i]) * w;
    }
  }
}

function applyResistanceForce(k) {
  for (let i = 0; i < n; ++i) {
    vx[i] += -k * vx[i];
    vy[i] += -k * vy[i];
  }
}

function applyCentering() {
  let cx = 0;
  let cy = 0;
  for (let i = 0; i < n; ++i) {
    cx += x[i];
    cy += y[i];
  }
  cx /= n;
  cy /= n;
  for (let i = 0; i < n; ++i) {
    x[i] += -cx + width / 2;
    y[i] += -cy + height / 2;
  }
}

function distance(i, j) {
  const minDistance = 10;
  const d = dist(x[i], y[i], x[j], y[j]);
  if (d < minDistance) {
    return minDistance;
  }
  return d;
}
