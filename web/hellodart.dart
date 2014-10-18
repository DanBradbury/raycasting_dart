import 'dart:html';
import 'dart:js';
import 'dart:math';
import 'package:game_loop/game_loop_html.dart';
class Array2d<T> {
  List<List<T>> array;
  T defaultValue = null;
  
  Array2d(int width, int height, {T this.defaultValue}) {
    array = new List<List<T>>();
    this.width = width;
    this.height = height;
  }
  
  operator [](int x) => array[x];
  
  void set width(int v) {
    while (array.length > v)
      array.removeLast();
    while (array.length < v) {
      List<T> newList = new List<T>();
      if (array.length > 0) {
        for (int y = 0; y < array.first.length; y++)
          newList.add(defaultValue);
      }
      array.add(newList);
    }
  }
  
  void set height(int v) {
    while (array.first.length > v) {
      for (int x = 0; x < array.length; x++)
        array[x].removeLast();
    }
    while (array.first.length < v) {
      for (int x = 0; x < array.length; x++)
        array[x].add(defaultValue);
    }
  }
}


final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;
final CanvasElement canvas = querySelector("#canvas");
final int TILE_SIZE = 32;
Array2d map = new Array2d<int>(25,25);

int mouse_x=0;
int mouse_y=0;

void main() {
  for(int i=0;i<25;i++){
    for(int j=0;j<25;j++){
      map[i][j] = 0;
    }
  }
  
  Random generator = new Random();
  //for(int i=0;i<10;i++){
    //int q = generator.nextInt(24);
    //int j = generator.nextInt(24);
    map[3][4] = 2;
    map[3][5] = 2;
    map[4][4] = 2;
    map[4][5] = 2;
  //}

  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = ((gameLoop) {
    // Update game logic here.
    for(int i=0;i<25;i++){
      for(int j=0;j<25;j++){
        if(map[i][j]!=2){
          map[i][j] = 0;
        }
      }
    }
    context.canvas.onMouseMove.listen((e) {
      mouse_x = (e.offset.x/TILE_SIZE).floor();
      mouse_y = (e.offset.y/TILE_SIZE).floor();
      plot(mouse_x,mouse_y);
      
    });
    context.canvas.onClick.listen((e) {
    });
    
    for(int i=0;i<=360;i++){
      var rad = i*PI/360;
      var dx = cos(i);
      var dy = sin(i);
      Fov(dx,dy);
    }
  });
  gameLoop.onRender = ((gameLoop) {
    draw(mouse_x,mouse_y);
  });
  gameLoop.start();
}
void plot(x,y){
  if(x>=0&&x<25&&y>=0&&y<25&&map[x][y]!=2){
    map[x][y] = 1;
  }
}

void Fov(x,y){
  var ox = mouse_x+0.5;
  var oy = mouse_y+0.5;
  var wall_found = false;
  for(int i=0;i<10;i++){
    if(ox.floor() >=0 && oy.floor() >= 0 && ox.floor() <25 && oy.floor() < 25 && map[ox.floor()][oy.floor()]==2){
      wall_found = true;
    }
    if(wall_found==false){
      plot(ox.floor(), oy.floor());
      ox += x;
      oy += y;
    }
  }
}

void draw(x,y) {
  drawMap(x,y);
}

void drawMap(x,y) {
  int RED;
  int GREEN;
  for(int i=0;i<25;i++){
      for(int k=0;k<25;k++){
        if(map[i][k]==0){
          RED = 0;
          GREEN = 0;
        }else if(map[i][k]==1){
          RED = 255;
          GREEN = 0;
        }else if(map[i][k]==2){
          GREEN = 255;
          RED = 0;
        }
        if(x == i && y == k && map[i][k] != 2){
          RED = 255;
          GREEN = 0;
        }
        context..beginPath()
        ..setFillColorRgb(RED,GREEN,0)
        ..setStrokeColorRgb(255, 255, 255)
        ..fillRect(TILE_SIZE*i, TILE_SIZE*k, TILE_SIZE, TILE_SIZE)
        ..strokeRect(TILE_SIZE*i, TILE_SIZE*k, TILE_SIZE, TILE_SIZE);
      }
    }
}
