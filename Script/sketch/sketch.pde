void setup() {
  background(200);
  noLoop();
}

void draw() {
  String[] name_list = loadStrings("name.txt");
  print(name_list[0]);
  
}
